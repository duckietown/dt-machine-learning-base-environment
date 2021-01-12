#!/bin/bash
# set the general cuda version
$CUDA=10.2
$RELEASE=r32.4
$CUDAPKG=10-2

# Add Jetson Repository
apt-get update
apt-get update && apt-get install -y --no-install-recommends gnupg2 ca-certificates
apt-key add /tmp/jetson-ota-public.key
echo "deb https://repo.download.nvidia.com/jetson/common $RELEASE main" >> /etc/apt/sources.list

# install cuda and related packages
dt-apt-install "/tmp/dependencies-apt.txt"
apt-get purge --autoremove -y curl
apt-get autoremove --purge -y
apt-get clean -y
rm -rf /var/lib/apt/lists/*

ln -s /usr/local/cuda-$CUDA /usr/local/cuda
ln -s /usr/local/cuda-$CUDA/targets/aarch64-linux/include /usr/local/cuda/include
ln -s /usr/local/cuda-$CUDA/targets/aarch64-linux/lib /usr/local/cuda/lib64


echo "/usr/lib/aarch64-linux-gnu/tegra" >> /etc/ld.so.conf.d/nvidia-tegra.conf
echo "/usr/lib/aarch64-linux-gnu/tegra-egl" >> /etc/ld.so.conf.d/nvidia-tegra.conf
echo "/usr/local/cuda-10.0/targets/aarch64-linux/lib" >> /etc/ld.so.conf.d/nvidia.conf


rm /usr/share/glvnd/egl_vendor.d/50_mesa.json


mkdir -p /usr/share/glvnd/egl_vendor.d/ 
echo '\
{\
    "file_format_version" : "1.0.0",\
    "ICD" : {\
        "library_path" : "libEGL_nvidia.so.0"\
    }\
}' > /usr/share/glvnd/egl_vendor.d/10_nvidia.json

mkdir -p /usr/share/egl/egl_external_platform.d/ 
echo '\
{\
    "file_format_version" : "1.0.0",\
    "ICD" : {\
        "library_path" : "libnvidia-egl-wayland.so.1"\
    }\
}' > /usr/share/egl/egl_external_platform.d/nvidia_wayland.json

echo "/usr/local/cuda-10.0/targets/aarch64-linux/lib" >> /etc/ld.so.conf.d/nvidia.conf

ldconfig
# Stubs
# COPY ./dst/bin /usr/local/cuda-$CUDA/bin
# COPY ./dst/nvvm /usr/local/cuda-$CUDA/nvvm
# COPY ./dst/nvvmx /usr/local/cuda-$CUDA/nvvmx
# COPY ./dst/include /usr/local/cuda-$CUDA/targets/aarch64-linux/include
# COPY ./dst/lib64/stubs /usr/local/cuda-$CUDA/targets/aarch64-linux/lib/stubs
# COPY ./dst/lib64/libcudadevrt.a /usr/local/cuda-$CUDA/targets/aarch64-linux/lib/
# COPY ./dst/lib64/libcudart_static.a /usr/local/cuda-$CUDA/targets/aarch64-linux/lib/