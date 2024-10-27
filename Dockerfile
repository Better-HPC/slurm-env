FROM rockylinux:9

ARG SLURM_VERSION

# Install dependencies
RUN dnf install -y epel-release && crb enable
RUN dnf install -y \
      # Build tools
      rpm-build \
      wget \
      # Slurm Dependencies
      munge-devel \
 && dnf clean all

# Build Slurm RPMs
RUN wget https://download.schedmd.com/slurm/slurm-$SLURM_VERSION.tar.bz2 \
 && rpmbuild -ta slurm-$SLURM_VERSION.tar.bz2 --with slurmrestd \
 && rm -rf slurm-$SLURM_VERSION.tar.bz2
