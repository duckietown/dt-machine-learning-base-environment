#!/bin/bash
set -ex

# ONNX Runtime for the Jetson: the JetPack 4.6.x GPU wheel (TensorRT and CUDA execution providers) when
# ONNXRUNTIME_GPU_WHEEL is set, the CPU-only `onnxruntime` from PyPI otherwise.
# CUDA, cuDNN and TensorRT are NOT installed here: the NVIDIA container runtime mounts them from the host (JetPack).
REQUIREMENTS="/tmp/onnxruntime-requirements.txt"
if [ -n "${ONNXRUNTIME_GPU_WHEEL}" ]; then
    WHEEL="/tmp/${ONNXRUNTIME_GPU_WHEEL_NAME}"
    # box.com links redirect and have opaque names: download with Python and give the wheel a valid filename
    python3 -c "import sys, urllib.request; urllib.request.urlretrieve(sys.argv[1], sys.argv[2])" \
        "${ONNXRUNTIME_GPU_WHEEL}" "${WHEEL}"
    if [ -n "${ONNXRUNTIME_GPU_WHEEL_SHA256}" ]; then
        echo "${ONNXRUNTIME_GPU_WHEEL_SHA256}  ${WHEEL}" | sha256sum -c -
    fi
    echo "${WHEEL}" > "${REQUIREMENTS}"
else
    echo "onnxruntime" > "${REQUIREMENTS}"
fi
dt-pip3-install "${REQUIREMENTS}"
rm -f "${REQUIREMENTS}" /tmp/pip-freeze.*.dat "${WHEEL:-}"

# check (the GPU providers are listed even where the host libraries are missing; they are loaded on first use)
python3 -c "import onnxruntime as ort; print('onnxruntime', ort.__version__, ort.get_available_providers())"
