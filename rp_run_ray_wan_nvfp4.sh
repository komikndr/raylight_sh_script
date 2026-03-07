#!/bin/bash
set -e

mkdir -p /workspace

if [ ! -d "/workspace/ComfyUI" ]; then
  git clone https://github.com/comfyanonymous/ComfyUI /workspace/ComfyUI
  pip install -r /workspace/ComfyUI/requirements.txt
fi

if [ ! -d "/workspace/ComfyUI/custom_nodes/raylight" ]; then
  git clone https://github.com/komikndr/raylight /workspace/ComfyUI/custom_nodes/raylight
  cd /workspace/ComfyUI/custom_nodes/raylight
  git checkout dev
  pip install -r requirements.txt
fi

if [ ! -d "/workspace/ComfyUI/custom_nodes/ComfyUI-Easy-Use" ]; then
  git clone https://github.com/yolain/ComfyUI-Easy-Use /workspace/ComfyUI/custom_nodes/ComfyUI-Easy-Use
  pip install -r /workspace/ComfyUI/custom_nodes/ComfyUI-Easy-Use/requirements.txt
fi

mkdir -p /workspace/ComfyUI/models/diffusion_models \
         /workspace/ComfyUI/models/text_encoders \
         /workspace/ComfyUI/models/vae \
         /workspace/ComfyUI/models/loras

wget -O /workspace/ComfyUI/models/diffusion_models/wan_i2v_nvfp4.safetensors \
  "https://huggingface.co/lightx2v/Wan-NVFP4/resolve/main/wan2.1_i2v_480p_nvfp4_lightx2v_4step.safetensors?download=true" &

wget -O /workspace/ComfyUI/models/diffusion_models/wan_t2v_nvfp4.safetensors \
  "https://huggingface.co/lightx2v/Wan-NVFP4/resolve/main/wan2.1_t2v_1_3b_nvfp4_lightx2v_4step.safetensors?download=true" &

wget -O /workspace/ComfyUI/models/text_encoders/umt5xxl.safetensors \
  "https://huggingface.co/Comfy-Org/Wan_2.1_ComfyUI_repackaged/resolve/main/split_files/text_encoders/umt5_xxl_fp8_e4m3fn_scaled.safetensors?download=true" &

wget -O /workspace/ComfyUI/models/vae/wanvae2_1.safetensors \
  "https://huggingface.co/Comfy-Org/Wan_2.1_ComfyUI_repackaged/resolve/main/split_files/vae/wan_2.1_vae.safetensors?download=true" &

wget -O /workspace/ComfyUI/models/loras/self_lx2v.safetensors \
  "https://huggingface.co/Kijai/WanVideo_comfy/resolve/main/Lightx2v/lightx2v_T2V_14B_cfg_step_distill_v2_lora_rank32_bf16.safetensors?download=true" &

wget -O /workspace/ComfyUI/models/loras/Wan2_1_self_forcing_dmd_1_3B_lora_rank_32_fp16.safetensors \
  "https://huggingface.co/Kijai/WanVideo_comfy/resolve/main/LoRAs/Wan2_1_self_forcing_1_3B/Wan2_1_self_forcing_dmd_1_3B_lora_rank_32_fp16.safetensors?download=true" &

wait
