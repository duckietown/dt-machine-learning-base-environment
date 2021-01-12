#!/bin/bash
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