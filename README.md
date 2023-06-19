# Automated Installation of Large Language Models on UCS X-Series

The provided files will automate the full installation of:
1. Ubuntu 22.04 LTS operating system
2. GCC which is required for development using the NVIDIA parallel computing and programming environment (CUDA)
3. NVIDIA GPU drivers as well as CUDA
4.  Miniconda which is a package, dependency and environment manager for programming languages (IE: python and C++). Miniconda is a minimal distribution of Anaconda that includes only conda, python, pip and some other useful packages. Very useful for data science as it includes a lot of dependencies in the package.
5. AI Monitor is a tool for monitoring CPU, memory, GPU and VRAM utilization on your system
6. WebUI is a simple user interface for testing and fine-tuning large language models
7. OpenAI compatible API
8. Vicuna 7B large language model 

### Pre-requisites

1. UCS X-series w/ X440p PCIe node and NVIDIA A100 GPU
2. Intersight
3. Internet access to download code from GitHub and models from Huggingface

### Create Server Profile

Derive server-profile from bare-metal linux template

### Install OS on Server

Using Intersight select server and perform automated OS install



