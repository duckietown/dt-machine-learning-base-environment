#!/bin/bash
# Configure paths for host-mounted ML libraries (CUDA, TensorRT, cuDNN)
# These paths are used when running on Jetson with host library mounts

# Host library path (mounted from /usr/lib/aarch64-linux-gnu)
if [ -d "/usr/lib/aarch64-linux-gnu-host" ]; then
    export LD_LIBRARY_PATH="/usr/lib/aarch64-linux-gnu-host${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}"
fi

# Host Python packages path (mounted from /usr/lib/python3.6/dist-packages)
if [ -d "/usr/lib/python3.6/dist-packages-host" ]; then
    export PYTHONPATH="/usr/lib/python3.6/dist-packages-host${PYTHONPATH:+:$PYTHONPATH}"
fi
