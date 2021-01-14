#!/bin/bash
echo "Setting up PIP Package"
git config --global advice.detachedHead false

# Pytorch: 

# # torchvision
# export TORCHVISION_VERSION="v0.8.1"
# export PILLOW_VERSION="pillow"
# export TORCH_CUDA_ARCH_LIST="5.3;6.2;7.2"
# git clone -b ${TORCHVISION_VERSION} https://github.com/pytorch/vision torchvision && \
#     cd torchvision && \
#     python3 setup.py install && \
#     cd ../ && \
#     rm -rf torchvision && \
#     pip3 install "${PILLOW_VERSION}"
# # torchaudio
# export TORCHAUDIO_VERSION="v0.7.0"
# git clone -b ${TORCHAUDIO_VERSION} https://github.com/pytorch/audio torchaudio && \
#     cd torchaudio && \
#     python3 setup.py install && \
#     cd ../ && \
#     rm -rf torchaudio


# Tensorflow:


# CUPY
# export CUPY_NVCC_GENERATE_CODE="arch=compute_53,code=sm_53;arch=compute_62,code=sm_62;arch=compute_72,code=sm_72"
# export CUB_PATH="/opt/cub"
# #ARG CFLAGS="-I/opt/cub"
# #ARG LDFLAGS="-L/usr/lib/aarch64-linux-gnu"
# git clone https://github.com/NVlabs/cub opt/cub
# git clone -b v8.0.0b4 https://github.com/cupy/cupy cupy && \
#     cd cupy && \
#     pip3 install fastrlock && \
#     python3 setup.py install --verbose && \
#     cd ../  && \
#     rm -rf cupy

# Remove Dataclass to prevent conflict
# pip3 uninstall -y dataclasses

# Cleanup
# pip3 cache purge