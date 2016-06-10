# Buildpack base

[![Build Status](https://travis-ci.org/spark/buildpack-base.svg)](https://travis-ci.org/spark/buildpack-base) [![](https://imagelayers.io/badge/particle/buildpack-base:latest.svg)](https://imagelayers.io/?images=particle/buildpack-base:latest 'Get your own badge on imagelayers.io')

Buildpacks inherit and extend other images to separate common flow and logic in OOP manner.
This image provides [main flow/protocol](#flow) and some [helper functions](#helper-functions) that can be used by other images by [inheriting it](#inheriting-image).

| |
|---|
|  [Particle firmware](https://github.com/spark/firmware-buildpack-builder)  |
| [HAL](https://github.com/spark/buildpack-hal) / [Legacy](https://github.com/spark/buildpack-0.3.x)   |
| **Base (you are here)** |


## Building image

```bash
$ export BUILDPACK_IMAGE=base
$ git clone "git@github.com:spark/buildpack-${BUILDPACK_IMAGE}.git"
$ cd buildpack-$BUILDPACK_IMAGE
$ docker build -t particle/buildpack-$BUILDPACK_IMAGE .
```

## Run script flow

Image entrypoint is [/bin/run](bin/run). It will:

1. Load helper functions from [lib directory](lib/helpers)
2. Init environment variables with [defaults](bin/setup-env)
3. Setup logging
4. Copy input files to workspace directory
5. Execute build (by calling `/bin/build` script)
6. Cleanup [output](#normalization-of-paths-and-filenames)

## Inheriting image

```Dockerfile
FROM particle/buildpack-base

# ...

COPY foo /foo
```

### Defined volumes

When running container use `-v` argument to specify local dirs which will be mapped to those volumes.

* `/input` - should contain all project files
* `/output` - after build will contain logs and build artifacts
* `/cache` - temp directory to store intermediate files
* `/log` - directory containing run logs
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

### Environment variables

#### `INPUT_FROM_STDIN`
Setting it to `true` will wait on `STDIN` for a tar gzipped file which will be extracted into `/input`.

#### `ARCHIVE_OUTPUT`
Setting it to `true` will tar gzip `/output` directory into `/output.tar.gz` archive inside of container.

Both variables are used when buildpack is [run by Dray](https://github.com/CenturyLinkLabs/dray#custom-file).

## Running tests

Buildpacks can define tests by overriding `/test` directory with [BATS tests](https://github.com/sstephenson/bats). The tests should:

1. Propagate `/input` with test data
2. Run `/bin/run`
3. Inspect `/output` and assert when incorrect

Before each BATS file, the `/input`, `/workspace` and `/output` will be cleared.
BATS can use different languages to do the actual tests (i.e. run `mocha`).

Running tests itself is done by running container without mounted volumes and overriding `CMD`:

```bash
$ docker run --rm \
  particle/buildpack-foo \
  /bin/run-tests
```

## Building, running in tests and pushing tagged images in Travis CI

Use following `.travis.yml`:

```yaml
sudo: required
services:
  - docker
install:
  - docker login --email=$DOCKER_HUB_EMAIL --username=$DOCKER_HUB_USERNAME --password=$DOCKER_HUB_PASSWORD

before_script:
  - docker build -t $DOCKER_IMAGE_NAME .

script:
  - docker run --rm $DOCKER_IMAGE_NAME /bin/run-tests

after_success:
  - if [ ! -z "$TRAVIS_TAG" ]; then docker tag $DOCKER_IMAGE_NAME:latest $DOCKER_IMAGE_NAME:$TRAVIS_TAG; fi && docker push $DOCKER_IMAGE_NAME

env:
  - DOCKER_IMAGE_NAME=particle/foo
```
