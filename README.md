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
bash "$runner/rp_parallel.sh" run "$runner/parallel_presets/wan21.api.json" --fsdp
```

Pick a preset in [`parallel_presets/`](parallel_presets/) and use the same name for its `.models` manifest and `.api.json` workflow. `check` takes the same manifest as `fetch` and reports missing or incomplete weights without downloading. `fetch` skips complete weights. Set `HF_TOKEN` in the pod environment before fetching gated weights like FLUX.3.

The presets default to **Ulysses 2 / ring 1**. After fetching `flux3.models`, you can compare with:

```bash
ULYSSES=1 RING=2 WIDTH=1040 HEIGHT=1040 \
  bash "$runner/rp_parallel.sh" run "$runner/parallel_presets/flux3.api.json" --fsdp
```

Video presets with a configurable latent length also accept `FRAMES`; use a frame count supported by that model. `COMFY_DIR` overrides `/workspace/ComfyUI`. The runner starts a private ComfyUI server, waits for the job, and stops the server. Outputs go under ComfyUI's `output/raylight_runpod/`; the server log and job history go under `/workspace/raylight-runs/` by default (`RUN_DIR` overrides it). No browser or public port is needed.

### Copy-paste commands for every preset

Run setup once as shown above. Then copy the block for the model you want. `fetch` only needs to complete once per preset; `run` uses the already-downloaded weights.

`--fsdp` enables diffusion-model weight sharding for that run without changing the saved workflow. It does not enable CPU offload. Remove the flag to use the workflow’s default. These presets have not been validated on GPUs with FSDP.

#### `anima`

```bash
bash "$runner/rp_parallel.sh" fetch "$runner/parallel_presets/anima.models"
bash "$runner/rp_parallel.sh" run "$runner/parallel_presets/anima.api.json" --fsdp
```

#### `boogu`

```bash
bash "$runner/rp_parallel.sh" fetch "$runner/parallel_presets/boogu.models"
bash "$runner/rp_parallel.sh" run "$runner/parallel_presets/boogu.api.json" --fsdp
```

#### `chroma`

```bash
bash "$runner/rp_parallel.sh" fetch "$runner/parallel_presets/chroma.models"
bash "$runner/rp_parallel.sh" run "$runner/parallel_presets/chroma.api.json" --fsdp
```

#### `cosmos_predict2`

```bash
bash "$runner/rp_parallel.sh" fetch "$runner/parallel_presets/cosmos_predict2.models"
bash "$runner/rp_parallel.sh" run "$runner/parallel_presets/cosmos_predict2.api.json" --fsdp
```

#### `cosmos_video`

```bash
bash "$runner/rp_parallel.sh" fetch "$runner/parallel_presets/cosmos_video.models"
bash "$runner/rp_parallel.sh" run "$runner/parallel_presets/cosmos_video.api.json" --fsdp
```

#### `ernie_image`

```bash
bash "$runner/rp_parallel.sh" fetch "$runner/parallel_presets/ernie_image.models"
bash "$runner/rp_parallel.sh" run "$runner/parallel_presets/ernie_image.api.json" --fsdp
```

#### `flux2`

```bash
bash "$runner/rp_parallel.sh" fetch "$runner/parallel_presets/flux2.models"
bash "$runner/rp_parallel.sh" run "$runner/parallel_presets/flux2.api.json" --fsdp
```

#### `flux3`

```bash
bash "$runner/rp_parallel.sh" fetch "$runner/parallel_presets/flux3.models"
bash "$runner/rp_parallel.sh" run "$runner/parallel_presets/flux3.api.json" --fsdp
```

#### `flux_krea`

```bash
bash "$runner/rp_parallel.sh" fetch "$runner/parallel_presets/flux_krea.models"
bash "$runner/rp_parallel.sh" run "$runner/parallel_presets/flux_krea.api.json" --fsdp
```

#### `hidream_o1`

```bash
bash "$runner/rp_parallel.sh" fetch "$runner/parallel_presets/hidream_o1.models"
bash "$runner/rp_parallel.sh" run "$runner/parallel_presets/hidream_o1.api.json" --fsdp
```

#### `hunyuan_video`

```bash
bash "$runner/rp_parallel.sh" fetch "$runner/parallel_presets/hunyuan_video.models"
bash "$runner/rp_parallel.sh" run "$runner/parallel_presets/hunyuan_video.api.json" --fsdp
```

#### `hunyuan_video15`

```bash
bash "$runner/rp_parallel.sh" fetch "$runner/parallel_presets/hunyuan_video15.models"
bash "$runner/rp_parallel.sh" run "$runner/parallel_presets/hunyuan_video15.api.json" --fsdp
```

#### `kandinsky5`

```bash
bash "$runner/rp_parallel.sh" fetch "$runner/parallel_presets/kandinsky5.models"
bash "$runner/rp_parallel.sh" run "$runner/parallel_presets/kandinsky5.api.json" --fsdp
```

#### `krea2`

```bash
bash "$runner/rp_parallel.sh" fetch "$runner/parallel_presets/krea2.models"
bash "$runner/rp_parallel.sh" run "$runner/parallel_presets/krea2.api.json" --fsdp
```

#### `lens`

```bash
bash "$runner/rp_parallel.sh" fetch "$runner/parallel_presets/lens.models"
bash "$runner/rp_parallel.sh" run "$runner/parallel_presets/lens.api.json" --fsdp
```

#### `ltx2`

```bash
bash "$runner/rp_parallel.sh" fetch "$runner/parallel_presets/ltx2.models"
bash "$runner/rp_parallel.sh" run "$runner/parallel_presets/ltx2.api.json" --fsdp
```

#### `ltx23`

```bash
bash "$runner/rp_parallel.sh" fetch "$runner/parallel_presets/ltx23.models"
bash "$runner/rp_parallel.sh" run "$runner/parallel_presets/ltx23.api.json" --fsdp
```

#### `ltxv`

```bash
bash "$runner/rp_parallel.sh" fetch "$runner/parallel_presets/ltxv.models"
bash "$runner/rp_parallel.sh" run "$runner/parallel_presets/ltxv.api.json" --fsdp
```

#### `lumina2`

```bash
bash "$runner/rp_parallel.sh" fetch "$runner/parallel_presets/lumina2.models"
bash "$runner/rp_parallel.sh" run "$runner/parallel_presets/lumina2.api.json" --fsdp
```

#### `minimax_h3_image`

```bash
bash "$runner/rp_parallel.sh" fetch "$runner/parallel_presets/minimax_h3_image.models"
bash "$runner/rp_parallel.sh" run "$runner/parallel_presets/minimax_h3_image.api.json" --fsdp
```

#### `minimax_h3_video`

```bash
bash "$runner/rp_parallel.sh" fetch "$runner/parallel_presets/minimax_h3_video.models"
bash "$runner/rp_parallel.sh" run "$runner/parallel_presets/minimax_h3_video.api.json" --fsdp
```

#### `moss_image`

```bash
bash "$runner/rp_parallel.sh" fetch "$runner/parallel_presets/moss_image.models"
bash "$runner/rp_parallel.sh" run "$runner/parallel_presets/moss_image.api.json" --fsdp
```

#### `omnigen2`

```bash
bash "$runner/rp_parallel.sh" fetch "$runner/parallel_presets/omnigen2.models"
bash "$runner/rp_parallel.sh" run "$runner/parallel_presets/omnigen2.api.json" --fsdp
```

#### `pan2`

```bash
bash "$runner/rp_parallel.sh" fetch "$runner/parallel_presets/pan2.models"
bash "$runner/rp_parallel.sh" run "$runner/parallel_presets/pan2.api.json" --fsdp
```

#### `pixeldit`

```bash
bash "$runner/rp_parallel.sh" fetch "$runner/parallel_presets/pixeldit.models"
bash "$runner/rp_parallel.sh" run "$runner/parallel_presets/pixeldit.api.json" --fsdp
```

#### `qwen_image`

```bash
bash "$runner/rp_parallel.sh" fetch "$runner/parallel_presets/qwen_image.models"
bash "$runner/rp_parallel.sh" run "$runner/parallel_presets/qwen_image.api.json" --fsdp
```

#### `qwen_image21`

```bash
bash "$runner/rp_parallel.sh" fetch "$runner/parallel_presets/qwen_image21.models"
bash "$runner/rp_parallel.sh" run "$runner/parallel_presets/qwen_image21.api.json" --fsdp
```

#### `wan21`

```bash
bash "$runner/rp_parallel.sh" fetch "$runner/parallel_presets/wan21.models"
bash "$runner/rp_parallel.sh" run "$runner/parallel_presets/wan21.api.json" --fsdp
```

#### `wan22`

```bash
bash "$runner/rp_parallel.sh" fetch "$runner/parallel_presets/wan22.models"
bash "$runner/rp_parallel.sh" run "$runner/parallel_presets/wan22.api.json" --fsdp
```

#### `z_image`

```bash
bash "$runner/rp_parallel.sh" fetch "$runner/parallel_presets/z_image.models"
bash "$runner/rp_parallel.sh" run "$runner/parallel_presets/z_image.api.json" --fsdp
```

**My Referral, so i can freely test Raylight without buying second GPU**
https://runpod.io?ref=yruu07gh
