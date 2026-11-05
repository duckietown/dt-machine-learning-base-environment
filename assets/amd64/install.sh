#!/bin/bash
set -ex

# ONNX Runtime with the CUDA (and TensorRT) execution providers, together with the CUDA 12 and cuDNN 9 user-space
# libraries as pip packages (nvidia-*). Only the NVIDIA driver comes from the host (the NVIDIA container toolkit,
# e.g., `docker run --gpus all`); without a GPU, inference runs on the CPU.
REQUIREMENTS="/tmp/onnxruntime-requirements.txt"
echo "onnxruntime-gpu[cuda,cudnn]==${ONNXRUNTIME_GPU_VERSION}" > "${REQUIREMENTS}"
dt-pip3-install "${REQUIREMENTS}"
rm -f "${REQUIREMENTS}" /tmp/pip-freeze.*.dat

# make the pip-installed CUDA/cuDNN libraries visible to the dynamic loader (ONNX Runtime loads them with dlopen)
python3 - <<'PYEOF'
import glob
import site

dirs = sorted({d for p in site.getsitepackages() for d in glob.glob(f"{p}/nvidia/*/lib")})
with open("/etc/ld.so.conf.d/nvidia-pip.conf", "w") as f:
    f.write("\n".join(dirs) + "\n")
print("CUDA libraries from pip:", dirs)
PYEOF
ldconfig

# check
python3 -c "import onnxruntime as ort; print('onnxruntime', ort.__version__, ort.get_available_providers())"
