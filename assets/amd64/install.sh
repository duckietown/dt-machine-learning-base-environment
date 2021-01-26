#!/bin/bash

set -ex

SCRIPTPATH="$( cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"

# install APT libraries
dt-apt-install "${SCRIPTPATH}/dependencies-apt.txt"

# install PIP libraries
pip3 install -r "${SCRIPTPATH}/dependencies-py3.txt"

# install PyTorch
pip3 install torch==1.7.0 -f https://download.pytorch.org/whl/torch_stable.html

# clean
pip3 uninstall -y dataclasses
