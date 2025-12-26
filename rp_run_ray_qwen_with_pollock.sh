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

if [ ! -d "/workspace/ComfyUI/custom_nodes/multigpu" ]; then
  git clone https://github.com/komikndr/ComfyUI-MultiGPU /workspace/ComfyUI/custom_nodes/multigpu
fi

if [ ! -d "/workspace/ComfyUI/custom_nodes/ComfyUI-GGUF" ]; then
  git clone https://github.com/city96/ComfyUI-GGUF /workspace/ComfyUI/custom_nodes/ComfyUI-GGUF
  pip install -r /workspace/ComfyUI/custom_nodes/ComfyUI-GGUF/requirements.txt
fi

if [ ! -d "/workspace/ComfyUI/custom_nodes/ComfyUI-Easy-Use" ]; then
  git clone https://github.com/yolain/ComfyUI-Easy-Use /workspace/ComfyUI/custom_nodes/ComfyUI-Easy-Use
  pip install -r /workspace/ComfyUI/custom_nodes/ComfyUI-Easy-Use/requirements.txt
fi

mkdir -p /workspace/ComfyUI/models/diffusion_models \
         /workspace/ComfyUI/models/text_encoders \
         /workspace/ComfyUI/models/vae

outs=(
  "/workspace/ComfyUI/models/diffusion_models/qwen.gguf"
  "/workspace/ComfyUI/models/text_encoders/qwen_vl.safetensors"
  "/workspace/ComfyUI/models/vae/qwen_vae.safetensors"
  "/workspace/ComfyUI/models/diffusion_models/wan1_3.safetensors"
  "/workspace/ComfyUI/models/text_encoders/umt5xxl.safetensors"
  "/workspace/ComfyUI/models/vae/wanvae2_1.safetensors"
  "/workspace/ComfyUI/models/loras/Wan2_1_self_forcing_dmd_1_3B_lora_rank_32_fp16.safetensors"
)

urls=(
  "https://huggingface.co/QuantStack/Qwen-Image-Edit-GGUF/resolve/main/Qwen_Image_Edit-Q2_K.gguf?download=true"
  "https://huggingface.co/Comfy-Org/Qwen-Image_ComfyUI/resolve/main/split_files/text_encoders/qwen_2.5_vl_7b_fp8_scaled.safetensors"
  "https://huggingface.co/Comfy-Org/Qwen-Image_ComfyUI/resolve/main/split_files/vae/qwen_image_vae.safetensors"
  "https://huggingface.co/Comfy-Org/Wan_2.1_ComfyUI_repackaged/resolve/main/split_files/diffusion_models/wan2.1_t2v_1.3B_fp16.safetensors?download=true"
  "https://huggingface.co/Comfy-Org/Wan_2.1_ComfyUI_repackaged/resolve/main/split_files/text_encoders/umt5_xxl_fp8_e4m3fn_scaled.safetensors?download=true"
  "https://huggingface.co/Comfy-Org/Wan_2.1_ComfyUI_repackaged/resolve/main/split_files/vae/wan_2.1_vae.safetensors?download=true"
  "https://huggingface.co/Kijai/WanVideo_comfy/resolve/main/LoRAs/Wan2_1_self_forcing_1_3B/Wan2_1_self_forcing_dmd_1_3B_lora_rank_32_fp16.safetensors?download=true"
)

for i in "${!urls[@]}"; do
    wget -O "${outs[$i]}" "${urls[$i]}" &
    (( (i + 1) % 8 == 0 )) && wait
done
wait
