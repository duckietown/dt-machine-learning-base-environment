# dt-machine-learning-base-environment

Base image for machine-learning software in Duckietown. It provides [ONNX Runtime](https://onnxruntime.ai), with GPU
support on amd64 and on the Duckiebots' Jetson, plus the scientific Python stack (numpy, scipy, pandas, matplotlib, seaborn, onnx).
`dt-machine-learning-base-pytorch` adds PyTorch on top of it.

The standard way to run a trained model on a robot is to export it to ONNX and run it with ONNX Runtime. Training
happens on a laptop, a server or Colab.

## Platforms

| | amd64 (laptops, servers) | arm64v8 (Apple Silicon, virtual robots, other arm64) | arm64v8, JetPack 4 (Duckiebots, Jetson Nano) |
|---|---|---|---|
| Tag | `ente-amd64` | `ente-arm64v8` | `ente-jetpack4-arm64v8` |
| Base image | `dt-commons` (Ubuntu 24.04) | `dt-commons` (Ubuntu 24.04) | `dt-legacy-py38-environment` (Ubuntu 20.04) |
| Python | 3.12 | 3.12 | 3.8 |
| ONNX Runtime | `onnxruntime-gpu` 1.23.2 from PyPI | `onnxruntime` 1.23.2 from PyPI | `onnxruntime_gpu` 1.11.0, JetPack 4.6.x build from the [Jetson Zoo](https://elinux.org/Jetson_Zoo#ONNX_Runtime) |
| Execution providers | CUDA (TensorRT if installed), CPU | CPU | TensorRT, CUDA, CPU |
| CUDA, cuDNN | CUDA 12 and cuDNN 9 user-space libraries from pip (`nvidia-*`) | none | from the host (JetPack 4.6.x: CUDA 10.2, cuDNN 8.2, TensorRT 8.2) |
| PyTorch (in `dt-machine-learning-base-pytorch`) | 2.5.1 from PyPI (CUDA) | 2.5.1, CPU build | 1.7.0, Duckietown-built Jetson wheel (imports only on a Jetson) |
| What the host provides | the NVIDIA driver, through the NVIDIA container toolkit (`--gpus all`) | nothing | CUDA, cuDNN and TensorRT, mounted by the NVIDIA container runtime |

A Mac with Apple Silicon and a Jetson are both `linux/arm64` to Docker, so the tag alone cannot tell them apart. The
JetPack variant is a separate tag, and `dts devel build` (also behind `dts code build`) picks it: when the Docker
endpoint it builds on is a Jetson (an L4T `4.9.x-tegra` kernel), it passes `--build-arg JETPACK=4`. This image uses the
argument to select its JetPack stage; images built on it select the base tag with it:

```dockerfile
ARG JETPACK=
ARG BASE_TAG=${DISTRO}${JETPACK:+-jetpack${JETPACK}}-${ARCH}
```

Everywhere else, including a laptop running `dts code build --local` and a virtual robot, the argument is empty and the
plain `arm64v8` image is used. An older `dts`, which does not pass the argument, gets the plain image too: it runs on a
Jetson as well, on the CPU. To force a choice, pass `--build-arg JETPACK 4` or `--build-arg JETPACK ""`.

The JetPack variant runs Python 3.8 because the JetPack 4 GPU builds of ONNX Runtime target Python 3.6 and 3.8, and the
DTPS client needs Python 3.8 or newer. The CUDA, cuDNN and TensorRT libraries are not in the image. The NVIDIA container
runtime, the default Docker runtime on the Duckietown Jetson images, mounts them from the host, and Ubuntu 20.04 is
compatible with them. Without a GPU, every image still works and runs inference on the CPU.

Each platform sets the versions it provides as environment variables: `ML_PLATFORM` (`amd64`, `arm64v8` or
`arm64v8-jetpack4`), `CUDA_VERSION`, `CUDNN_VERSION`, `TENSORRT_VERSION` (JetPack only), `ONNXRUNTIME_VERSION`,
`PYTORCH_VERSION` and `TORCHVISION_VERSION` (the PyTorch that `dt-machine-learning-base-pytorch` installs).

Python dependencies that differ between Python 3.8 and 3.12 carry a `python_version` marker in
`dependencies-py3.txt`. Images built on this one should do the same.

## Using it

Create the ONNX Runtime session with the GPU providers first. ONNX Runtime falls back to the next provider when one cannot
load:

```python
import onnxruntime as ort

wanted = ["TensorrtExecutionProvider", "CUDAExecutionProvider", "CPUExecutionProvider"]
providers = [p for p in wanted if p in ort.get_available_providers()]
session = ort.InferenceSession("model.onnx", providers=providers)
print(session.get_providers())  # the providers actually in use
```

On the Jetson, the TensorRT provider builds an engine the first time it sees a model, which takes minutes on a Nano.
Cache it next to the model with the provider options
`{"trt_engine_cache_enable": True, "trt_engine_cache_path": "<dir>"}`. The ONNX Runtime 1.11 on the robot reads models
up to opset 16.

## Testing

```
dts devel run -H ROBOT -L self-test                                  # on a Duckiebot
dts devel run -L self-test                                           # on this machine
docker run --rm -e ML_SELF_TEST_REQUIRE_GPU=1 IMAGE dt-launcher-self-test   # fail when no GPU provider works
```

The self-test prints the Python and ONNX Runtime versions, the libraries each GPU provider cannot find (for example the
host CUDA and TensorRT libraries when they are not mounted), and which provider actually ran a small convolutional
model. It also checks PyTorch when it is installed.

## Building and publishing

```
dts devel build -a amd64 --push                                       # ente-amd64
dts devel build -a arm64v8 --push                                     # ente-arm64v8, on any arm64 machine but a Jetson
dts devel build -H ROBOT --tag ente-jetpack4 --push                   # ente-jetpack4-arm64v8, on a Duckiebot
dts devel build -a arm64v8 --tag ente-jetpack4 --build-arg JETPACK 4 --push   # the same, elsewhere
```

`--tag` names the variant (`dts` appends the architecture); `JETPACK` selects its content. Publish the JetPack variant
before images that use it are built on a robot.

## Build arguments

| Argument | Default | Meaning |
|---|---|---|
| `JETPACK` | empty (`4` from `dts` on a JetPack 4 Jetson) | arm64v8: JetPack major version of the Jetson variant; empty for the plain image |
| `ONNXRUNTIME_GPU_VERSION` | `1.23.2` | amd64: `onnxruntime-gpu` version from PyPI (a CUDA 12 build) |
| `ONNXRUNTIME_CPU_VERSION` | `1.23.2` | arm64v8: `onnxruntime` version from PyPI (CPU) |
| `ONNXRUNTIME_GPU_WHEEL` | JetPack 4.6.x wheel | arm64v8, JetPack: wheel URL; empty for a CPU-only image |
| `ONNXRUNTIME_GPU_WHEEL_NAME` | `onnxruntime_gpu-1.11.0-cp38-cp38-linux_aarch64.whl` | arm64v8, JetPack: filename for the downloaded wheel |
| `ONNXRUNTIME_GPU_WHEEL_SHA256` | checksum of the default wheel | arm64v8, JetPack: checked after the download; empty to skip |

For a JetPack 5.1.x robot (Xavier, Orin), use the onnxruntime_gpu 1.16.0 wheel listed in the `Dockerfile`.
