FROM ubuntu:20.04

ARG NNABLA_VERSION=1.7.0

RUN \
  # Update and install packages \
  apt-get update && \
  DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -y \
    ca-certificates clang cmake curl findutils g++ gcc git libarchive-dev \
    libc-dev libeigen3-dev libgtkmm-3.0-dev libprotobuf-dev libyaml-dev llvm \
    ninja-build openssh-client patchutils protobuf-compiler python3 \
    python3-mako python3-six python3-yaml \
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
  git clone \
    --branch "v${NNABLA_VERSION}" \
    --depth 1 \
    https://github.com/sony/nnabla.git /usr/local/src/nnabla && \
  mkdir -p /usr/local/src/nnabla/build && \
  cd /usr/local/src/nnabla && \
  (curl -L https://gist.githubusercontent.com/Tosainu/bfd73569f433e1887f5eccd6e43af908/raw/42e3d3535528c6432e3560430d7359dd16f90111/use-correct-variables.patch | \
    git apply -) && \
  cd /usr/local/src/nnabla/build && \
  cmake .. -G Ninja -DBUILD_PYTHON_PACKAGE=OFF -DPYTHON_COMMAND_NAME=python3 -DBUILD_CPP_UTILS=ON && \
  ninja  && \
  ninja install && \
  rm -rf /usr/local/src/nnabla
