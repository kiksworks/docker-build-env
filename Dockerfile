FROM fedora:24

ENV GRPC_RELEASE_TAG v1.0.0

# Update and install packages
RUN \
  dnf upgrade -y && \
  dnf install -y autoconf boost boost-devel clang cmake compiler-rt findutils git libtool llvm make ninja-build ruby which && \
  dnf clean all && \
  git clone -b ${GRPC_RELEASE_TAG} --recursive https://github.com/grpc/grpc /usr/local/src/grpc && \
  cd /usr/local/src/grpc && \
  make -j"$(nproc)" && \
  make install && \
  cd third_party/protobuf && \
  make -j"$(nproc)" && \
  make install && \
  rm -rf /usr/local/src/grpc

# Set environment variables
ENV LD_LIBRARY_PATH /usr/local/lib:${LD_LIBRARY_PATH}
ENV PKG_CONFIG_PATH /usr/local/lib/pkgconfig:${PKG_CONFIG_PATH}

CMD ["/bin/bash"]
