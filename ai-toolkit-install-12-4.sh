#!/bin/bash
echo -e "\nRunning commands as a root user..."

# Create software directories
echo -e "\n==================Creating software directories==========================="
sleep 3
sudo mkdir /ai
sudo mkdir /ai/software

# Get NVIDIA GPU Drivers as well as CUDA
echo -e "\n==================Get NVIDIA GPU Drivers as well as CUDA=================="
sleep 3

# 12.4 for 22.04
sudo apt install nvidia-driver-550-open
sudo apt install cuda-toolkit-12-4

# Get AI Monitor
echo -e "\n==================Get AI Monitor========================================="
sleep 3
sudo git -C /ai clone https://github.com/pl247/ai-monitor
sudo chmod a+x /ai/ai-monitor

# Install Miniconda
echo -e "\n==================Get Miniconda=========================================="
sleep 3
sudo wget https://repo.anaconda.com/miniconda/Miniconda3-py39_4.12.0-Linux-x86_64.sh -P /ai/software
sudo chmod -v +x /ai/software/Miniconda3-py39_4.12.0-Linux-x86_64.sh
sudo /ai/software/Miniconda3-py39_4.12.0-Linux-x86_64.sh -b -p /ai/miniconda

echo -e "\nEnd of running commands as root."

# Modify PATH
echo -e "\n==================Updating PATH=========================================="
sleep 1
eval "$(/ai/miniconda/bin/conda shell.bash hook)"
echo 'export PATH="/ai/miniconda/bin:/ai/miniconda/condabin:/usr/local/cuda/bin:$PATH"' >> ~/.bashrc
echo 'export LD_LIBRARY_PATH="/usr/local/cuda/lib64:$LD_LIBRARY_PATH"' >> ~/.bashrc
source .bashrc

# Create new conda environment
echo -e "\n==================Create New Conda Environment==========================="
sleep 1
conda init bash
conda create -n textgen python=3.10.9 -y
conda activate textgen

# Install pytorch
echo -e "\n==================Installing Pytorch====================================="
sleep 1
pip3 install torch torchvision torchaudio

# Install web UI
echo -e "\n==================Installing WebUI======================================="
sleep 1
git -C /home/ubuntu clone https://github.com/oobabooga/text-generation-webui
pip install -r /home/ubuntu/text-generation-webui/requirements.txt

# Install private document inferencing
echo -e "\n==================Installing Document Inferencing======================================="
conda init bash
conda create -n docs python=3.10.9 -y
conda activate docs
sleep 1
git -C /home/ubuntu clone https://github.com/PromtEngineer/localGPT doc-inferencing
pip install -r /home/ubuntu/doc-inferencing/requirements.txt

# Install first LLM model
echo -e "\n==================Installing LLM Models=================================="
cd /home/ubuntu/text-generation-webui
python3 download-model.py facebook/opt-350m
#python3 download-model.py TheBloke/vicuna-7B-1.1-HF
#python3 download-model.py TheBloke/vicuna-13B-1.1-HF
#python3 download-model.py TheBloke/Wizard-Vicuna-30B-Uncensored-fp16
#python3 download-model.py mistralai/Mistral-7B-Instruct-v0.2

# Clean up tasks
echo -e "\n\n===============Restart the system with 'sudo reboot' for GPU to work =="
sleep 3