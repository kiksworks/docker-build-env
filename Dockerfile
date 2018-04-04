FROM fedora:27

ENV GRPC_VERSION=1.10.0 \
    LD_LIBRARY_PATH=/usr/local/lib:${LD_LIBRARY_PATH} \
    PKG_CONFIG_PATH=/usr/local/lib/pkgconfig:${PKG_CONFIG_PATH}

RUN \
  # Update and install packages \
  dnf upgrade -y && \
  dnf install -y \
    autoconf boost boost-devel clang cmake compiler-rt curl eigen3 file findutils \
    git libtool libyaml-devel llvm make ninja-build unzip which zlib-devel && \
  dnf clean all && \
  # Clone gRPC repository \
  git clone \
    --branch "v${GRPC_VERSION}" \
    --depth 1 \
    --recursive \
    https://github.com/grpc/grpc /usr/local/src/grpc && \
  # Build and install protobuf \
  cd /usr/local/src/grpc/third_party/protobuf && \
  ./autogen.sh && \
  ./configure && \
  make -j$(nproc) && \
  make install && \
  # Build and install gRPC \
  cd /usr/local/src/grpc && \
  make -j$(nproc) && \
  make install && \
  rm -rf /usr/local/src/grpc && \
  # Workaround \
  cd /usr/local/lib && \
  ln -s "libgrpc++.so.${GRPC_VERSION}" libgrpc++.so.1

CMD ["/bin/bash"]
