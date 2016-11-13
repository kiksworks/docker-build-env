FROM fedora:24

# Update and install packages
RUN \
  dnf upgrade -y && \
  dnf install -y autoconf boost boost-devel clang cmake findutils git libtool make ninja-build ruby which && \
  dnf clean all

# Build and install gRPC
ENV GRPC_RELEASE_TAG v1.0.0
RUN \
  git clone -b ${GRPC_RELEASE_TAG} --recursive https://github.com/grpc/grpc /usr/local/src/grpc && \
  cd /usr/local/src/grpc && \
  make -j"$(nproc)" && \
  make install && \
  cd third_party/protobuf && \
  make -j"$(nproc)" && \
  make install && \
  rm -rf /usr/local/src/grpc

CMD ["/bin/bash"]
