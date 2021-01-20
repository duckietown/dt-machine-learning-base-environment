#!/bin/bash
echo "Setting up PIP Package"
git config --global advice.detachedHead false

# Python Override to 3.6
add-apt-repository -y ppa:deadsnakes/ppa \
&& apt-get update \
&& apt install -y python3.6 python3.6-dev
# Pytorch: 
wget --quiet -O torch-1.7.0-cp36-cp36m-linux_aarch64.whl https://nvidia.box.com/shared/static/cs3xn3td6sfgtene6jdvsxlr366m2dhq.whl 
python3.6 -m pip install torch-1.7.0-cp36-cp36m-linux_aarch64.whl
ln -s /usr/lib/aarch64-linux-gnu/libmpi.so.40 /usr/lib/aarch64-linux-gnu/libmpi.so.20
ln -s /usr/lib/aarch64-linux-gnu/libmpi_cxx.so.40 /usr/lib/aarch64-linux-gnu/libmpi_cxx.so.20
# Tensorflow
wget --quiet -O tensorflow-2.3.1+nv20.11-cp36-cp36m-linux_aarch64.whl https://developer.download.nvidia.com/compute/redist/jp/v44/tensorflow/tensorflow-2.3.1+nv20.11-cp36-cp36m-linux_aarch64.whl
pip3 uninstall -y numpy
python3.6 -m pip install tensorflow-2.3.1+nv20.11-cp36-cp36m-linux_aarch64.whl

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