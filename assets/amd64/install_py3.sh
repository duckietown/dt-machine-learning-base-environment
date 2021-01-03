#!/bin/bash

# Pytorch: 
pip install torch==1.7.0+cu101 torchvision==0.8.1+cu101 torchaudio==0.7.0 -f https://download.pytorch.org/whl/torch_stable.html

# Tensorflow:
pip3 install tensorflow>=2.3.1 cupy-cuda101

# Remove dataclasses for compatibility
pip3 uninstall -y dataclasses

pip3 cache purge