# Buildpack base

[![Build Status](https://travis-ci.org/spark/buildpack-base.svg)](https://travis-ci.org/spark/buildpack-base)

Buildpacks inherit and extend other images to separate common flow and logic in OOP manner.
This image provides [main flow](#flow) and some [helper functions](#helper-functions) that can be used by other images by [inheriting it](#inheriting-image).

| |
|---|
|  [Particle firmware](https://github.com/spark/firmware-buildpack-builder)  |
| [HAL](https://github.com/spark/buildpack-hal) / [Legacy](https://github.com/spark/buildpack-0.3.x)   |
| [Wiring preprocessor](https://github.com/spark/buildpack-wiring-preprocessor) |
| **Base (you are here)** |


## Building image

```bash
$ export BUILDPACK_IMAGE=base
$ git clone "git@github.com:spark/buildpack-${BUILDPACK_IMAGE}.git"
$ cd buildpack-$BUILDPACK_IMAGE
$ docker build -t particle/buildpack-$BUILDPACK_IMAGE .
```

## Flow

Image entrypoint is [run.sh script](scripts/run.sh). It will:
1. load helper functions from [lib directory](lib)
2. Init environment variables with [defaults](hooks/env)
3. Setup logging
4. Copy input files to workspace directory
5. Execute build (by calling `/hooks/build` script)
6. Cleanup [output](#normalization-of-paths-and-filenames)

## Inheriting image

```Dockerfile
FROM particle/buildpack-base

# ...

COPY foo /foo
```

### Using hooks

When creating your own buildpack you can create your own hooks in `/hooks` directory:

* `post-env` - used to set up environment variables
* `pre-build` - prepare workspace before build
* `build` - invoke build command
* `post-build` - clean up after build

### Defined volumes

When running container use `-v` argument to specify local dirs which will be mapped to those volumes.

* `/input` - should contain all project files
* `/output` - after build will contain logs and build artifacts
* `/cache` - temp directory to store intermediate files
* `/ssh` - directory containing SSH keys (will be copied to `~/.ssh`)

### Normalization of paths and filenames

Outputed firmware binary should be named `firmware.bin` unless compile produces more binaries and their filenames have to be preserved.

`stderr` file paths should start with `$WORKSPACE_DIR/` (this should be the root of a project).
`find-and-replace-in` function can be used to replace whatever root dir is.

### Helper functions

#### `clone-repo REPO_URL CLONE_DIR`
Will clone `REPO_URL` to `CLONE_DIR` if it doesn't exist.

`REPO_URL` can target tags or branches by using hash notation i.e.: `https://github.com/spark/core-common-lib.git#compile-server2`

#### `copy-if-exists FROM TO`
If `FROM` file exists copy it to `TO`.

#### `copy-to-output GLOB`
Copy all files matching `GLOB` to output dir.

#### `find-and-replace-in FROM TO FILE`
Replaces all occurrences of `FROM` to `TO` in `FILE`.

#### `log-size ELF_FILE`
Logs `arm-none-eabi-size` of `ELF_FILE` to `memory-use.log` file in output dir.
