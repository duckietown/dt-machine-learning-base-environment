FROM ubuntu:20.04

LABEL maintainer "Duckietown AIDO <help@duckietown.org>"
#! Nvidia ENV
ENV CUDA_VERSION 10.1.243
ENV CUDA_PKG_VERSION 10-1=$CUDA_VERSION-1
ENV CUDNN_VERSION 7.6.5.32
ENV NCCL_VERSION 2.7.8
LABEL com.nvidia.cudnn.version="${CUDNN_VERSION}"
ENV PATH /usr/local/cuda-10.1/bin:${PATH}
ENV LD_LIBRARY_PATH /usr/local/cuda/lib64:/usr/local/cuda/extras/CUPTI/lib64
ENV LIBRARY_PATH /usr/local/cuda/lib64/stubs
ENV NVIDIA_VISIBLE_DEVICES all
ENV NVIDIA_DRIVER_CAPABILITIES compute,utility
ENV NVIDIA_REQUIRE_CUDA "cuda>=10.1 brand=tesla,driver>=396,driver<397 brand=tesla,driver>=410,driver<411 brand=tesla,driver>=418,driver<419"

#! Setup Nvidia repo
RUN apt-get update && apt-get install -y --no-install-recommends \
    gnupg2 curl ca-certificates && \
    curl -fsSL https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/7fa2af80.pub | apt-key add - && \
    echo "deb https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64 /" > /etc/apt/sources.list.d/cuda.list && \
    echo "deb https://developer.download.nvidia.com/compute/machine-learning/repos/ubuntu1804/x86_64 /" > /etc/apt/sources.list.d/nvidia-ml.list && \
    apt-get purge --autoremove -y curl \    
    && rm -rf /var/lib/apt/lists/*

#! Install CUDA, CUDNN
RUN apt-get update && apt-get install -y --no-install-recommends \
    cuda-cudart-$CUDA_PKG_VERSION \
    cuda-compat-10-1 \
    cuda-libraries-$CUDA_PKG_VERSION \
    cuda-npp-$CUDA_PKG_VERSION \
    cuda-nvtx-$CUDA_PKG_VERSION \
    cuda-nvml-dev-$CUDA_PKG_VERSION \
    cuda-command-line-tools-$CUDA_PKG_VERSION \
    cuda-nvprof-$CUDA_PKG_VERSION \
    cuda-npp-dev-$CUDA_PKG_VERSION \
    cuda-libraries-dev-$CUDA_PKG_VERSION \
    cuda-minimal-build-$CUDA_PKG_VERSION \
    libnccl-dev=2.7.8-1+cuda10.1 \
    libnccl2=$NCCL_VERSION-1+cuda10.1 \
    libcublas-dev=10.2.1.243-1 \
    libcublas10=10.2.1.243-1 \
    libcudnn7=$CUDNN_VERSION-1+cuda10.1 \
    libcudnn7-dev=$CUDNN_VERSION-1+cuda10.1 \
    && apt-mark hold \
    libnccl2 \
    libcublas10 \
    libcudnn7 \
    libnccl-dev \
    libcublas-dev\
    && apt-get autoremove -y  \
    && rm -rf /var/lib/apt/lists/* \
    && ln -s cuda-10.1 /usr/local/cuda \
    && echo "/usr/local/nvidia/lib" >> /etc/ld.so.conf.d/nvidia.conf \
    && echo "/usr/local/nvidia/lib64" >> /etc/ld.so.conf.d/nvidia.conf

#! Setup typical ubuntu enviornment
ENV DEBIAN_FRONTEND=noninteractive
ENV LANG C.UTF-8
RUN apt-get update && apt-get install -y --no-install-recommends \
    software-properties-common \
    git \
    python3-pip \
    python3.8-dev \
    python3-tk \
    libgl1-mesa-glx \ 
    && apt-get autoremove -y  \
    && rm -rf /var/lib/apt/lists/* \
    && ln -s $(which ${PYTHON}) /usr/local/bin/python

#! Skipped dependencies from old version
# RUN apt-get update && apt-get install -y --no-install-recommends \
#         libfreetype6-dev \
#         libhdf5-serial-dev \
#         libzmq3-dev \
#         pkg-config \
#         unzip \
#         libgl1-mesa-glx

#! Setup PIP and its packages:
ENV NP_VERSION 1.18.0
ENV TF_VERSION 2.2.1
ENV TORCH_VERSION 1.7.0
ENV CV_VERSION 4.4.0.44

RUN pip3 install --upgrade pip setuptools 
RUN pip3 install --use-feature=2020-resolver \
    numpy==$NP_VERSION \
    opencv-python==$CV_VERSION \
    tensorflow==$TF_VERSION \
    cupy-cuda101 \
    torch==$TORCH_VERSION+cu101 \
    torchvision==0.8.1+cu101 \
    torchaudio==0.7.0 \
    aido-protocols-daffy \
    duckietown-world-daffy \
    duckietown-challenges-daffy \
    -f https://download.pytorch.org/whl/torch_stable.html


#! Workspace setup
RUN rm -rf /workspace; mkdir /submission
WORKDIR /submission


#! Duckietown Proprietary:
ENV DUCKIETOWN_SERVER=evaluator


