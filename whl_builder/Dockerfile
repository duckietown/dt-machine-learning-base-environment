FROM duckietown/dt-machine-learning-base-environment:daffy-staging-arm64v8 AS bazel_builder

#=========Bazel=========#
RUN mkdir /BazelBuilder
WORKDIR /BazelBuilder
# Get Bazel
RUN apt update && apt install -y curl unzip openjdk-11-jdk
RUN echo "Downloading Bazel" \
    && wget -q https://github.com/bazelbuild/bazel/releases/download/3.1.0/bazel-3.1.0-dist.zip \
    && echo "Complete!"
RUN unzip -d bazel bazel-3.1.0-dist.zip
WORKDIR /BazelBuilder/bazel
# build bazel
# There has been a bug up stream in bazel requiring linking python to python3
RUN ln -sf /usr/bin/python3 /usr/bin/python
ENV EXTRA_BAZEL_ARGS="--host_javabase=@local_jdk//:jdk --python_path=/usr/bin/python3" 
RUN ./compile.sh
# copy the binary
RUN cp output/bazel /usr/local/bin/bazel
# clean up
RUN bazel

# #########################################################################3

# #=========Tensorflow=========#
FROM duckietown/dt-machine-learning-base-environment:daffy-staging-arm64v8 as TFBuilder
COPY --from=bazel_builder /usr/local/bin/bazel /usr/local/bin/bazel
# Install Compile Dependencies
RUN apt update
RUN apt install -y build-essential make cmake wget zip unzip libhdf5-dev libc-ares-dev libeigen3-dev libatlas-base-dev libopenblas-dev libblas-dev gfortran liblapack-dev python3-h5py openjdk-11-jdk
RUN pip3 install -U setuptools keras_applications keras_preprocessing pybind11 h5py==2.10.0 
RUN bazel
RUN mkdir /TFBuilder
WORKDIR /TFBuilder
# Get repo
RUN git clone -b daffy-2.3.2-arm64v8 https://github.com/duckietown/tensorflow
WORKDIR /TFBuilder/tensorflow
COPY .tf_configure.bazelrc .
RUN export PYTHON_BIN_PATH="/usr/bin/python3"
# There has been a bug up stream in bazel requiring linking python to python3
RUN ln -sf /usr/bin/python3 /usr/bin/python
# Tensorflow uses GCC7 for compiling
RUN apt purge gcc-8 && apt install -y gcc-7
RUN update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-7 7 \
    && update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-7 7 \ 
    && update-alternatives --config gcc \
    && update-alternatives --config g++
RUN gcc --version && g++ --version
#Compile
RUN bazel build --config=cuda //tensorflow/tools/pip_package:build_pip_package
RUN ./bazel-bin/tensorflow/tools/pip_package/build_pip_package /
