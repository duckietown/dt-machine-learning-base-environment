#!/bin/bash

set -ex

SCRIPTPATH="$( cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"

# install APT libraries
dt-apt-install "${SCRIPTPATH}/dependencies-apt.txt"

# install PIP libraries
pip3 install -r "${SCRIPTPATH}/dependencies-py3.txt"

# install PyTorch
PYTORCH_WHEEL_NAME="torch-${PYTORCH_VERSION}-cp38-cp38-linux_aarch64.whl"
WHEEL_URL="https://duckietown-public-storage.s3.amazonaws.com/assets/python/wheels/${PYTORCH_WHEEL_NAME}"
wget -q "${WHEEL_URL}" -O "/tmp/${PYTORCH_WHEEL_NAME}"
pip3 install "/tmp/${PYTORCH_WHEEL_NAME}"
rm "/tmp/${PYTORCH_WHEEL_NAME}"

# clean
pip3 uninstall -y dataclasses
