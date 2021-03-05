#!/bin/bash

set -ex

# setup nvidia repo
sudo apt-key adv --fetch-keys \
    https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/7fa2af80.pub
echo "deb https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64 /" \
    > /etc/apt/sources.list.d/cuda.list

# install CUDA 10.2
CUDNN_VERSION="8.0.5.39"
CUDA_VERSION="10.2.89"
CUDA_PKG_VERSION="10-2=${CUDA_VERSION}-1"

apt update
apt install -y --no-install-recommends \
    cuda-compat-10-2 \
    cuda-cudart-$CUDA_PKG_VERSION \
    cuda-libraries-$CUDA_PKG_VERSION \
    cuda-npp-$CUDA_PKG_VERSION \
    cuda-nvtx-$CUDA_PKG_VERSION \
    libcublas10=10.2.2.89-1 \
    libcudnn8=$CUDNN_VERSION-1+cuda10.2

# Clean up CUDNN Sample
rm -rf /usr/src/cudnn_samples_v8

# install PyTorch
pip3 install https://download.pytorch.org/whl/cu102/torch-1.7.0-cp38-cp38-linux_x86_64.whl

# clean
pip3 uninstall -y dataclasses