#!/usr/bin/env bats

@test "python 3.11 should be installed" {
  run python3.11 --version
  [[ "$output" = "Python 3.11"* ]]

  run pip3.11 --version
  [ "$status" -eq 0 ]
}

@test "python 3.12 should be installed" {
  run python3.12 --version
  [[ "$output" = "Python 3.12"* ]]

  run pip3.12 --version
  [ "$status" -eq 0 ]
}
