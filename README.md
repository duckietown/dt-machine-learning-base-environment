# dt-machine-learning-base-environment

A machine learning base image for Duckietown.

# Setup

## Full

ssh duckie@DUCKIEBOT_NAME.local "sudo apt update && sudo apt install -y nvidia-jetpack"

## Minimal

ssh duckie@DUCKIEBOT_NAME.local "sudo apt update && sudo apt install -y cuda-nvtx-10-2 libcudnn8 libnvinfer8 python3-libnvinfer"

# Testing

dts devel run -H DUCKIEBOT_NAME -L test-tensorrt -- \
-v /usr/local/cuda-10.2:/usr/local/cuda:ro \
-v /usr/lib/aarch64-linux-gnu:/usr/lib/aarch64-linux-gnu-host:ro \
-v /usr/lib/python3.6/dist-packages:/usr/lib/python3.6/dist-packages-host:ro
