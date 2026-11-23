# How

1. Put in the root folder `/`, so the file location would be `/rp_run_ray_14fp8.sh`
2. on the current placement of file location do `chmod +x rp_run_ray_14fp8.sh`
3. `./rp_run_ray_14fp8.sh`
4. Modified it if you want, ask LLM. 

## Headless 2-GPU RunPod workflows

Clone this repo on the pod. Unlike the older per-model scripts, `rp_parallel.sh` separates setup, model downloads, and generation. You can run it from `/` or any other directory.

```bash
git clone https://github.com/komikndr/raylight_sh_script.git /workspace/raylight-runner
runner=/workspace/raylight-runner
```

By default the runner expects the **local** `fix_uneven_padding` Raylight branch. Make sure ComfyUI exists at `/workspace/ComfyUI`, then copy your Raylight checkout (including `.git` and any uncommitted fixes) to `/workspace/ComfyUI/custom_nodes/raylight/`. That branch is not published. Alternatively, export `RAYLIGHT_BRANCH=dev` before setup and run to use the published branch; it won't include unpublished padding fixes. `setup` clones missing repos for a published branch and installs dependencies. It does not switch an existing checkout for you.

```bash
bash "$runner/rp_parallel.sh" setup
bash "$runner/rp_parallel.sh" fetch "$runner/parallel_presets/wan21.models"
bash "$runner/rp_parallel.sh" run "$runner/parallel_presets/wan21.api.json"
```

Pick a preset in [`parallel_presets/`](parallel_presets/) and use the same name for its `.models` manifest and `.api.json` workflow. `check` takes the same manifest as `fetch` and reports missing or incomplete weights without downloading. `fetch` skips complete weights. Set `HF_TOKEN` in the pod environment before fetching gated weights like FLUX.3.

The presets default to **Ulysses 2 / ring 1**. After fetching `flux3.models`, you can compare with:

```bash
ULYSSES=1 RING=2 WIDTH=1040 HEIGHT=1040 \
  bash "$runner/rp_parallel.sh" run "$runner/parallel_presets/flux3.api.json"
```

Video presets with a configurable latent length also accept `FRAMES`; use a frame count supported by that model. `COMFY_DIR` overrides `/workspace/ComfyUI`. The runner starts a private ComfyUI server, waits for the job, and stops the server. Outputs go under ComfyUI's `output/raylight_runpod/`; the server log and job history go under `/workspace/raylight-runs/` by default (`RUN_DIR` overrides it). No browser or public port is needed.

**My Referral, so i can freely test Raylight without buying second GPU**
https://runpod.io?ref=yruu07gh
