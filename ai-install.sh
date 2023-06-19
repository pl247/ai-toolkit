#!/bin/bash
echo "Running commands as a root user..."

# Create software directories
sudo mkdir /ai
sudo mkdir /ai/software

# Get NVIDIA GPU Drivers as well as CUDA
sudo wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2204/x86_64/cuda-keyring_1.0-1_all.deb -P /ai/software
sudo dpkg -i cuda-keyring_1.0-1_all.deb
sudo apt-get update
sudo apt-get -y install cuda

# Get AI Monitor
sudo git -C /ai clone https://github.com/pl247/ai-monitor
sudo chmod a+x /ai/ai-monitor

# Install Miniconda
sudo wget https://repo.anaconda.com/miniconda/Miniconda3-py39_4.12.0-Linux-x86_64.sh -P /ai/software
sudo chmod -v +x /ai/software/Miniconda3-py39_4.12.0-Linux-x86_64.sh
sudo /ai/software/Miniconda3-py39_4.12.0-Linux-x86_64.sh -b -p /ai/miniconda

echo "End of running commands as root."

# Modify PATH
# eval "$(/ai/miniconda/bin/conda shell.bash hook)"
/ai/miniconda/bin/conda shell.bash hook

# Create new conda environment
conda init bash
conda create -n textgen python=3.10.9
conda activate textgen

# Install pytorch
pip3 install torch torchvision torchaudio

# Install web UI
git -C /home/ubuntu clone https://github.com/oobabooga/text-generation-webui
pip install -r /home/ubuntu/text-generation-webui/requirements.txt

# Install first LLM model
cd /home/ubuntu/text-generation-webui
python download-model.py TheBloke/vicuna-7B-1.1-HF
