# parameters
ARG REPO_NAME="dt-machine-learning-base-environment"
ARG DESCRIPTION="Base image containing common libraries and environment setup for Machine Learning applications."
ARG MAINTAINER="Andrea F. Daniele (afdaniele@duckietown.com)"
# pick an icon from: https://fontawesome.com/v4.7.0/icons/
ARG ICON="cube"

# ==================================================>
# ==> Do not change the code below this line
ARG ARCH
ARG DISTRO=ente
ARG BASE_TAG=${DISTRO}-${ARCH}
ARG BASE_IMAGE=dt-ros-commons
ARG LAUNCHER=default
ARG CUDA_VERSION=10.2

# define base image
ARG DOCKER_REGISTRY=docker.io
FROM ${DOCKER_REGISTRY}/duckietown/${BASE_IMAGE}:${BASE_TAG} as BASE

# recall all arguments
ARG ARCH
ARG DISTRO
ARG REPO_NAME
ARG DESCRIPTION
ARG MAINTAINER
ARG ICON
ARG BASE_TAG
ARG BASE_IMAGE
ARG LAUNCHER
ARG CUDA_VERSION

# check build arguments
RUN dt-build-env-check "${REPO_NAME}" "${MAINTAINER}" "${DESCRIPTION}"

# define/create repository path
ARG REPO_PATH="${SOURCE_DIR}/${REPO_NAME}"
ARG LAUNCH_PATH="${LAUNCH_DIR}/${REPO_NAME}"
RUN mkdir -p "${REPO_PATH}"
RUN mkdir -p "${LAUNCH_PATH}"
WORKDIR "${REPO_PATH}"

# keep some arguments as environment variables
ENV DT_MODULE_TYPE "${REPO_NAME}"
ENV DT_MODULE_DESCRIPTION "${DESCRIPTION}"
ENV DT_MODULE_ICON "${ICON}"
ENV DT_MAINTAINER "${MAINTAINER}"
ENV DT_REPO_PATH "${REPO_PATH}"
ENV DT_LAUNCH_PATH "${LAUNCH_PATH}"
ENV DT_LAUNCHER "${LAUNCHER}"

# generic environment
ENV LANG C.UTF-8

# ==================================================>
# ==> Do not change the code above this line

# add cuda to path
ENV PATH /usr/local/nvidia/bin:/usr/local/cuda/bin:${PATH}
ENV LD_LIBRARY_PATH /usr/local/nvidia/lib:/usr/local/nvidia/lib64

# nvidia-container-runtime
# https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/user-guide.html
ENV NVIDIA_VISIBLE_DEVICES all
ENV NVIDIA_DRIVER_CAPABILITIES all

# this defines the "interface" to our ML backend, it is important to ensure compatibility across architectures
# - CUDA
ENV CUDA_VERSION 10.2.89
ENV CUDA_PKG_VERSION 10-2=$CUDA_VERSION-1
# - NCCL
ENV NCCL_VERSION 2.8.4
# - CuDNN
ENV CUDNN_VERSION 8.1.1.33
# - PyTorch
ENV PYTORCH_VERSION 1.7.0
ENV TORCHVISION_VERSION 0.8.1
# - TensorRT
ENV TENSORRT_VERSION 7.1.3.4
# - PyCuda
ENV PYCUDA_VERSION 2021.1

# install apt dependencies
COPY ./dependencies-apt.txt "${REPO_PATH}/"
RUN dt-apt-install ${REPO_PATH}/dependencies-apt.txt

# install python3 dependencies
ARG PIP_INDEX_URL="https://pypi.org/simple/"
ENV PIP_INDEX_URL=${PIP_INDEX_URL}
RUN echo PIP_INDEX_URL=${PIP_INDEX_URL}

RUN python3 -m pip list
COPY ./dependencies-py3.* "${REPO_PATH}/"
RUN python3 -m pip install  -r ${REPO_PATH}/dependencies-py3.txt

#TODO(AFD): Zuper what?
#! install Zuper dependencies
ARG PIP_INDEX_URL="https://pypi.org/simple/"
ENV PIP_INDEX_URL=${PIP_INDEX_URL}
COPY ./requirements.txt "${REPO_PATH}/"
RUN python3 -m pip install  -r ${REPO_PATH}/requirements.txt

# symlink for CUDA
RUN ln -s /usr/local/cuda-10.2 /usr/local/cuda

# install ML related stuff
COPY assets/${ARCH} "${REPO_PATH}/install"
RUN "${REPO_PATH}/install/install.sh"


# ==================================================>
# ==> Do not change the code below this line

# copy the source code
COPY ./packages "${REPO_PATH}/packages"

# install launcher scripts
COPY ./launchers/. "${LAUNCH_PATH}/"
COPY ./launchers/default.sh "${LAUNCH_PATH}/"
RUN dt-install-launchers "${LAUNCH_PATH}"

# define default command
CMD ["bash", "-c", "dt-launcher-${DT_LAUNCHER}"]

# store module metadata
LABEL org.duckietown.label.module.type="${REPO_NAME}" \
    org.duckietown.label.module.description="${DESCRIPTION}" \
    org.duckietown.label.module.icon="${ICON}" \
    org.duckietown.label.architecture="${ARCH}" \
    org.duckietown.label.code.location="${REPO_PATH}" \
    org.duckietown.label.code.version.distro="${DISTRO}" \
    org.duckietown.label.base.image="${BASE_IMAGE}" \
    org.duckietown.label.base.tag="${BASE_TAG}" \
    org.duckietown.label.maintainer="${MAINTAINER}"
