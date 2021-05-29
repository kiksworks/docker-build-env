FROM ubuntu:20.04

ARG NNABLA_VERSION=1.11.0
ARG NNABLA_SHA256=adadfc7dd561efe3a533189f377939c05a182aad8740dd793c713aac723111e1

RUN --mount=type=bind,target=/nnabla.patch,source=nnabla-v1.11.0.patch \
  # Update and install packages \
  apt-get update && \
  DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -y \
    ca-certificates clang cmake curl findutils g++ gcc git libarchive-dev \
    libc-dev libeigen3-dev libgtkmm-3.0-dev libhdf5-dev libprotobuf-dev libyaml-dev \
    llvm ninja-build openssh-client patchutils protobuf-compiler \
    python3 python3-mako python3-six python3-yaml \
    # libboost-mpi は依存が大きいので除く (libboost-all-dev を使わない) \
    libboost-atomic-dev libboost-chrono-dev libboost-container-dev \
    libboost-context-dev libboost-coroutine-dev libboost-date-time-dev \
    libboost-dev libboost-exception-dev libboost-fiber-dev \
    libboost-filesystem-dev libboost-graph-dev libboost-graph-parallel-dev \
    libboost-iostreams-dev libboost-locale-dev libboost-log-dev \
    libboost-math-dev libboost-numpy-dev libboost-program-options-dev \
    libboost-python-dev libboost-random-dev libboost-regex-dev \
    libboost-serialization-dev libboost-stacktrace-dev libboost-system-dev \
    libboost-test-dev libboost-thread-dev libboost-timer-dev libboost-tools-dev \
    libboost-type-erasure-dev libboost-wave-dev && \
  rm -rf /var/lib/apt/lists/* && \
  # Build NNabla \
  curl -L https://github.com/sony/nnabla/archive/v${NNABLA_VERSION}.tar.gz -o /nnabla.tar.gz && \
  echo "${NNABLA_SHA256} /nnabla.tar.gz" | sha256sum -c - && \
  mkdir -p /usr/local/src/nnabla && \
  tar xf /nnabla.tar.gz --strip-components=1 -C /usr/local/src/nnabla && \
  cd /usr/local/src/nnabla && \
  patch -p1 < /nnabla.patch && \
  cmake -S . -B build -G Ninja -DBUILD_PYTHON_PACKAGE=OFF -DPYTHON_COMMAND_NAME=python3 -DBUILD_CPP_UTILS=ON -DNNABLA_UTILS_WITH_HDF5=ON && \
  cd /usr/local/src/nnabla/build && \
  ninja  && \
  ninja install && \
  cd / && \
  rm -rf /nnabla.tar.gz /usr/local/src/nnabla
