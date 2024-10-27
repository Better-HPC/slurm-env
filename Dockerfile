FROM rockylinux:9

ARG SLURM_VERSION

RUN dnf install -y \
    # Build tools
    rpm-build \
    wget \
  && dnf clean all

# Build Slurm RPMs
RUN wget https://download.schedmd.com/slurm/slurm-$SLURM_VERSION.tar.bz2 \
  && rpmbuild -ta slurm-$SLURM_VERSION.tar.bz2 --with slurmrestd \
  && rm -rf slurm-$SLURM_VERSION.tar.bz2
