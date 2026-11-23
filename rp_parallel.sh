#!/usr/bin/env bash
set -euo pipefail

# Run on a single multi-GPU RunPod. No browser or public port required.
# setup              install ComfyUI and the selected Raylight checkout on the pod
# check [manifest]   report missing/incomplete files without network or GPU access
# fetch [manifest]   download only missing files (resume .part files)
# run [api.json]    start a private Comfy backend and wait for this job's result
here=$(cd "$(dirname "$0")" && pwd)
comfy=${COMFY_DIR:-/workspace/ComfyUI}
manifest=${2:-"$here/parallel_presets/flux3.models"}
raylight="$comfy/custom_nodes/raylight"
ref=${RAYLIGHT_BRANCH:-fix_uneven_padding}
case ${1:-help} in
setup)
    if [[ ! -d $comfy ]]; then
        git clone https://github.com/comfyanonymous/ComfyUI "$comfy"
    fi
    if [[ ! -d $raylight ]]; then
        if [[ $ref == fix_uneven_padding ]]; then
            echo "Copy the local fix_uneven_padding checkout to $raylight first, or set RAYLIGHT_BRANCH to a published branch." >&2
            exit 1
        fi
        git clone --branch "$ref" https://github.com/komikndr/raylight "$raylight"
    fi
    [[ $(git -C "$raylight" branch --show-current) == "$ref" ]] || {
        echo "Select $ref in $raylight first." >&2; exit 1;
    }
    python -m pip install -r "$comfy/requirements.txt" -r "$raylight/requirements.txt"
    ;;
check|fetch)
    missing=0
    while read -r file url; do
        [[ -n $file && $file != \#* ]] || continue
        path="$comfy/models/$file"
        complete() {
            [[ -s $1 ]] || return 1
            [[ $file == *.safetensors ]] || return 0
            python - "$1" <<'PY'
import json, os, sys
try:
    with open(sys.argv[1], "rb") as f:
        n = int.from_bytes(f.read(8), "little")
        if not 0 < n <= 100_000_000:
            sys.exit(1)
        header = json.loads(f.read(n))
        end = max(t["data_offsets"][1] for k,t in header.items() if k != "__metadata__")
        sys.exit(os.fstat(f.fileno()).st_size != 8 + n + end)
except (ValueError, KeyError, TypeError, UnicodeError):
    sys.exit(1)
PY
        }
        if complete "$path"; then echo "present: $file"; continue; fi
        echo "missing or incomplete: $file"
        if [[ $1 == check ]]; then missing=1; continue; fi
        mkdir -p "$(dirname "$path")"
        auth=()
        if [[ -n ${HF_TOKEN:-} && $url == https://huggingface.co/* ]]; then auth=(-H "Authorization: Bearer $HF_TOKEN"); fi
        curl --fail --location --retry 3 --continue-at - "${auth[@]}" --output "$path.part" "$url"
        complete "$path.part" || { echo "Incomplete download: $path.part" >&2; exit 1; }
        mv "$path.part" "$path"
    done < "$manifest"
    exit "$missing"
    ;;
run)
    workflow=${2:-"$here/parallel_presets/flux3.api.json"}
    [[ -r $workflow ]] || { echo "Missing API workflow: $workflow" >&2; exit 1; }
    [[ $(git -C "$raylight" branch --show-current) == "$ref" ]] || {
        echo "Expected $ref in $raylight; select or copy that checkout before running." >&2; exit 1;
    }
    [[ -f $comfy/main.py ]] || { echo "Install ComfyUI in $comfy first." >&2; exit 1; }
    port=${PORT:-8199}
    python - "$port" <<'PY'
import socket, sys
with socket.socket() as s:
    s.bind(("127.0.0.1", int(sys.argv[1])))
PY
    logdir=${RUN_DIR:-/workspace/raylight-runs}
    mkdir -p "$logdir"
    log=$(mktemp "$logdir/run-XXXXXXXX.log")
    echo "Server log: $log (Raylight $(git -C "$raylight" rev-parse --short HEAD))"
    python -u "$comfy/main.py" --listen 127.0.0.1 --port "$port" --cache-none >"$log" 2>&1 &
    server=$!
    trap 'kill "$server" 2>/dev/null || true; wait "$server" 2>/dev/null || true' EXIT
    python - "$workflow" "$port" "$server" "$log" <<'PY'
import json, os, sys, time, urllib.error, urllib.request
from pathlib import Path

workflow, port, pid, log = sys.argv[1:]
base = f"http://127.0.0.1:{port}"
def request(path, payload=None):
    data = None if payload is None else json.dumps(payload).encode()
    req = urllib.request.Request(base + path, data, {"Content-Type": "application/json"})
    try:
        with urllib.request.urlopen(req, timeout=30) as r:
            return json.load(r)
    except urllib.error.HTTPError as exc:
        raise SystemExit(exc.read().decode()) from exc

graph = json.loads(Path(workflow).read_text())
graph = graph.get("prompt", graph)
if "nodes" in graph or not all(isinstance(n, dict) and "class_type" in n for n in graph.values()):
    sys.exit("Expected Comfy API-format JSON, not a UI workflow")
inits = [n["inputs"] for n in graph.values() if n["class_type"] in ("RayInitializer", "RayInitializerAdvanced")]
if not inits:
    sys.exit("Workflow has no Raylight initializer")
for inputs in inits:
    u = int(os.getenv("ULYSSES", inputs["ulysses_degree"]))
    r = int(os.getenv("RING", inputs["ring_degree"]))
    inputs.update(ulysses_degree=u, ring_degree=r,
                  GPU=u*r*max(1, inputs["cfg_degree"])*max(1, inputs.get("dp_degree", 1)))
    print(f"Raylight: {inputs['GPU']} GPUs, Ulysses={u}, ring={r}", flush=True)
for n in graph.values():
    kind = n["class_type"]
    inputs = n["inputs"]
    if kind.startswith("Empty") or kind in (
        "Flux2Scheduler", "MiniMaxH3ImageConditioning",
        "MiniMaxH3ImageToVideo", "Kandinsky5ImageToVideo", "Wan22ImageToVideoLatent",
    ):
        for key, env in (("width", "WIDTH"), ("height", "HEIGHT"), ("length", "FRAMES")):
            if env in os.environ and isinstance(inputs.get(key), int):
                inputs[key] = int(os.environ[env])
    if kind == "LTXVEmptyLatentAudio" and "FRAMES" in os.environ:
        inputs["frames_number"] = int(os.environ["FRAMES"])
deadline = time.monotonic() + 600
while time.monotonic() < deadline:
    os.kill(int(pid), 0)
    try:
        request("/system_stats")
        break
    except urllib.error.URLError:
        time.sleep(2)
else:
    sys.exit(f"Server startup timed out: {log}")
job = request("/prompt", {"prompt": graph})["prompt_id"]
print(f"Queued {job}", flush=True)
while True:
    os.kill(int(pid), 0)
    record = request("/history/" + job).get(job)
    if record:
        path = Path(log).with_suffix(".history.json")
        path.write_text(json.dumps(record, indent=2))
        print(f"History and output filenames: {path}")
        sys.exit(0 if record["status"]["status_str"] == "success" else 1)
    time.sleep(3)
PY
    ;;
help|-h|--help)
    sed -n '4,8p' "$0"
    cat <<EOF

Run from any directory on a 2-GPU pod:
  bash "$here/rp_parallel.sh" setup
  bash "$here/rp_parallel.sh" fetch "$here/parallel_presets/wan21.models"
  bash "$here/rp_parallel.sh" run "$here/parallel_presets/wan21.api.json"

Copy the local fix_uneven_padding Raylight checkout into
$raylight first, or set RAYLIGHT_BRANCH to a published branch.
Use the same preset name for the .models manifest and .api.json workflow.
See README.md for the full setup and Ulysses/ring options.
EOF
    ;;
*) echo "Unknown command: $1 (use help)" >&2; exit 2 ;;
esac
