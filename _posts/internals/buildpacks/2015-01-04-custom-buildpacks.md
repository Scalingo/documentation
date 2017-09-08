---
title: Use a custom buildpack
modified_at: 2016-01-28 00:00:00
category: buildpacks
tags: custom buildpacks build image
order: 1
---

If you need to deploy a technology which is not supported by Scalingo,
you can used an open-source buildpack or a buildpack you have developed.

To achieve this, you need to define the following environment variable in
the environment of the concerned application: `BUILDPACK_URL`.

Example:

```text
BUILDPACK_URL=https://github.com/cloudfoundry/java-buildpack
```

Then during the deployment, you'll be able to see:

```text
<-- Start deployment of myapp -->
-----> Cloning custom buildpack: 'https://github.com/cloudfoundry/java-buildpack'

-- SNIP --
```

## Build a custom buildpack

Our execution stack is public and can be found as a docker image on the __Docker Hub__
Its name is [scalingo/builder:latest](https://hub.docker.com/u/scalingo/builder/). The base
image is based on Ubuntu 14.04, so you'll find every tool from the `ubuntu:14.04` docker image.

```bash
docker pull scalingo/builder
docker run --interactive --tty -v /path/to/custom-buildpack:/buildpack scalingo/builder:latest bash
```

Then if you need to build third-party binaries, you'll be assured that they will work
on our platform.
