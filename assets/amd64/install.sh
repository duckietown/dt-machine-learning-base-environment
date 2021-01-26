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
    cuda-libraries-$CUDA_PKG_VERSION \
    cuda-npp-$CUDA_PKG_VERSION \
    cuda-nvtx-$CUDA_PKG_VERSION \
    cuda-nvml-dev-$CUDA_PKG_VERSION \
    cuda-command-line-tools-$CUDA_PKG_VERSION \
    cuda-nvprof-$CUDA_PKG_VERSION \
    cuda-npp-dev-$CUDA_PKG_VERSION \
    cuda-libraries-dev-$CUDA_PKG_VERSION \
    cuda-minimal-build-$CUDA_PKG_VERSION \
    cuda-cudart-$CUDA_PKG_VERSION \
    libcudnn8=$CUDNN_VERSION-1+cuda10.2 \
    libcudnn8=$CUDNN_VERSION-1+cuda10.2 \
    libcudnn8-dev=$CUDNN_VERSION-1+cuda10.2

# install PyTorch
pip3 install torch==1.7.0+cu102 -f https://download.pytorch.org/whl/torch_stable.html

# clean
pip3 uninstall -y dataclasses
