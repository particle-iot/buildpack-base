# Buildpack base
This image should be used as a base for other buildpacks.

## Building image

```bash
$ git clone git@github.com:suda/buildpack-base.git
$ cd buildpack-base
$ docker build -t particle/buildpack-base .
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
