#!/bin/bash
echo -e "\nRunning commands as a root user..."

# Create software directories
echo -e "\n==================Creating software directories==========================="
sleep 3
sudo mkdir /ai
sudo mkdir /ai/software

# Get NVIDIA GPU Drivers
echo -e "\n==================Get NVIDIA GPU Drivers and CUDA========================="
sleep 3
wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2204/x86_64/cuda-keyring_1.1-1_all.deb
sudo dpkg -i cuda-keyring_1.1-1_all.deb
sudo apt-get update
sudo apt-get -y install cuda-toolkit-12-4 nvidia-driver-550-open cuda-drivers-550

# Get AI Monitor
echo -e "\n==================Get AI Monitor========================================="
sleep 3
sudo git -C /ai clone https://github.com/pl247/ai-monitor
sudo chmod a+x /ai/ai-monitor
sudo chmod a+x /ai/ai-monitor/ai-monitor.py

# Install Miniconda
echo -e "\n==================Get Miniconda=========================================="
sleep 3
sudo wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -P /ai/software
sudo chmod -v +x /ai/software/Miniconda3-latest-Linux-x86_64.sh
sudo /ai/software/Miniconda3-latest-Linux-x86_64.sh -b -p /ai/miniconda

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
conda create -n textgen python=3.11 -y
conda activate textgen

# Install pytorch
echo -e "\n==================Installing Pytorch====================================="
sleep 1
#pip3 install torch==2.2.1 torchvision==0.17.1 torchaudio==2.2.1 --index-url https://download.pytorch.org/whl/cu121
pip3 install torch==2.2.2 torchvision==0.17.2 torchaudio==2.2.2 --index-url https://download.pytorch.org/whl/cu121

# Install web UI
echo -e "\n==================Installing WebUI======================================="
sleep 1
git -C /home/ubuntu clone https://github.com/oobabooga/text-generation-webui textgen
pip3 install -r /home/ubuntu/textgen/requirements.txt

# Install web UI
#echo -e "\n==================Installing WebUI======================================="
#sleep 1
#git -C /home/ubuntu clone https://github.com/pl247/textgen
#pip install -r /home/ubuntu/textgen/requirements.txt
#/home/ubuntu/start_linux.sh

# Install private document inferencing
echo -e "\n==================Installing Document Inferencing (RAG) =================="
conda init bash
conda create -n docs python=3.10.9 -y
conda activate docs
sleep 1
git -C /home/ubuntu clone https://github.com/pl247/docs docs
pip install -r /home/ubuntu/docs/requirements.txt

# Install first LLM model
echo -e "\n==================Installing LLM Models=================================="
cd /home/ubuntu/textgen
#very small model
#python3 download-model.py facebook/opt-350m
#If you have only 24GB VRAM
#python3 download-model.py lmsys/vicuna-7b-v1.5
python3 download-model.py microsoft/Phi-3-mini-4k-instruct

# If you have 80GB VRAM
#python3 download-model.py TheBloke/Wizard-Vicuna-30B-Uncensored-fp16
#If you have only 24GB VRAM
#python3 download-model.py lmsys/vicuna-7b-v1.5

# Making scripts executable
echo -e "\n==================Making Scripts Executable============================="

wget https://raw.githubusercontent.com/pl247/ai-toolkit/main/textgen -P ~/textgen
chmod a+x ~/textgen/textgen
chmod a+x ~/docs/show_files
chmod a+x ~/docs/learn_docs
chmod a+x ~/docs/get_ucs_docs
chmod a+x ~/docs/delete_db
chmod a+x ~/docs/rag

# Clean up tasks
echo -e "\n\n===============Restart the system with 'sudo reboot' for GPU to work =="
sleep 3