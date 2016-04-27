#!/usr/bin/env bats

@test "Returning value from buildpack" {
  cp /test/data/exit-code /bin/build
  # Run buildpack
  set +e
  /bin/run
  # Assert
  [ "$?" -eq 123 ]
  set -e
}
