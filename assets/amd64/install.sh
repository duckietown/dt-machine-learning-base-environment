#!/bin/bash

set -ex

# setup nvidia repo
sudo apt-key adv --fetch-keys \
    https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/3bf863cc.pub
    
echo "deb https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64 /" \
    > /etc/apt/sources.list.d/cuda.list
    
sudo apt-key adv --fetch-keys \
    https://developer.download.nvidia.com/compute/machine-learning/repos/ubuntu1804/x86_64/7fa2af80.pub

echo "deb https://developer.download.nvidia.com/compute/machine-learning/repos/ubuntu1804/x86_64 /" \
    > /etc/apt/sources.list.d/nvidia-ml.list

# install CUDA 10.2
# Note: x86_64 repos have CUDA 10.2.89, Jetson (arm64) uses 10.2.300 via JetPack
CUDA_VERSION_AMD64=10.2.89
CUDA_PKG_VERSION_AMD64=10-2=${CUDA_VERSION_AMD64}-1
apt-get update
apt-get install -y --no-install-recommends \
    cuda-cudart-${CUDA_PKG_VERSION_AMD64} \
    cuda-compat-10-2 \
    cuda-libraries-${CUDA_PKG_VERSION_AMD64} \
    cuda-npp-${CUDA_PKG_VERSION_AMD64} \
    cuda-nvtx-${CUDA_PKG_VERSION_AMD64} \
    libcublas10=10.2.2.89-1 \
    libnccl2=$NCCL_VERSION-1+cuda10.2 \
    libcudnn8=$CUDNN_VERSION-1+cuda10.2
apt-mark hold \
    libnccl2 \
    libcudnn8 \
    cuda-compat-10-2
# Install TensorRT
# Note: TensorRT 8.x requires CUDA 11.x on x86_64, so we use TensorRT 7.2.3 for CUDA 10.2
# Jetson (arm64) uses TensorRT 8.2.1.9 via JetPack
TENSORRT_VERSION_AMD64=7.2.3
apt-get install -y --no-install-recommends \
    libnvinfer7=${TENSORRT_VERSION_AMD64}-1+cuda10.2 \
    libnvinfer-plugin7=${TENSORRT_VERSION_AMD64}-1+cuda10.2 \
    libnvparsers7=${TENSORRT_VERSION_AMD64}-1+cuda10.2 \
    libnvonnxparsers7=${TENSORRT_VERSION_AMD64}-1+cuda10.2 \
    python3-libnvinfer=${TENSORRT_VERSION_AMD64}-1+cuda10.2
apt-mark hold \
    libnvinfer7 \
    libnvinfer-plugin7 \
    libnvparsers7 \
    libnvonnxparsers7 \
    python3-libnvinfer
rm -rf /var/lib/apt/lists/*

# Clean up
rm -rf /usr/src/cudnn_samples_v8

# clean
pip3 uninstall -y dataclasses
