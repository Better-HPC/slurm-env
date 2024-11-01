# Slurm Runtime Environment

A containerized collection of Slurm services used for testing and development.

## Getting Started

Containers are provided for several different Slurm versions.
To launch a specific Slurm version, specify the desired version number in the image tag.

```bash
docker pull ghcr.io/better-hpc/slurm-env:[SLURM VERSION]
docker run -it ghcr.io/better-hpc/slurm-env:[SLURM VERSION]
```

Containers will automatically launch any required Slurm daemons and supporting services.
The table below outline the available clusters, partitions, and nodes.
All Slurm resources are accessible using the standard Slurm CLI utilities.

| Cluster | Partition    | Nodes        |
|---------|--------------|--------------|
| `bhpc`  | `partition1` | `node[1-5]`  |
| `bhpc`  | `partition2` | `node[6-10]` |
