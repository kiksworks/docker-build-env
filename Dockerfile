FROM fedora:25

ENV GRPC_RELEASE_TAG=v1.2.0 \
    LD_LIBRARY_PATH=/usr/local/lib:${LD_LIBRARY_PATH} \
    PKG_CONFIG_PATH=/usr/local/lib/pkgconfig:${PKG_CONFIG_PATH}

# Update and install packages
RUN \
  dnf upgrade -y && \
  dnf install -y \
    autoconf boost boost-devel clang cmake compiler-rt eigen3 findutils \
    git libtool llvm make ninja-build openssl-devel ruby which && \
  dnf clean all && \
  git clone -b ${GRPC_RELEASE_TAG} --recursive https://github.com/grpc/grpc /usr/local/src/grpc && \
  cd /usr/local/src/grpc && \
  make -j"$(nproc)" && \
  make install && \
  rm -rf /usr/local/src/grpc

CMD ["/bin/bash"]
