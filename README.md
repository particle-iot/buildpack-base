# Buildpack base
This image should be used only as a base for other buildpacks.

## Building image

```bash
$ export BUILDPACK_IMAGE=base
$ git clone "git@github.com:spark/buildpack-${BUILDPACK_IMAGE}.git"
$ cd buildpack-$BUILDPACK_IMAGE
$ docker build -t particle/buildpack-$BUILDPACK_IMAGE .
```

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
