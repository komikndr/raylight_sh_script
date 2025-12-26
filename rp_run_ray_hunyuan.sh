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

if [ ! -d "/workspace/ComfyUI/custom_nodes/ComfyUI-GGUF" ]; then
  git clone https://github.com/city96/ComfyUI-GGUF /workspace/ComfyUI/custom_nodes/ComfyUI-GGUF
  pip install -r /workspace/ComfyUI/custom_nodes/ComfyUI-GGUF/requirements.txt
fi


mkdir -p /workspace/ComfyUI/models/diffusion_models \
         /workspace/ComfyUI/models/text_encoders \
         /workspace/ComfyUI/models/vae

wget -O /workspace/ComfyUI/models/unet/hunyuan-video-t2v-720p-Q4_0.gguf \
  "https://huggingface.co/city96/HunyuanVideo-gguf/resolve/main/hunyuan-video-t2v-720p-Q4_0.gguf?download=true"

wget -O /workspace/ComfyUI/models/text_encoders/llava_llama3_fp8_scaled.safetensors \
  "https://huggingface.co/Comfy-Org/HunyuanVideo_repackaged/resolve/main/split_files/text_encoders/llava_llama3_fp8_scaled.safetensors?download=true"

wget -O /workspace/ComfyUI/models/text_encoders/clip_l.safetensors \
  "https://huggingface.co/Comfy-Org/HunyuanVideo_repackaged/resolve/main/split_files/text_encoders/clip_l.safetensors?download=true"

wget -O /workspace/ComfyUI/models/vae/hunyuan_vae.safetensors \
  "https://huggingface.co/Comfy-Org/HunyuanVideo_repackaged/resolve/main/split_files/vae/hunyuan_video_vae_bf16.safetensors?download=true"
