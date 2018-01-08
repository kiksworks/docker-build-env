FROM fedora:27

ENV GRPC_VERSION=1.8.3 \
    LD_LIBRARY_PATH=/usr/local/lib:${LD_LIBRARY_PATH} \
    PKG_CONFIG_PATH=/usr/local/lib/pkgconfig:${PKG_CONFIG_PATH}

RUN \
  # Update and install packages \
  dnf upgrade -y && \
  dnf install -y \
    autoconf boost boost-devel clang cmake compiler-rt curl eigen3 file findutils \
    git libtool llvm make ninja-build unzip which yaml-cpp-devel zlib-devel && \
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
  CPPFLAGS="-Wno-error=implicit-fallthrough -Wno-error=conversion" \
     make -j$(nproc) && \
  make install && \
  rm -rf /usr/local/src/grpc && \
  # Workaround \
  cd /usr/local/lib && \
  ln -s "libgrpc++.so.${GRPC_VERSION}" libgrpc++.so.1

CMD ["/bin/bash"]
