# dt-machine-learning-base-environment
Docker image for a base image containing machine learning tools

## How to use:

  * **Dockerhub**: https://hub.docker.com/r/duckietown/dt-machine-learning-base-environment/
  * **Docker**: `docker pull duckietown/dt-machine-learning-base-environment:daffy-amd64`
  * **Dockerfile**: `From duckietown/dt-machine-learning-base-environment:daffy-amd64`

## Python3 Package included: 

### Numpy, CV, Tensorflow, Pytorch
  * numpy>=1.19.4 (auto updated by tensorflow)
  * opencv-python>=4.4.0 (latest OpenCV 4.4)
  * tensorflow==2.4.0
  * cupy-cuda110=8.3.0
  * torch==1.7.1+cu110
  * torchvision==0.8.2+cu110
  * torchaudio==0.7.2

### Common Machine Learning Packages
  * scipy
  * matplotlib
  * ipython
  * jupyter
  * pandas
  * sympy
  * nose
  * scikit-learn


## Duckietown Package included:

  * aido-protocols-daffy
  * zuper-nodes-z6
  * zuper-typing-z6
  * zuper-ipce-z6
  * zuper-commons-z6

  
## debian package included:

  * cuda-cudart-11-0=11.0.221-1
  * cuda-compat-11-0
  * cuda-libraries-11-0=11.0.3-1
  * libnpp-11-0=11.1.0.245-1
  * cuda-nvtx-11-0=11.0.167-1
  * libcublas-11-0=11.2.0.252-1
  * cuda-nvml-dev-11-0=11.0.167-1
  * cuda-command-line-tools-11-0=11.0.3-1
  * cuda-nvprof-11-0=11.0.221-1
  * libnpp-dev-11-0=11.1.0.245-1
  * cuda-libraries-dev-11-0=11.0.3-1
  * cuda-minimal-build-11-0=11.0.3-1
  * libnccl-dev=2.8.3-1+cuda11.0
  * libnccl2=2.8.3-1+cuda11.0
  * libcublas-dev-11-0=11.2.0.252-1
  * libcusparse-11-0=11.1.1.245-1
  * libcusparse-dev-11-0=11.1.1.245-1
  * libcudnn8=8.0.5.39-1+cuda11.0
  * libcudnn8-dev=8.0.5.39-1+cuda11.0
  * libgl1-mesa-glx
  * python3-tk
