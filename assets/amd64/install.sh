#!/bin/bash

set -ex

# Remove outdated signing key (as per NVIDIA key rotation notice)
sudo apt-key del 7fa2af80 || true

# Install new CUDA keyring package (recommended method)
wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/cuda-keyring_1.0-1_all.deb
sudo dpkg -i cuda-keyring_1.0-1_all.deb
rm cuda-keyring_1.0-1_all.deb

# install CUDA 10.2 (cuDNN, NCCL, and TensorRT now available in CUDA repo)
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
apt-mark hold \
    libnccl2 \
    libcudnn8 \
    cuda-compat-10-2
rm -rf /var/lib/apt/lists/*

# TODO Install Tensor RT here
# >>>...

# Clean up
rm -rf /usr/src/cudnn_samples_v8

# clean
pip3 uninstall -y dataclasses
