FROM rockylinux:9

RUN dnf install -y \
    # Build tools
    rpm-build \
    wget \
  && dnf clean all
