FROM fedora:24

# Update and install packages
RUN \
  dnf upgrade -y && \
  dnf install -y autoconf boost boost-devel clang cmake findutils git libtool make ninja-build ruby which && \
  dnf clean all

CMD ["/bin/bash"]
