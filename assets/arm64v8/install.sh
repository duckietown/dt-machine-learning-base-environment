#!/bin/bash
set -ex

# ONNX Runtime for arm64 machines that are not a Jetson (Apple Silicon laptops, virtual robots, other arm64 hosts):
# the CPU build from PyPI. The Jetson variant (JetPack GPU build) is assets/arm64v8-jetpack4.
REQUIREMENTS="/tmp/onnxruntime-requirements.txt"
echo "onnxruntime==${ONNXRUNTIME_CPU_VERSION}" > "${REQUIREMENTS}"
dt-pip3-install "${REQUIREMENTS}"
rm -f "${REQUIREMENTS}" /tmp/pip-freeze.*.dat

# check: what got installed has to be what the image reports in ONNXRUNTIME_VERSION
python3 - <<'PYEOF'
import os
import sys

import onnxruntime as ort

print("onnxruntime", ort.__version__, ort.get_available_providers())
expected = os.environ.get("ONNXRUNTIME_VERSION")
if expected and ort.__version__ != expected:
    sys.exit(f"ERROR! ONNXRUNTIME_VERSION is {expected} but onnxruntime {ort.__version__} was installed")
PYEOF
