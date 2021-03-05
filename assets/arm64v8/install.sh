#!/bin/bash

set -e

# # download PyTorch
# echo "Downloading PyTorch v${PYTORCH_VERSION}..."
# PYTORCH_WHEEL_NAME="torch-${PYTORCH_VERSION}-cp38-cp38-linux_aarch64.whl"
# WHEEL_URL="https://duckietown-public-storage.s3.amazonaws.com/assets/python/wheels/${PYTORCH_WHEEL_NAME}"
# wget -q "${WHEEL_URL}" -O "/tmp/${PYTORCH_WHEEL_NAME}"
# # install PyTorch
# echo "Installing PyTorch v${PYTORCH_VERSION}..."
# pip3 install "/tmp/${PYTORCH_WHEEL_NAME}"
# rm "/tmp/${PYTORCH_WHEEL_NAME}"

# # download torchvision
# echo "Downloading PyTorch v${PYTORCHVISION_VERSION}..."
# PYTORCHVISION_WHEEL_NAME="torchvision-${PYTORCHVISION_VERSION}-cp38-cp38-linux_aarch64.whl"
# WHEEL_URL="https://duckietown-public-storage.s3.amazonaws.com/assets/python/wheels/${PYTORCH_WHEEL_NAME}"
# wget -q "${WHEEL_URL}" -O "/tmp/${PYTORCHVISION_WHEEL_NAME}"
# # install torchvision
# echo "Installing PyTorch v${PYTORCHVISION_VERSION}..."
# pip3 install "/tmp/${PYTORCHVISION_WHEEL_NAME}"
# rm "/tmp/${PYTORCHVISION_WHEEL_NAME}"

# download TensorRT
echo "Downloading TensorRT v${TENSORRT_VERSION}..."
TENSORRT_WHEEL_NAME=tensorrt-${TENSORRT_VERSION}-cp38-cp38-linux_aarch64.whl
WHEEL_URL="https://duckietown-public-storage.s3.amazonaws.com/assets/python/wheels/${TENSORRT_WHEEL_NAME}"
wget -q "${WHEEL_URL}" -O "/tmp/${TENSORRT_WHEEL_NAME}"
# install TensorRT
echo "Installing TensorRT v${TENSORRT_VERSION}..."
pip3 install "/tmp/${TENSORRT_WHEEL_NAME}"
rm "/tmp/${TENSORRT_WHEEL_NAME}"

# clean
pip3 uninstall -y dataclasses
