# Slurm Runtime Environment

A containerized Slurm cluster used for interface testing and development.

## Getting Started

Published images are tagged according to the containerized Slurm version.
To launch a specific Slurm version, specify the desired version number directly in the image tag.

```bash
docker pull ghcr.io/better-hpc/slurm-env:[SLURM VERSION]
docker run ghcr.io/better-hpc/slurm-env:[SLURM VERSION]
```

Images can also be built locally by specifying the desired Slurm version at build time.
Builds are supported for all Slurm versions with a corresponding configuration file in the `configs` directory.
The build process downloads and compiles Slurm from source and may take several minutes to complete.

```bash
docker build \
  --build-arg SLURM_VERSION=[SLURM VERSION] \
  -t slurm-env:local \
  .
```

Compiled images include tests to ensure the generated container is functioning properly.
These tests can be run from any running container instance.

```bash
docker run -i [IMAGE NAME] bats /tests
```

## Fixtures and Services

The table below outlines the clusters, partitions, and nodes defined in the Slurm configuration.

| Cluster | Partition    | Nodes        |
|---------|--------------|--------------|
| `bhpc`  | `partition1` | `node[1-5]`  |
| `bhpc`  | `partition2` | `node[6-10]` |

Containers are designed to include all core services/utilities required by Slurm.
This includes the following daemons and CLI utilities:

**Running Services**

- `slurmctld`
- `slurmd`
- `slurmdbd`
- `slurmrestd`

**CLI Utilities**

- `salloc`
- `sbatch`
- `sacct`
- `sacctmgr`
- `sbcast`
- `scancel`
- `squeue`
- `sinfo`
- `scontrol`

## Adding Slurm Versions

Support for new Slurm versions is added to this project in two steps:

1. Add the new Slurm config files to the `configs` directory.
   The subdirectory should be named after the corresponding Slurm version.
2. Ensure the new version is discoverable by the project's CI/CD workflows by adding the version number to the build matrix in [configs/matrix.json](configs/matrix.json).
