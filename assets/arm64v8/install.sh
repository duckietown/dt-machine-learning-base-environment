#!/bin/bash

set -ex

#apt-get update
#apt-get install -qq -y --no-install-recommends \
#    bc \
#    bzip2 \
#    can-utils \
#    freeglut3-dev \
#    gstreamer1.0-alsa \
#    gstreamer1.0-libav \
#    gstreamer1.0-plugins-bad \
#    gstreamer1.0-plugins-base \
#    gstreamer1.0-plugins-good \
#    gstreamer1.0-plugins-ugly \
#    gstreamer1.0-tools \
#    i2c-tools \
#    iw \
#    kbd \
#    language-pack-en-base \
#    libapt-inst2.0 \
#    libcanberra-gtk3-module \
#    libgles2 \
#    libglu1-mesa-dev \
#    libglvnd-dev \
#    libgtk-3-0 \
#    libpython2.7 \
#    libudev1 \
#    libvulkan1 \
#    libzmq5 \
#    mtd-utils \
#    parted \
#    pciutils \
#    python \
#    python-pexpect \
#    python3-distutils \
#    sox \
#    udev \
#    vulkan-utils \
#    wget \
#    wireless-tools wpasupplicant


SCRIPTPATH="$( cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"

# install APT libraries
dt-apt-install ${SCRIPTPATH}/dependencies-apt.txt

# install PIP libraries
pip3 install -r ${SCRIPTPATH}/dependencies-py3.txt

#rm -f /usr/share/glvnd/egl_vendor.d/50_mesa.json
#mkdir -p /usr/share/glvnd/egl_vendor.d/
#echo '\
#{\
#    "file_format_version" : "1.0.0",\
#    "ICD" : {\
#        "library_path" : "libEGL_nvidia.so.0"\
#    }\
#}' > /usr/share/glvnd/egl_vendor.d/10_nvidia.json
#
#mkdir -p /usr/share/egl/egl_external_platform.d/
#echo '\
#{\
#    "file_format_version" : "1.0.0",\
#    "ICD" : {\
#        "library_path" : "libnvidia-egl-wayland.so.1"\
#    }\
#}' > /usr/share/egl/egl_external_platform.d/nvidia_wayland.json


echo "/usr/lib/aarch64-linux-gnu/tegra" >> /etc/ld.so.conf.d/nvidia-tegra.conf
echo "/usr/lib/aarch64-linux-gnu/tegra-egl" >> /etc/ld.so.conf.d/nvidia-tegra.conf
echo "/usr/local/cuda-10.0/targets/aarch64-linux/lib" >> /etc/ld.so.conf.d/nvidia.conf

ldconfig

# install PyTorch
PYTORCH_WHEEL_NAME="torch-${PYTORCH_VERSION}-cp38-cp38-linux_aarch64.whl"
WHEEL_URL="https://duckietown-public-storage.s3.amazonaws.com/assets/python/wheels/${PYTORCH_WHEEL_NAME}"
wget -q "${WHEEL_URL}" -O "/tmp/${PYTORCH_WHEEL_NAME}"
pip3 install "/tmp/${PYTORCH_WHEEL_NAME}"
rm "/tmp/${PYTORCH_WHEEL_NAME}"

# clean
pip3 uninstall -y dataclasses


## Add Jetson Repository
#apt-get update
#apt-get update && apt-get install -y --no-install-recommends gnupg2 ca-certificates
#apt-key add /tmp/jetson-ota-public.key
#echo "deb https://repo.download.nvidia.com/jetson/common $RELEASE main" >> /etc/apt/sources.list
#
## install cuda and related packages
#dt-apt-install "/tmp/dependencies-apt.txt"
#
#apt-get purge --autoremove -y curl
#apt-get autoremove --purge -y
#apt-get clean -y
#rm -rf /var/lib/apt/lists/*
#
#ln -s /usr/local/cuda-$CUDA /usr/local/cuda
#ln -s /usr/local/cuda-$CUDA/targets/aarch64-linux/include /usr/local/cuda/include
#ln -s /usr/local/cuda-$CUDA/targets/aarch64-linux/lib /usr/local/cuda/lib64
#
#
#echo "/usr/lib/aarch64-linux-gnu/tegra" >> /etc/ld.so.conf.d/nvidia-tegra.conf
#echo "/usr/lib/aarch64-linux-gnu/tegra-egl" >> /etc/ld.so.conf.d/nvidia-tegra.conf
#echo "/usr/local/cuda-10.0/targets/aarch64-linux/lib" >> /etc/ld.so.conf.d/nvidia.conf
#
#
#rm /usr/share/glvnd/egl_vendor.d/50_mesa.json
#
#
#mkdir -p /usr/share/glvnd/egl_vendor.d/
#echo '\
#{\
#    "file_format_version" : "1.0.0",\
#    "ICD" : {\
#        "library_path" : "libEGL_nvidia.so.0"\
#    }\
#}' > /usr/share/glvnd/egl_vendor.d/10_nvidia.json
#
#mkdir -p /usr/share/egl/egl_external_platform.d/
#echo '\
#{\
#    "file_format_version" : "1.0.0",\
#    "ICD" : {\
#        "library_path" : "libnvidia-egl-wayland.so.1"\
#    }\
#}' > /usr/share/egl/egl_external_platform.d/nvidia_wayland.json
#
#echo "/usr/local/cuda-10.0/targets/aarch64-linux/lib" >> /etc/ld.so.conf.d/nvidia.conf

# Stubs
# COPY ./dst/bin /usr/local/cuda-$CUDA/bin
# COPY ./dst/nvvm /usr/local/cuda-$CUDA/nvvm
# COPY ./dst/nvvmx /usr/local/cuda-$CUDA/nvvmx
# COPY ./dst/include /usr/local/cuda-$CUDA/targets/aarch64-linux/include
# COPY ./dst/lib64/stubs /usr/local/cuda-$CUDA/targets/aarch64-linux/lib/stubs
# COPY ./dst/lib64/libcudadevrt.a /usr/local/cuda-$CUDA/targets/aarch64-linux/lib/
# COPY ./dst/lib64/libcudart_static.a /usr/local/cuda-$CUDA/targets/aarch64-linux/lib/


#
# restore missing cuDNN headers
#
#ln -s /usr/include/aarch64-linux-gnu/cudnn_v8.h /usr/include/cudnn.h && \
#    ln -s /usr/include/aarch64-linux-gnu/cudnn_version_v8.h /usr/include/cudnn_version.h && \
#    ln -s /usr/include/aarch64-linux-gnu/cudnn_backend_v8.h /usr/include/cudnn_backend.h && \
#    ln -s /usr/include/aarch64-linux-gnu/cudnn_adv_infer_v8.h /usr/include/cudnn_adv_infer.h && \
#    ln -s /usr/include/aarch64-linux-gnu/cudnn_adv_train_v8.h /usr/include/cudnn_adv_train.h && \
#    ln -s /usr/include/aarch64-linux-gnu/cudnn_cnn_infer_v8.h /usr/include/cudnn_cnn_infer.h && \
#    ln -s /usr/include/aarch64-linux-gnu/cudnn_cnn_train_v8.h /usr/include/cudnn_cnn_train.h && \
#    ln -s /usr/include/aarch64-linux-gnu/cudnn_ops_infer_v8.h /usr/include/cudnn_ops_infer.h && \
#    ln -s /usr/include/aarch64-linux-gnu/cudnn_ops_train_v8.h /usr/include/cudnn_ops_train.h && \
#    ls -ll /usr/include/cudnn*