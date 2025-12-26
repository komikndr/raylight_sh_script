#!/bin/bash
set -e

mkdir -p /workspace

if [ ! -d "/workspace/ComfyUI" ]; then
  git clone https://github.com/comfyanonymous/ComfyUI /workspace/ComfyUI
  pip install -r /workspace/ComfyUI/requirements.txt
fi

if [ ! -d "/workspace/ComfyUI/custom_nodes/raylight" ]; then
  git clone https://github.com/komikndr/raylight /workspace/ComfyUI/custom_nodes/raylight
  pip install -r /workspace/ComfyUI/custom_nodes/raylight/requirements.txt
fi

if [ ! -f "/workspace/flash_attn-2.8.2+cu128torch2.7-cp311-cp311-linux_x86_64.whl" ]; then
  wget -O /workspace/flash_attn-2.8.2+cu128torch2.7-cp311-cp311-linux_x86_64.whl \
    https://github.com/mjun0812/flash-attention-prebuild-wheels/releases/download/v0.3.14/flash_attn-2.8.2+cu128torch2.7-cp311-cp311-linux_x86_64.whl
  pip install /workspace/flash_attn-2.8.2+cu128torch2.7-cp311-cp311-linux_x86_64.whl
fi

if [ ! -d "/workspace/ComfyUI/custom_nodes/ComfyUI-Easy-Use" ]; then
  git clone https://github.com/yolain/ComfyUI-Easy-Use /workspace/ComfyUI/custom_nodes/ComfyUI-Easy-Use
  pip install -r /workspace/ComfyUI/custom_nodes/ComfyUI-Easy-Use/requirements.txt
fi

mkdir -p /workspace/ComfyUI/models/diffusion_models \
         /workspace/ComfyUI/models/text_encoders \
         /workspace/ComfyUI/models/vae

wget -O /workspace/ComfyUI/models/diffusion_models/flux_krea.safetensors \
  "https://huggingface.co/Comfy-Org/FLUX.1-Krea-dev_ComfyUI/resolve/main/split_files/diffusion_models/flux1-krea-dev_fp8_scaled.safetensors?download=true"

wget -O /workspace/ComfyUI/models/text_encoders/t5xxl.safetensors \
  "https://huggingface.co/comfyanonymous/flux_text_encoders/resolve/main/t5xxl_fp8_e4m3fn.safetensors"

wget -O /workspace/ComfyUI/models/text_encoders/clip_l.safetensors \
  "https://huggingface.co/comfyanonymous/flux_text_encoders/resolve/main/clip_l.safetensors?download=true"

wget -O /workspace/ComfyUI/models/vae/ae.safetensors \
  "https://huggingface.co/Kijai/flux-fp8/resolve/main/flux-vae-bf16.safetensors?download=true"
