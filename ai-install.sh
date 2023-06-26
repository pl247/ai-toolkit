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
# 12.1 that does not work
#sudo wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2204/x86_64/cuda-keyring_1.0-1_all.deb -P /ai/software
#sudo dpkg -i /ai/software/cuda-keyring_1.0-1_all.deb
#sudo apt-get update
#sudo apt-get -y install cuda

# 11.7 for 20.04
#sudo wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/cuda-ubuntu2004.pin -P /ai/software
#sudo mv /ai/software/cuda-ubuntu2004.pin /etc/apt/preferences.d/cuda-repository-pin-600
#sudo wget https://developer.download.nvidia.com/compute/cuda/11.7.0/local_installers/cuda-repo-ubuntu2004-11-7-local_11.7.0-515.43.04-1_amd64.deb -P /ai/software
#sudo dpkg -i /ai/software/cuda-repo-ubuntu2004-11-7-local_11.7.0-515.43.04-1_amd64.deb
#sudo cp /var/cuda-repo-ubuntu2004-11-7-local/cuda-*-keyring.gpg /usr/share/keyrings/
#sudo apt-get update
#sudo apt-get install cuda-11-7
# to remove try sudo apt purge nvidia-*

# 11.7 for 22.04
#sudo wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2204/x86_64/cuda-ubuntu2204.pin -P /ai/software
#sudo mv /ai/software/cuda-ubuntu2204.pin /etc/apt/preferences.d/cuda-repository-pin-600
#sudo wget https://developer.download.nvidia.com/compute/cuda/11.7.0/local_installers/cuda-repo-ubuntu2204-11-7-local_11.7.0-515.43.04-1_amd64.deb -P /ai/software
#sudo dpkg -i /ai/software/cuda-repo-ubuntu2204-11-7-local_11.7.0-515.43.04-1_amd64.deb
#sudo cp /var/cuda-repo-ubuntu2204-11-7-local/cuda-*-keyring.gpg /usr/share/keyrings/
#sudo apt-get update
#sudo apt-get -y install cuda

# 11.8 for 22.04
sudo wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2204/x86_64/cuda-ubuntu2204.pin -P /ai/software
sudo mv /ai/software/cuda-ubuntu2204.pin /etc/apt/preferences.d/cuda-repository-pin-600
sudo wget https://developer.download.nvidia.com/compute/cuda/11.8.0/local_installers/cuda-repo-ubuntu2204-11-8-local_11.8.0-520.61.05-1_amd64.deb -P /ai/software
sudo dpkg -i /ai/software/cuda-repo-ubuntu2204-11-8-local_11.8.0-520.61.05-1_amd64.deb
sudo cp /var/cuda-repo-ubuntu2204-11-8-local/cuda-*-keyring.gpg /usr/share/keyrings/
sudo apt-get update
sudo apt-get -y install cuda


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
conda create -n textgen python=3.10.9
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

# Install first LLM model
echo -e "\n==================Installing LLM Models=================================="
cd /home/ubuntu/text-generation-webui
#python3 download-model.py facebook/opt-350m
#python3 download-model.py TheBloke/vicuna-7B-1.1-HF
#python3 download-model.py TheBloke/vicuna-13B-1.1-HF
#python3 download-model.py TheBloke/Wizard-Vicuna-30B-Uncensored-fp16

# Clean up tasks
echo -e "\n\n===============Restart the system with 'sudo reboot' for GPU to work =="
sleep 3