---
title: Use a custom buildpack
date: 04/01/2015
Ltag: custom, buildpacks, build, image
category: internals
---

# Use of a custom buildpack

If you need to deploy a technology which is not supported by Scalingo,
you can used an open-source buildpack or a buildpack you have developed.

To achieve this, you need to define the following environment variable in
the environment of the concerned application: `BUILDPACK_URL`.

Example:

```
BUILDPACK_URL=https://github.com/cloudfoundry/java-buildpack
```

Then during the deployment, you'll be able to see:

```
<-- Start deployment of myapp -->
-----> Cloning custom buildpack: 'https://github.com/cloudfoundry/java-buildpack'

-- SNIP --
```

# Build a custom buildpack

Our execution stack is public and can be found as a docker image on the __Docker Hub__
Its name is [appsdeck/builder:latest](https://registry.hub.docker.com/u/appsdeck/builder/)

```
docker pull appsdeck/builder
docker run -v ./custom-buildpack:/buildpack appsdeck/builder:latest bash
```

Then if you need to build third-party binaries, you'll be assured that they will work
on our platform.
