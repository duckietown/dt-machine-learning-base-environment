# parameters
ARG REPO_NAME="dt-machine-learning-base-environment"
ARG MAINTAINER="Andrea F. Daniele (afdaniele@ttic.edu)"
ARG DESCRIPTION="Base image containing common libraries and environment setup for Machine Learning applications."
ARG ICON="square"

ARG ARCH=amd64
ARG DISTRO=daffy
ARG BASE_TAG=${DISTRO}-${ARCH}
ARG BASE_IMAGE=dt-commons
ARG LAUNCHER=default



# define base image
FROM duckietown/${BASE_IMAGE}:${BASE_TAG} as BASE

# recall all arguments
ARG REPO_NAME
ARG DESCRIPTION
ARG MAINTAINER
ARG ICON
ARG ARCH
ARG DISTRO
ARG ROS_DISTRO
ARG BASE_TAG
ARG BASE_IMAGE
ARG LAUNCHER

# nvidia environment
# path setup
ENV PATH /usr/local/nvidia/bin:/usr/local/cuda/bin:${PATH}
ENV LD_LIBRARY_PATH /usr/local/nvidia/lib:/usr/local/nvidia/lib64
ENV LIBRARY_PATH /usr/local/cuda/lib64/stubs
# hostside requirement check
ENV NVIDIA_REQUIRE_CUDA "cuda>=11.0 brand=tesla,driver>=418,driver<419 brand=tesla,driver>=440,driver<441 brand=tesla,driver>=450,driver<451"
ENV NVIDIA_VISIBLE_DEVICES all
ENV NVIDIA_DRIVER_CAPABILITIES compute,utility
ENV LANG C.UTF-8
# verion specification
ENV CUDA_VERSION 11.0.3
ENV NCCL_VERSION 2.8.3
ENV CUDNN_VERSION 8.0.5.39

# define and create repository path
ARG REPO_PATH="${SOURCE_DIR}/src/${REPO_NAME}"
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

# create repo directory
RUN mkdir -p "${REPO_PATH}"

# Architecture specific packages
COPY assets/${ARCH} /tmp/

# setup Nvidia CUDA
RUN /tmp/install_cuda.sh


# install python dependencies
ARG PIP_INDEX_URL
ENV PIP_INDEX_URL=${PIP_INDEX_URL}
COPY ./dependencies-py3.txt "${REPO_PATH}/"
COPY ./requirements.txt "${REPO_PATH}/"
RUN pip3 install -U pip \
    && pip3 install -r ${REPO_PATH}/dependencies-py3.txt -f https://download.pytorch.org/whl/torch_stable.html \
    && pip3 install -r ${REPO_PATH}/requirements.txt \
    && pip3 uninstall -y dataclasses \
    && pip3 cache purge

# copy the source code
COPY ./packages "${REPO_PATH}/packages"

# install launcher scripts
COPY ./launchers/. "${LAUNCH_PATH}/"
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

# nvidia labels
WORKDIR /submission
