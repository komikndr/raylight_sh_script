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

if [ ! -d "/workspace/ComfyUI/custom_nodes/ComfyUI-KJNodes" ]; then
  git clone https://github.com/kijai/ComfyUI-KJNodes /workspace/ComfyUI/custom_nodes/ComfyUI-KJNodes
  pip install -r /workspace/ComfyUI/custom_nodes/ComfyUI-KJNodes/requirements.txt
fi

pip install nvitop

mkdir -p \
  /workspace/ComfyUI/models/diffusion_models \
  /workspace/ComfyUI/models/text_encoders \
  /workspace/ComfyUI/models/vae \
  /workspace/ComfyUI/models/loras

# MiniMax-H3 Ref2VA INT8 ConvRot
wget -c \
  -O /workspace/ComfyUI/models/diffusion_models/minimax_h3_ref2va_pruned_int8_convrot.safetensors \
  "https://huggingface.co/Comfy-Org/MiniMax-H3/resolve/main/diffusion_models/minimax_h3_ref2va_pruned_int8_convrot.safetensors?download=true" &

# MiniMax-H3 Ref2VA W4A8 mixed
wget -c \
  -O /workspace/ComfyUI/models/diffusion_models/minimax_h3_ref2va_pruned_w4a8_mixed.safetensors \
  "https://huggingface.co/Kijai/MiniMax-H3-experimental/resolve/main/minimax_h3_ref2va_pruned_w4a8_mixed.safetensors?download=true" &

# Qwen3-VL 32B text encoder
wget -c \
  -O /workspace/ComfyUI/models/text_encoders/qwen3vl_32b_minimax_h3_nvfp4_awq.safetensors \
  "https://huggingface.co/Comfy-Org/MiniMax-H3/resolve/main/text_encoders/qwen3vl_32b_minimax_h3_nvfp4_awq.safetensors?download=true" &

# Video VAE
wget -c \
  -O /workspace/ComfyUI/models/vae/minimax_h3_video_vae_fp16.safetensors \
  "https://huggingface.co/Comfy-Org/MiniMax-H3/resolve/main/vae/minimax_h3_video_vae_fp16.safetensors?download=true" &

# Audio VAE
wget -c \
  -O /workspace/ComfyUI/models/vae/minimax_h3_audio_vae_fp32.safetensors \
  "https://huggingface.co/Comfy-Org/MiniMax-H3/resolve/main/vae/minimax_h3_audio_vae_fp32.safetensors?download=true" &

# MiniMax-H3 Ref2VA 8-step acceleration LoRA
wget -c \
  -O /workspace/ComfyUI/models/loras/MiniMax-H3-Ref2VA-Acc-8Step_pruned_comfy.safetensors \
  "https://huggingface.co/Kijai/MiniMax-H3-experimental/resolve/main/loras/MiniMax-H3-Ref2VA-Acc-8Step_pruned_comfy.safetensors?download=true" &

wait

echo "MiniMax-H3 models and LoRA downloaded successfully."
