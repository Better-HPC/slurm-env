FROM rockylinux:9 AS build

ARG SLURM_VERSION

# Install build tools / Slurm dependencies
RUN dnf install -y epel-release  \
 && crb enable \
 && dnf install -y \
      # Build tools
      rpm-build \
      wget \
      # Slurm Dependencies
      autoconf \
      automake \
      hdf5-devel \
      http-parser-devel \
      json-c-devel \
      libjwt-devel \
      libyaml-devel \
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

ARG SLURM_VERSION

# Copy RPM files from build step
COPY --from=build /root/rpmbuild/RPMS/*/slurm-*.rpm /rpms/

# Install system packages
RUN dnf install -y epel-release  \
 && crb enable \
 && dnf install -y \
        /rpms/* \
        bats \
        mariadb-server \
        python3.11 \
        python3.11-pip \
        python3.12 \
        python3.12-pip \
 && dnf clean all \
 && rm -rf /var/cache/dnf \
 && rm -rf /rpms/

# Install MySQL/MariaDB
RUN /usr/bin/mysql_install_db \
 && chown -R mysql:mysql /var/lib/mysql \
 && chown -R mysql:mysql /var/log/mariadb

# Create system resources required by Slurm
RUN groupadd -r slurm && useradd -r -g slurm slurm
COPY --chown=slurm configs/$SLURM_VERSION/slurm.conf /etc/slurm/slurm.conf
COPY --chown=slurm --chmod=600 configs/$SLURM_VERSION/slurmdbd.conf /etc/slurm/slurmdbd.conf

# Launch Slurm and supporting services
COPY entrypoint.sh /entrypoint.sh
COPY tests /tests
ENTRYPOINT ["/entrypoint.sh"]
