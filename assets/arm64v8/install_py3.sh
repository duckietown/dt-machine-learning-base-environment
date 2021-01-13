#!/bin/bash
echo "Setting up PIP Package"
# Pytorch: 

# torchvision
export TORCHVISION_VERSION="v0.8.1"
export PILLOW_VERSION="pillow"
export TORCH_CUDA_ARCH_LIST="5.3;6.2;7.2"

git clone -b ${TORCHVISION_VERSION} https://github.com/pytorch/vision torchvision && \
    cd torchvision && \
    python3 setup.py install && \
    cd ../ && \
    rm -rf torchvision && \
    pip3 install "${PILLOW_VERSION}"
# torchaudio
export TORCHAUDIO_VERSION="v0.7.0"
git clone -b ${TORCHAUDIO_VERSION} https://github.com/pytorch/audio torchaudio && \
    cd torchaudio && \
    python3 setup.py install && \
    cd ../ && \
    rm -rf torchaudio


# Tensorflow:

# OpenCV
apt-get install -y --no-install-recommends \
    libopencv-dev \
    libopencv-python

# CUPY
export CUPY_NVCC_GENERATE_CODE="arch=compute_53,code=sm_53;arch=compute_62,code=sm_62;arch=compute_72,code=sm_72"
export CUB_PATH="/opt/cub"
#ARG CFLAGS="-I/opt/cub"
#ARG LDFLAGS="-L/usr/lib/aarch64-linux-gnu"
git clone https://github.com/NVlabs/cub opt/cub
git clone -b v8.0.0b4 https://github.com/cupy/cupy cupy && \
    cd cupy && \
    pip3 install fastrlock && \
    python3 setup.py install --verbose && \
    cd ../  && \
    rm -rf cupy

# Machine Learning Dependencies:
pip3 install pybind11 --ignore-installed
pip3 install onnx --verbose
pip3 install scipy --verbose
pip3 install scikit-learn --verbose
pip3 install pandas --verbose
pip3 install pycuda --verbose
pip3 install numba --verbose
pip3 install jupyter jupyterlab --verbose
pip3 install setuptools Cython wheel
pip3 install numpy --verbose
pip3 install h5py==2.10.0 --verbose
pip3 install future==0.18.2 mock==3.0.5 keras_preprocessing==1.1.1 keras_applications==1.0.8 gast==0.2.2 futures protobuf --verbose
# Remove Dataclass to prevent conflict
pip3 uninstall -y dataclasses

# Cleanup
pip3 cache purge