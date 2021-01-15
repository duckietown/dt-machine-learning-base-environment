# parameters
ARG REPO_NAME="dt-machine-learning-base-environment"
ARG MAINTAINER="Frank C. Qian (chude.qian@autodrive.utoronto.ca)"
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

# install apt packages
COPY ./dependencies-apt.txt "${REPO_PATH}/"
RUN dt-apt-install "${REPO_PATH}/dependencies-apt.txt" \
    && apt-get autoremove -y  \
    && apt-get autoclean -y

# Install python dependencies
ARG PIP_INDEX_URL
ENV PIP_INDEX_URL=${PIP_INDEX_URL}
COPY ./dependencies-py3.txt "${REPO_PATH}/"
COPY ./requirements.txt "${REPO_PATH}/"
RUN pip3 install -U pip \
    && pip3 install -r ${REPO_PATH}/dependencies-py3.txt \
    && pip3 install -r ${REPO_PATH}/requirements.txt \
    && pip3 cache purge

# ====== Nvidia ENV setup =====#
# path setup
ENV PATH /usr/local/cuda/bin:/usr/local/cuda-10.1/bin:/usr/local/cuda-10.2/bin:${PATH}
ENV LD_LIBRARY_PATH /usr/local/cuda/lib64:/usr/local/cuda/extras/CUPTI/lib64:/usr/local/cuda-10.2/targets/aarch64-linux/lib:${LD_LIBRARY_PATH}
ENV LIBRARY_PATH /usr/local/cuda/lib64/stubs

# hostside requirement check
ENV NVIDIA_REQUIRE_CUDA "cuda>=10.1 brand=tesla,driver>=396,driver<397 brand=tesla,driver>=410,driver<411 brand=tesla,driver>=418,driver<419"
ENV LANG C.UTF-8
ENV NVIDIA_VISIBLE_DEVICES "all"
ENV NVIDIA_DRIVER_CAPABILITIES "compute,utility"
# verion specification
ENV CUDA_VERSION 10.1.243
ENV NCCL_VERSION 2.7.8-1
ENV CUDNN_VERSION 7.6.5.32
# ====== End Nvidia ENV setup =====#

# ====== Start ARCH specific Script ===== #
ARG DEBIAN_FRONTEND=noninteractive

# Architecture specific packages
COPY assets/${ARCH}/ /tmp/

# Install Nvidia CUDA
RUN sudo sh /tmp/install_cuda.sh

# ===== Build Tensorflow from source ===== #

# ===== END Build Tensorflow from source ===== #

# Install tensorflow and pytorch
RUN /tmp/install_py3.sh

RUN rm -r /tmp/*

# ====== End ARCH specific Script ===== #

# Configure Jupyter Lab
# RUN jupyter lab --generate-config \
#     && python3 -c "from notebook.auth.security import set_password; set_password('quackquack', '/root/.jupyter/jupyter_notebook_config.json')"

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

# Set submission folder as default for AIDO challenges
WORKDIR /submission