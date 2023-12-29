#!/usr/bin/env bash
echo "Deleting Automatic1111 Web UI"
rm -rf /workspace/stable-diffusion-webui

echo "Deleting venv"
rm -rf /workspace/venv

echo "Cloning A1111 repo to /workspace"
cd /workspace
git clone --depth=1 https://github.com/AUTOMATIC1111/stable-diffusion-webui.git

echo "Installing Ubuntu updates"
apt update
apt -y upgrade

echo "Creating and activating venv"
cd stable-diffusion-webui
python3 -m venv /workspace/venv
source /workspace/venv/bin/activate

echo "Installing Torch"
pip3 install --no-cache-dir torch==2.0.1+cu118 torchvision torchaudio --index-url https://download.pytorch.org/whl/cu118

echo "Installing xformers"
pip3 install --no-cache-dir xformers==0.0.22

echo "Installing A1111 Web UI"
wget https://raw.githubusercontent.com/ashleykleynhans/runpod-worker-a1111/main/install-automatic.py
python3 -m install-automatic --skip-torch-cuda-test

echo "Cloning ControlNet extension repo"
cd /workspace/stable-diffusion-webui
git clone --depth=1 https://github.com/Mikubill/sd-webui-controlnet.git extensions/sd-webui-controlnet

echo "Installing dependencies for ControlNet"
cd /workspace/stable-diffusion-webui/extensions/sd-webui-controlnet
pip3 install -r requirements.txt

echo "Installing RunPod Serverless dependencies"
cd /workspace/stable-diffusion-webui
pip3 install huggingface_hub runpod

echo "Download checkpoint models"
cd /workspace/stable-diffusion-webui/models/Stable-diffusion
wget https://civitai.com/api/download/models/223670?type=Model&format=SafeTensor&size=pruned&fp=fp16

echo "Downloading SD 1.5 VAE"
cd /workspace/stable-diffusion-webui/models/VAE

echo "Downloading SDXL VAE"

echo "Downloading SD 1.5 ControlNet models"
mkdir -p /workspace/stable-diffusion-webui/models/ControlNet
cd /workspace/stable-diffusion-webui/models/ControlNet

echo "Downloading SDXL ControlNet models"

echo "Downloading Upscalers"
mkdir -p /workspace/stable-diffusion-webui/models/ESRGAN
cd /workspace/stable-diffusion-webui/models/ESRGAN

echo "Creating log directory"
mkdir -p /workspace/logs

echo "Installing config files"
cd /workspace/stable-diffusion-webui
rm webui-user.sh config.json ui-config.json
wget https://raw.githubusercontent.com/ashleykleynhans/runpod-worker-a1111/main/webui-user.sh
wget https://raw.githubusercontent.com/ashleykleynhans/runpod-worker-a1111/main/config.json
wget https://raw.githubusercontent.com/ashleykleynhans/runpod-worker-a1111/main/ui-config.json

echo "Starting A1111 Web UI"
deactivate
export HF_HOME="/workspace"
cd /workspace/stable-diffusion-webui
./webui.sh -f
