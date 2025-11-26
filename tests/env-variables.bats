#!/usr/bin/env bats

@test "CLUSTER_TYPE variable should be defined" {
  [[ -n "$CLUSTER_TYPE" ]]
  [ "$CLUSTER_TYPE" = "slurm" ]
}

@test "CLUSTER_VERSION variable should be defined" {
  [[ -n "$CLUSTER_VERSION" ]]
}
