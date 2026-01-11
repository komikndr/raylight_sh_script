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

if [ ! -d "/workspace/ComfyUI/custom_nodes/ComfyUI-LTXVideo" ]; then
  git clone https://github.com/Lightricks/ComfyUI-LTXVideo /workspace/ComfyUI/custom_nodes/ComfyUI-LTXVideo
  pip install -r /workspace/ComfyUI/custom_nodes/ComfyUI-LTXVideo/requirements.txt
fi

pip install nvitop

mkdir -p /workspace/ComfyUI/models/diffusion_models \
         /workspace/ComfyUI/models/text_encoders \
         /workspace/ComfyUI/models/vae

wget -O /workspace/ComfyUI/models/diffusion_models/ltx-2-19b-distilled-fp8_transformer_only.safetensors \
  "https://huggingface.co/Kijai/LTXV2_comfy/resolve/main/diffusion_models/ltx-2-19b-distilled-fp8_transformer_only.safetensors?download=true" &

wget -O /workspace/ComfyUI/models/text_encoders/gemma_3_12B_it_fp8_e4m3fn.safetensors \
  "https://huggingface.co/GitMylo/LTX-2-comfy_gemma_fp8_e4m3fn/resolve/main/gemma_3_12B_it_fp8_e4m3fn.safetensors?download=true" &

wget -O /workspace/ComfyUI/models/text_encoders/ltx-2-19b-embeddings_connector_dev_bf16.safetensors \
  "https://huggingface.co/Kijai/LTXV2_comfy/resolve/main/text_encoders/ltx-2-19b-embeddings_connector_dev_bf16.safetensors?download=true" &

wget -O /workspace/ComfyUI/models/vae/LTX2_audio_vae_bf16.safetensors \
  "https://huggingface.co/Kijai/LTXV2_comfy/resolve/main/VAE/LTX2_audio_vae_bf16.safetensors?download=true" &

wget -O /workspace/ComfyUI/models/vae/LTX2_video_vae_bf16.safetensors \
  "https://huggingface.co/Kijai/LTXV2_comfy/resolve/main/VAE/LTX2_video_vae_bf16.safetensors?download=true" &

wait
