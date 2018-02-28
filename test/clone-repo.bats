#!/usr/bin/env bats

@test "Cloning repo" {
  source lib/helpers/clone-repo.bash
  clone-repo https://github.com/particle-iot/buildpack-base.git#0.3.6 /workspace
  cd /workspace
  git status
  # Check if it is a real repo
  [ "$?" -eq 0 ]
  # Check head commit id
  hash=`git rev-parse --verify HEAD`
  [ $hash == "ff643792db83feba7cef22bf3edf76d6b07aedf3" ]
}
