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

if [ ! -d "/workspace/ComfyUI/custom_nodes/ComfyUI-Easy-Use" ]; then
  git clone https://github.com/yolain/ComfyUI-Easy-Use /workspace/ComfyUI/custom_nodes/ComfyUI-Easy-Use
  pip install -r /workspace/ComfyUI/custom_nodes/ComfyUI-Easy-Use/requirements.txt
fi

mkdir -p /workspace/ComfyUI/models/diffusion_models \
         /workspace/ComfyUI/models/text_encoders \
         /workspace/ComfyUI/models/vae

wget -O /workspace/ComfyUI/models/diffusion_models/radiance.safetensors \
  "https://huggingface.co/lodestones/Chroma1-Radiance/resolve/main/Chroma1-Radiance-v0.4.safetensors?download=true"

wget -O /workspace/ComfyUI/models/diffusion_models/chroma.safetensors \
  "https://huggingface.co/silveroxides/Chroma1-HD-fp8-scaled/resolve/main/Chroma1-HD-fp8_scaled_original_hybrid_large_rev1.safetensors?download=true"

wget -O /workspace/ComfyUI/models/text_encoders/clip_l.safetensors \
  "https://huggingface.co/comfyanonymous/flux_text_encoders/resolve/main/clip_l.safetensors?download=true"

wget -O /workspace/ComfyUI/models/vae/ae.safetensors \
  "https://huggingface.co/Kijai/flux-fp8/resolve/main/flux-vae-bf16.safetensors?download=true"
