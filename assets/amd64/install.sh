#!/bin/bash

# TODO: revisit this

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



# TODO: revisit this

# Pytorch:
pip install torch==1.7.0+cu101 torchvision==0.8.1+cu101 torchaudio==0.7.0 -f https://download.pytorch.org/whl/torch_stable.html

# Tensorflow:
pip3 install tensorflow==2.3.1

# OpenCV
pip3 install opencv-python>=4.4.0

# Machine Learning Dependencies:
pip3 install scipy matplotlib jupyter jupyterlab pandas scikit-learn pycuda numba cupy-cuda101

# Remove dataclasses for compatibility
pip3 uninstall -y dataclasses

pip3 cache purge