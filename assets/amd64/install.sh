#!/bin/bash

set -ex

SCRIPTPATH="$( cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"

# setup CUDA sources
apt-get update && apt-get install -y --no-install-recommends \
    gnupg2 curl ca-certificates && \
    curl -fsSL https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/7fa2af80.pub | apt-key add - && \
    echo "deb https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64 /" > /etc/apt/sources.list.d/cuda.list && \
    echo "deb https://developer.download.nvidia.com/compute/machine-learning/repos/ubuntu1804/x86_64 /" > /etc/apt/sources.list.d/nvidia-ml.list && \
    apt-get purge --autoremove -y curl \
    && rm -rf /var/lib/apt/lists/*

# install APT libraries
dt-apt-install "${SCRIPTPATH}/dependencies-apt.txt"

# install PIP libraries
pip3 install -r "${SCRIPTPATH}/dependencies-py3.txt"

# install PyTorch
pip3 install torch==1.7.0 -f https://download.pytorch.org/whl/torch_stable.html

# clean
pip3 uninstall -y dataclasses
