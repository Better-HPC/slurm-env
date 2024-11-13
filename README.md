# Slurm Runtime Environment

A containerized Slurm cluster used for interface testing and development.

## Getting Started

Images are tagged according to the containerized Slurm version.
To launch a specific Slurm version, specify the desired version number directly in the image tag.

```bash
docker pull ghcr.io/better-hpc/slurm-env:[SLURM VERSION]
docker run -it ghcr.io/better-hpc/slurm-env:[SLURM VERSION]
```

## Container Fixtures/Services

The table below outline the clusters, partitions, and nodes defined in the Slurm configuration.

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

