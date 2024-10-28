FROM rockylinux:9 AS build

ARG SLURM_VERSION

# Install dependencies
RUN dnf install -y epel-release && crb enable
RUN dnf install -y \
      # Build tools
      rpm-build \
      wget \
      # Slurm Dependencies \
      hdf5-devel \
      http-parser-devel \
      json-c-devel \
      mariadb-devel \
      munge-devel \
      pam-devel \
      perl-ExtUtils-MakeMaker \
      readline-devel \
      systemd \
 && dnf clean all

# Build Slurm RPMs
RUN wget https://download.schedmd.com/slurm/slurm-$SLURM_VERSION.tar.bz2 \
 && rpmbuild -ta slurm-$SLURM_VERSION.tar.bz2 --with slurmrestd \
 && rm -rf slurm-$SLURM_VERSION.tar.bz2


FROM rockylinux:9

# Copy RPM files from build step
COPY --from=build /root/rpmbuild/RPMS/*/slurm-*.rpm /rpms/

# Install Slurm
RUN dnf install -y /rpms/* \
 && dnf clean all \
 && rm -rf /var/cache/dnf \
 && rm -rf /rpms/
