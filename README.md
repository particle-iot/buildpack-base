# Buildpack base
This image should be used as a base for other buildpacks.

## Building image

```bash
$ export BUILDPACK_IMAGE=base
$ git clone "git@github.com:suda/buildpack-${BUILDPACK_IMAGE}.git"
$ cd buildpack-$BUILDPACK_IMAGE
$ docker build -t particle/buildpack-$BUILDPACK_IMAGE .
```


## Inheriting image

```Dockerfile
FROM particle/buildpack-base

# ...

ADD . /
```

### Using hooks

When creating your own buildpack you can create your own hooks in `/hooks` directory:

* `post-env` - used to set up environment variables
* `pre-build` - prepare workspace before build
* `build` - invoke build command
* `post-build` - clean up after build
