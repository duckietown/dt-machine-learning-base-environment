#! /bin/bash
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