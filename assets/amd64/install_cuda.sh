#!/bin/bash
# nvidia echo "ironment

# path setup
echo "PATH=/usr/local/cuda-10.1/bin:${PATH}" >> /etc/environment
echo "LD_LIBRARY_PATH=/usr/local/cuda/lib64:/usr/local/cuda/extras/CUPTI/lib64:${LD_LIBRARY_PATH}" >> /etc/environment
echo "LIBRARY_PATH=/usr/local/cuda/lib64/stubs" >> /etc/environment
# hostside requirement check
echo "NVIDIA_REQUIRE_CUDA="cuda>=10.1 brand=tesla,driver>=396,driver<397 brand=tesla,driver>=410,driver<411 brand=tesla,driver>=418,driver<419"" >> /etc/environment
echo "NVIDIA_VISIBLE_DEVICES=all" >> /etc/environment
echo "NVIDIA_DRIVER_CAPABILITIES=compute,utility" >> /etc/environment
echo "LANG C.UTF-8" >> /etc/environment
# verion specification
echo "CUDA_VERSION=10.1.243" >> /etc/environment
echo "NCCL_VERSION=2.7.8-1" >> /etc/environment
echo "CUDNN_VERSION=7.6.5.32" >> /etc/environment

# Setup Nvidia Repo
apt-get update
apt-get install -y --no-install-recommends gnupg2 curl ca-certificates 
curl -fsSL https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/7fa2af80.pub | apt-key add - 
echo "deb https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64 /" > /etc/apt/sources.list.d/cuda.list
echo "deb https://developer.download.nvidia.com/compute/machine-learning/repos/ubuntu1804/x86_64 /" > /etc/apt/sources.list.d/nvidia-ml.list

# Install CUDA, CUDNN
dt-apt-install "/tmp/dependencies-apt.txt"
apt-get purge --autoremove -y curl
apt-get autoremove --purge -y
apt-get clean -y
rm -rf /var/lib/apt/lists/*

# Setup paths and links
ln -s cuda-10.1 /usr/local/cuda
ln -s $(which ${PYTHON}) /usr/local/bin/python 
echo "/usr/local/nvidia/lib" >> /etc/ld.so.conf.d/nvidia.conf 
echo "/usr/local/nvidia/lib64" >> /etc/ld.so.conf.d/nvidia.conf