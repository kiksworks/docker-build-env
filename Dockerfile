FROM fedora:31

ARG GRPC_VERSION=1.24.3
ARG NNABLA_VERSION=1.4.0

ENV LD_LIBRARY_PATH=/usr/local/lib:${LD_LIBRARY_PATH} \
    PKG_CONFIG_PATH=/usr/local/lib/pkgconfig:${PKG_CONFIG_PATH}

RUN \
  # Update and install packages \
  dnf upgrade -y && \
  dnf install -y \
    autoconf boost-devel clang cmake compiler-rt curl diffutils eigen3 file findutils git \
    gtkmm30-devel libarchive-devel libtool libyaml-devel lld llvm make ninja-build openssl-devel \
    python3-mako python3-pyyaml python3-six python3-wheel \
    unzip which zlib-devel && \
  dnf clean all && \
  # Clone gRPC repository \
  git clone \
    --branch "v${GRPC_VERSION}" \
    --depth 1 \
    https://github.com/grpc/grpc /usr/local/src/grpc && \
  cd /usr/local/src/grpc && \
  git submodule update --init \
    third_party/cares/cares \
    third_party/protobuf \
    third_party/upb && \
  # Build and install protobuf \
  cd /usr/local/src/grpc/third_party/protobuf && \
  ./autogen.sh && \
  ./configure && \
  make -j$(nproc) && \
  make install && \
  # Build and install gRPC \
  cd /usr/local/src/grpc && \
  CPPFLAGS="-w" make -j$(nproc) && \
  make install && \
  # Build NNabla \
  git clone \
    --branch "v${NNABLA_VERSION}" \
    --depth 1 \
    https://github.com/sony/nnabla.git /usr/local/src/nnabla && \
  mkdir -p /usr/local/src/nnabla/build && \
  cd /usr/local/src/nnabla/build && \
  cmake .. -DBUILD_PYTHON_PACKAGE=OFF -DPYTHON_COMMAND_NAME=python3 -DBUILD_CPP_UTILS=ON && \
  make -j$(nproc) && \
  make install && \
  rm -rf /usr/local/src/grpc /usr/local/src/nnabla

CMD ["/bin/bash"]
