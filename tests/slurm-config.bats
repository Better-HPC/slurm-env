#!/usr/bin/env bats

@test "Slurm cluster should exists" {
  run sacctmgr show clusters format=Cluster --noheader --parsable2
  [ "$output" = "bhpc" ]
}

@test "multiple partitions should be available" {
  run scontrol show partition
  [[ "$output" = *"PartitionName=partition1"* ]]
  [[ "$output" = *"PartitionName=partition2"* ]]
}
