FROM fedora:31

ARG GRPC_VERSION=1.28.1
ARG NNABLA_VERSION=1.7.0

ENV PKG_CONFIG_PATH=/usr/local/lib/pkgconfig

RUN \
  # Update and install packages \
  dnf upgrade -y && \
  dnf install -y \
    autoconf boost-devel clang cmake compiler-rt curl diffutils eigen3 file \
    findutils git gtkmm30-devel libarchive-devel libasan libtool libyaml-devel lld \
    llvm make ninja-build openssl-devel python3-mako python3-pyyaml python3-six \
    unzip which zlib-devel && \
  dnf clean all && \
  # Set LD_LIBRARY_PATH temporally
  export LD_LIBRARY_PATH=/usr/local/lib:$LD_LIBRARY_PATH && \
  # Clone gRPC repository \
  git clone \
    --branch "v${GRPC_VERSION}" \
    --depth 1 \
    https://github.com/grpc/grpc /usr/local/src/grpc && \
  cd /usr/local/src/grpc && \
  git submodule update --init \
    third_party/abseil-cpp \
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
  cd /usr/local/src/nnabla && \
  (curl -L https://gist.githubusercontent.com/Tosainu/bfd73569f433e1887f5eccd6e43af908/raw/42e3d3535528c6432e3560430d7359dd16f90111/use-correct-variables.patch | \
    git apply -) && \
  cd /usr/local/src/nnabla/build && \
  cmake .. -G Ninja -DBUILD_PYTHON_PACKAGE=OFF -DPYTHON_COMMAND_NAME=python3 -DBUILD_CPP_UTILS=ON && \
  ninja  && \
  ninja install && \
  rm -rf /usr/local/src/grpc /usr/local/src/nnabla && \
  # Configure library dir \
  echo "/usr/local/lib" > /etc/ld.so.conf.d/local-lib.conf && \
  ldconfig -v
