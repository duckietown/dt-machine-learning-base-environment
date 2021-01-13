#!/bin/bash
echo "py3 statge"
# Pytorch: 
# pip install torch==1.7.0+cu101 torchvision==0.8.1+cu101 torchaudio==0.7.0 -f https://download.pytorch.org/whl/torch_stable.html

# Tensorflow:
wget --quiet --show-progress --progress=bar:force:noscroll --no-check-certificate https://developer.download.nvidia.com/compute/redist/jp/v44/tensorflow/tensorflow-2.3.1+nv20.12-cp36-cp36m-linux_aarch64.whl
pip3 install tensorflow-2.3.1+nv20.12-cp36-cp36m-linux_aarch64.whl

# OpenCV
# pip3 install opencv-python>=4.4.0

# Machine Learning Dependencies:
# pip3 install scipy matplotlib ipython jupyter pandas sympy nose scikit-learn

# Remove dataclasses for compatibility
# pip3 uninstall -y dataclasses

#pip3 cache purge