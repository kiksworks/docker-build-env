FROM fedora:31

ARG GRPC_VERSION=1.18.0

ENV LD_LIBRARY_PATH=/usr/local/lib:${LD_LIBRARY_PATH} \
    PKG_CONFIG_PATH=/usr/local/lib/pkgconfig:${PKG_CONFIG_PATH}

RUN \
  # Update and install packages \
  dnf upgrade -y && \
  dnf install -y \
    autoconf boost-devel clang cmake compiler-rt curl diffutils eigen3 file findutils git \
    libtool libyaml-devel lld llvm make ninja-build openssl-devel unzip which \
    zlib-devel && \
  dnf clean all && \
  # Clone gRPC repository \
  git clone \
    --branch "v${GRPC_VERSION}" \
    --depth 1 \
    https://github.com/grpc/grpc /usr/local/src/grpc && \
  cd /usr/local/src/grpc && \
  git submodule update --init \
    third_party/cares/cares \
    third_party/protobuf && \
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
  rm -rf /usr/local/src/grpc

CMD ["/bin/bash"]
