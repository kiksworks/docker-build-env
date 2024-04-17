FROM ubuntu:jammy@sha256:1b8d8ff4777f36f19bfe73ee4df61e3a0b789caeff29caa019539ec7c9a57f95

ARG NNABLA_VERSION=1.11.0
ARG NNABLA_SHA256=adadfc7dd561efe3a533189f377939c05a182aad8740dd793c713aac723111e1

RUN --mount=type=bind,target=/nnabla.patch,source=nnabla-v1.11.0.patch \
  # Update and install packages \
  apt-get update && \
  DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -y \
    ca-certificates clang cmake curl findutils g++ gcc git gpg gpgv libarchive-dev \
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
  # ROS 2 \
  curl -L https://raw.githubusercontent.com/ros/rosdistro/master/ros.key -o /usr/share/keyrings/ros-archive-keyring.gpg && \
  echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] http://packages.ros.org/ros2/ubuntu $(. /etc/os-release && echo $UBUNTU_CODENAME) main" \
    >> /etc/apt/sources.list.d/ros2.list && \
  apt-get update && \
  DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -y \
    ros-dev-tools ros-iron-ros-base ros-iron-pendulum-msgs && \
  rm -rf /var/lib/apt/lists/* && \
  # Build NNabla \
  curl -L https://github.com/sony/nnabla/archive/v${NNABLA_VERSION}.tar.gz -o /tmp/nnabla.tar.gz && \
  echo "${NNABLA_SHA256} /tmp/nnabla.tar.gz" | sha256sum -c - && \
  mkdir -p /tmp/nnabla-src && \
  tar xf /tmp/nnabla.tar.gz --strip-components=1 -C /tmp/nnabla-src && \
  patch -d /tmp/nnabla-src -Np1 < /nnabla.patch && \
  cmake -S /tmp/nnabla-src -B /tmp/nnabla-build -G Ninja -D CMAKE_BUILD_TYPE=Release -D BUILD_PYTHON_PACKAGE=OFF -D PYTHON_COMMAND_NAME=python3 -D BUILD_CPP_UTILS=ON -D NNABLA_UTILS_WITH_HDF5=ON && \
  cmake --build /tmp/nnabla-build -- install && \
  rm -rf /tmp/nnabla.tar.gz /tmp/nnabla-src /tmp/nnabla-build
