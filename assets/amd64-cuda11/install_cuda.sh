#!/bin/bash
# nvidia echo "ironment

# path setup
echo "PATH=/usr/local/nvidia/bin:/usr/local/cuda/bin:${PATH}" > /etc/environment
echo "LD_LIBRARY_PATH=/usr/local/nvidia/lib:/usr/local/nvidia/lib64" > /etc/environment
echo "LIBRARY_PATH=/usr/local/cuda/lib64/stubs" > /etc/environment
# hostside requirement check
echo "NVIDIA_REQUIRE_CUDA="cuda>=11.0 brand=tesla,driver>=418,driver<419 brand=tesla,driver>=440,driver<441 brand=tesla,driver>=450,driver<451"" > /etc/environment
echo "NVIDIA_VISIBLE_DEVICES=all" > /etc/environment
echo "NVIDIA_DRIVER_CAPABILITIES=compute,utility" > /etc/environment
echo "LANG C.UTF-8" > /etc/environment
# verion specification
echo "CUDA_VERSION=11.0.3" > /etc/environment
echo "NCCL_VERSION=2.8.3" > /etc/environment
echo "CUDNN_VERSION=8.0.5.39" > /etc/environment

# Setup Nvidia Repo
apt-get update
apt-get install -y --no-install-recommends gnupg2 curl ca-certificates 
curl -fsSL https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/7fa2af80.pub | apt-key add - 
echo "deb https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64 /" > /etc/apt/sources.list.d/cuda.list 
echo "deb https://developer.download.nvidia.com/compute/machine-learning/repos/ubuntu2004/x86_64 /" > /etc/apt/sources.list.d/nvidia-ml.list 

# Install CUDA, CUDNN
dt-apt-install "/tmp/dependencies-apt.txt"
apt-get purge --autoremove -y curl
apt-get autoremove --purge -y
apt-get clean -y
rm -rf /var/lib/apt/lists/*

# Setup paths and links
ln -s cuda-11.0 /usr/local/cuda 
ln -s $(which ${PYTHON}) /usr/local/bin/python 
echo "/usr/local/nvidia/lib" >> /etc/ld.so.conf.d/nvidia.conf 
echo "/usr/local/nvidia/lib64" >> /etc/ld.so.conf.d/nvidia.conf


# NCCL Setup: NOTE: If in the future NCCL is having issue, remove NCCL and use the following install method. ASK FcQ if questions.
# apt update && apt install curl xz-utils -y --no-install-recommends && NCCL_DOWNLOAD_SUM=34000cbe6a0118bfd4ad898ebc5f59bf5d532bbf2453793891fa3f1621e25653 && \
#     curl -fsSL https://developer.download.nvidia.com/compute/redist/nccl/v2.7/nccl_2.7.8-1+cuda11.0_x86_64.txz -O && \
#     echo "$NCCL_DOWNLOAD_SUM  nccl_2.7.8-1+cuda11.0_x86_64.txz" | sha256sum -c - && \
#     tar --no-same-owner --keep-old-files --lzma -xvf nccl_2.7.8-1+cuda11.0_x86_64.txz -C /usr/local/cuda/lib64/ --strip-components=2 --wildcards '*/lib/libnccl.so.*' && \
#     tar --no-same-owner --keep-old-files --lzma -xvf  nccl_2.7.8-1+cuda11.0_x86_64.txz -C /usr/lib/pkgconfig/ --strip-components=3 --wildcards '*/lib/pkgconfig/*' && \
#     rm nccl_2.7.8-1+cuda11.0_x86_64.txz && \
#     ldconfig && rm -rf /var/lib/apt/lists/*    