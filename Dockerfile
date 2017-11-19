FROM fedora:26

ENV GRPC_RELEASE_TAG=v1.7.2 \
    LD_LIBRARY_PATH=/usr/local/lib:${LD_LIBRARY_PATH} \
    PKG_CONFIG_PATH=/usr/local/lib/pkgconfig:${PKG_CONFIG_PATH}

# Update and install packages
RUN \
  dnf upgrade -y && \
  dnf install -y \
    autoconf boost boost-devel clang cmake compiler-rt eigen3 file findutils \
    git libtool llvm make ninja-build ruby unzip which zlib-devel && \
  dnf clean all && \
  git clone \
    --branch "${GRPC_RELEASE_TAG}" \
    --depth 1 \
    --recursive \
    https://github.com/grpc/grpc /usr/local/src/grpc && \
  cd /usr/local/src/grpc/third_party/protobuf && \
  ./autogen.sh && \
  ./configure && \
  make -j"${nproc}" && \
  make install && \
  cd /usr/local/src/grpc && \
  CPPFLAGS="-Wno-error=implicit-fallthrough -Wno-error=conversion" \
     make -j"${nproc}" && \
  make install && \
  rm -rf /usr/local/src/grpc

CMD ["/bin/bash"]
