#!/bin/bash

set -ex

# setup nvidia repo
sudo apt-key adv --fetch-keys \
    https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/7fa2af80.pub
echo "deb https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64 /" \
    > /etc/apt/sources.list.d/cuda.list
echo "deb https://developer.download.nvidia.com/compute/machine-learning/repos/ubuntu1804/x86_64 /" \
    > /etc/apt/sources.list.d/nvidia-ml.list

# install CUDA 10.2
apt-get update
apt-get install -y --no-install-recommends \
    cuda-cudart-$CUDA_PKG_VERSION \
    cuda-compat-10-2 \
    cuda-libraries-$CUDA_PKG_VERSION \
    cuda-npp-$CUDA_PKG_VERSION \
    cuda-nvtx-$CUDA_PKG_VERSION \
    libcublas10=10.2.2.89-1 \
    libnccl2=$NCCL_VERSION-1+cuda10.2 \
    libcudnn8=$CUDNN_VERSION-1+cuda10.2
apt-mark hold libnccl2 libcudnn8 cuda-compat-10-2

# TODO Install Tensor RT here
# >>>...

# Clean up
rm -rf /usr/src/cudnn_samples_v8 && rm -rf /var/lib/apt/lists/*

# install PyTorch
pip3 install torch==1.7.1
#https://download.pytorch.org/whl/cu102/torch-1.7.0-cp38-cp38-linux_x86_64.whl
pip3 install torchvision==0.8.1

# clean
pip3 uninstall -y dataclasses
