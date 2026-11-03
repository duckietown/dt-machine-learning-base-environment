# parameters
ARG PROJECT_NAME
ARG PROJECT_DESCRIPTION
ARG PROJECT_MAINTAINER
# pick an icon from: https://fontawesome.com/v4.7.0/icons/
ARG PROJECT_ICON="cube"
ARG PROJECT_FORMAT_VERSION

# ONNX Runtime, the inference runtime this image provides on every architecture:
# - amd64: onnxruntime-gpu from PyPI, with the CUDA 12 and cuDNN 9 user-space libraries from pip (nvidia-* wheels);
#   the GPU is used when the container runs with an NVIDIA driver (e.g., `--gpus all`), the CPU otherwise.
ARG ONNXRUNTIME_GPU_VERSION="1.23.2"
# - arm64v8: the JetPack 4.6.x build for Python 3.8 from the Jetson Zoo (https://elinux.org/Jetson_Zoo#ONNX_Runtime),
#   with the TensorRT and CUDA execution providers (links libcudart.so.10.2, libnvinfer.so.8). Leave the wheel empty for a
#   CPU-only image. A wheel built for another JetPack still gives a working image: its GPU providers fail to load and
#   inference runs on the CPU. JetPack 5.1.x would be onnxruntime_gpu 1.16.0,
#   https://nvidia.box.com/shared/static/iizg3ggrtdkqawkmebbfixo7sce6j365.whl (sha256 44c82c33c41a0670702c67af1f1425002d57f66d5efb971b35e86067d0e971d9).
ARG ONNXRUNTIME_GPU_WHEEL="https://nvidia.box.com/shared/static/2sv2fv1wseihaw8ym0d4srz41dzljwxh.whl"
# filename to give the downloaded wheel (pip needs a valid wheel filename; box.com links have opaque names)
ARG ONNXRUNTIME_GPU_WHEEL_NAME="onnxruntime_gpu-1.11.0-cp38-cp38-linux_aarch64.whl"
# checked after the download when set (clear it when passing another wheel)
ARG ONNXRUNTIME_GPU_WHEEL_SHA256="127a6f95ba315b8a7a71ac52d1f4f68cd225a4887e77f11ea24091cd0211b185"

# ==================================================>
# ==> Do not change the code below this line
ARG ARCH
ARG DISTRO
ARG DOCKER_REGISTRY
ARG BASE_REPOSITORY
ARG BASE_ORGANIZATION=duckietown
ARG BASE_TAG=${DISTRO}-${ARCH}
ARG LAUNCHER=default

# define base image
# The base image depends on the architecture:
#  - amd64 (laptops, servers): dt-commons (Ubuntu 24.04, Python 3.12).
#  - arm64v8 (Duckiebots, Jetson Nano with JetPack 4.6.x): dt-legacy-py38-environment (Ubuntu 20.04, Python 3.8), the
#    Python version the JetPack 4 GPU wheels exist for. CUDA, cuDNN and TensorRT are NOT installed in the image: the NVIDIA
#    container runtime (the default Docker runtime on the Duckietown Jetson images) mounts them from the host, and Ubuntu
#    20.04 is glibc-compatible with those host libraries.
# Each stage defines the versions this image provides on that architecture (the "interface" to the ML backend).
FROM ${DOCKER_REGISTRY}/${BASE_ORGANIZATION}/${BASE_REPOSITORY}:${BASE_TAG} AS base-amd64
# - CUDA / cuDNN: user-space libraries installed with pip next to ONNX Runtime
# - PyTorch: the version dt-machine-learning-base-pytorch installs
ENV CUDA_VERSION=12 \
    CUDNN_VERSION=9 \
    ONNXRUNTIME_VERSION=1.23.2 \
    PYTORCH_VERSION=2.5.1 \
    TORCHVISION_VERSION=0.20.1 \
    LD_LIBRARY_PATH=/usr/local/nvidia/lib:/usr/local/nvidia/lib64

FROM ${DOCKER_REGISTRY}/${BASE_ORGANIZATION}/dt-legacy-py38-environment:${BASE_TAG} AS base-arm64v8
# - CUDA / cuDNN / TensorRT: provided by the host (JetPack 4.6.x, L4T r32.7)
# - PyTorch: the version dt-machine-learning-base-pytorch installs (Duckietown-built Python 3.8 wheel)
ENV CUDA_VERSION=10.2.300 \
    CUDNN_VERSION=8.2.1.32 \
    TENSORRT_VERSION=8.2.1.9 \
    ONNXRUNTIME_VERSION=1.11.0 \
    PYTORCH_VERSION=1.7.0 \
    TORCHVISION_VERSION=0.8.1 \
    LD_LIBRARY_PATH=/usr/local/cuda/lib64:/usr/local/cuda-10.2/lib64:/usr/lib/aarch64-linux-gnu/tegra

FROM base-${ARCH} AS base

# recall all arguments
ARG ARCH
ARG DISTRO
ARG DOCKER_REGISTRY
ARG PROJECT_NAME
ARG PROJECT_DESCRIPTION
ARG PROJECT_MAINTAINER
ARG PROJECT_ICON
ARG PROJECT_FORMAT_VERSION
ARG BASE_TAG
ARG BASE_REPOSITORY
ARG BASE_ORGANIZATION
ARG LAUNCHER
ARG ONNXRUNTIME_GPU_VERSION
ARG ONNXRUNTIME_GPU_WHEEL
ARG ONNXRUNTIME_GPU_WHEEL_NAME
ARG ONNXRUNTIME_GPU_WHEEL_SHA256
# - buildkit
ARG TARGETPLATFORM
ARG TARGETOS
ARG TARGETARCH
ARG TARGETVARIANT

# check build arguments
RUN dt-args-check \
    "PROJECT_NAME" "${PROJECT_NAME}" \
    "PROJECT_DESCRIPTION" "${PROJECT_DESCRIPTION}" \
    "PROJECT_MAINTAINER" "${PROJECT_MAINTAINER}" \
    "PROJECT_ICON" "${PROJECT_ICON}" \
    "PROJECT_FORMAT_VERSION" "${PROJECT_FORMAT_VERSION}" \
    "ARCH" "${ARCH}" \
    "DISTRO" "${DISTRO}" \
    "DOCKER_REGISTRY" "${DOCKER_REGISTRY}" \
    "BASE_REPOSITORY" "${BASE_REPOSITORY}" \
    && dt-check-project-format "${PROJECT_FORMAT_VERSION}"

# define/create repository path
ARG PROJECT_PATH="${SOURCE_DIR}/${PROJECT_NAME}"
ARG PROJECT_LAUNCHERS_PATH="${LAUNCHERS_DIR}/${PROJECT_NAME}"
RUN mkdir -p "${PROJECT_PATH}" "${PROJECT_LAUNCHERS_PATH}"
WORKDIR "${PROJECT_PATH}"

# keep some arguments as environment variables
ENV DT_PROJECT_NAME="${PROJECT_NAME}" \
    DT_PROJECT_DESCRIPTION="${PROJECT_DESCRIPTION}" \
    DT_PROJECT_MAINTAINER="${PROJECT_MAINTAINER}" \
    DT_PROJECT_ICON="${PROJECT_ICON}" \
    DT_PROJECT_PATH="${PROJECT_PATH}" \
    DT_PROJECT_LAUNCHERS_PATH="${PROJECT_LAUNCHERS_PATH}" \
    DT_LAUNCHER="${LAUNCHER}"

# CUDA tools on the path when present (host-mounted on the Jetson)
ENV PATH=/usr/local/nvidia/bin:/usr/local/cuda/bin:${PATH}

# nvidia-container-runtime: expose the GPU and the driver/CUDA libraries
# https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/user-guide.html
ENV NVIDIA_VISIBLE_DEVICES=all \
    NVIDIA_DRIVER_CAPABILITIES=all

# install apt dependencies
COPY ./dependencies-apt.txt "${PROJECT_PATH}/"
RUN dt-apt-install ${PROJECT_PATH}/dependencies-apt.txt

# install python3 dependencies (before ONNX Runtime, so that it uses the numpy pinned here)
# - keep uv's download cache out of the image layers (it would double the size of the CUDA libraries); as a build
#   argument it applies to the RUN steps below and does not end up in the image environment
ARG UV_NO_CACHE=1
ARG PIP_INDEX_URL="https://pypi.org/simple"
ENV PIP_INDEX_URL=${PIP_INDEX_URL}
COPY ./dependencies-py3.* "${PROJECT_PATH}/"
RUN dt-pip3-install "${PROJECT_PATH}/dependencies-py3.*"

# install ONNX Runtime (architecture specific, see the ONNXRUNTIME_* arguments at the top)
COPY assets/${ARCH} "${PROJECT_PATH}/install"
RUN "${PROJECT_PATH}/install/install.sh"

# copy the source code
COPY ./packages "${PROJECT_PATH}/packages"

# install launcher scripts
COPY ./launchers/. "${PROJECT_LAUNCHERS_PATH}/"
RUN dt-install-launchers "${PROJECT_LAUNCHERS_PATH}"

# install scripts
COPY ./assets/entrypoint.d "${PROJECT_PATH}/assets/entrypoint.d"
COPY ./assets/environment.d "${PROJECT_PATH}/assets/environment.d"

# define default command
CMD ["bash", "-c", "dt-launcher-${DT_LAUNCHER}"]

# store module metadata
LABEL \
    # module info
    org.duckietown.label.project.name="${PROJECT_NAME}" \
    org.duckietown.label.project.description="${PROJECT_DESCRIPTION}" \
    org.duckietown.label.project.maintainer="${PROJECT_MAINTAINER}" \
    org.duckietown.label.project.icon="${PROJECT_ICON}" \
    org.duckietown.label.project.path="${PROJECT_PATH}" \
    org.duckietown.label.project.launchers.path="${PROJECT_LAUNCHERS_PATH}" \
    # format
    org.duckietown.label.format.version="${PROJECT_FORMAT_VERSION}" \
    # platform info
    org.duckietown.label.platform.os="${TARGETOS}" \
    org.duckietown.label.platform.architecture="${TARGETARCH}" \
    org.duckietown.label.platform.variant="${TARGETVARIANT}" \
    # code info
    org.duckietown.label.code.distro="${DISTRO}" \
    org.duckietown.label.code.launcher="${LAUNCHER}" \
    org.duckietown.label.code.python.registry="${PIP_INDEX_URL}" \
    # base info
    org.duckietown.label.base.organization="${BASE_ORGANIZATION}" \
    org.duckietown.label.base.repository="${BASE_REPOSITORY}" \
    org.duckietown.label.base.tag="${BASE_TAG}"
# <== Do not change the code above this line
# <==================================================
