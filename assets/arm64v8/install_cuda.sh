#!/bin/bash
# l4t setup
echo "/usr/lib/aarch64-linux-gnu/tegra" >> /etc/ld.so.conf.d/nvidia-tegra.conf
echo "/usr/lib/aarch64-linux-gnu/tegra-egl" >> /etc/ld.so.conf.d/nvidia-tegra.conf

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

ln -s /usr/local/cuda-$CUDA /usr/local/cuda
ln -s /usr/local/cuda-$CUDA/targets/aarch64-linux/include /usr/local/cuda/include
ln -s /usr/local/cuda-$CUDA/targets/aarch64-linux/lib /usr/local/cuda/lib64

$PATH=/usr/local/cuda-$CUDA/bin:/usr/local/cuda/bin:${PATH}
$LD_LIBRARY_PATH=/usr/local/cuda-$CUDA/targets/aarch64-linux/lib:${LD_LIBRARY_PATH}

echo "PATH=/usr/local/nvidia/bin:/usr/local/cuda/bin:${PATH}" > /etc/environment
echo "LD_LIBRARY_PATH=/usr/local/cuda/lib64:/usr/local/cuda/extras/CUPTI/lib64:${LD_LIBRARY_PATH}" > /etc/environment

RUN ldconfig

echo "NVIDIA_VISIBLE_DEVICES=all" > /etc/environment
echo "NVIDIA_DRIVER_CAPABILITIES=compute,utility" > /etc/environment