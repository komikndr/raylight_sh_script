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

if [ ! -d "/workspace/ComfyUI/custom_nodes/ComfyUI-GGUF" ]; then
  git clone https://github.com/city96/ComfyUI-GGUF /workspace/ComfyUI/custom_nodes/ComfyUI-GGUF
  pip install -r /workspace/ComfyUI/custom_nodes/ComfyUI-GGUF/requirements.txt
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

wget -O /workspace/ComfyUI/models/diffusion_models/wan.gguf \
  "https://huggingface.co/city96/Wan2.1-T2V-14B-gguf/resolve/main/wan2.1-t2v-14b-Q4_0.gguf?download=true"

wget -O /workspace/ComfyUI/models/text_encoders/umt5xxl.safetensors \
  "https://huggingface.co/Comfy-Org/Wan_2.1_ComfyUI_repackaged/resolve/main/split_files/text_encoders/umt5_xxl_fp8_e4m3fn_scaled.safetensors?download=true"

wget -O /workspace/ComfyUI/models/vae/wanvae2_1.safetensors \
  "https://huggingface.co/Comfy-Org/Wan_2.1_ComfyUI_repackaged/resolve/main/split_files/vae/wan_2.1_vae.safetensors?download=true"

wget -O /workspace/ComfyUI/models/loras/self_lx2v.safetensors\
  "https://huggingface.co/Kijai/WanVideo_comfy/resolve/main/Lightx2v/lightx2v_T2V_14B_cfg_step_distill_v2_lora_rank32_bf16.safetensors?download=true"
