---
title: Scalingo Builder - Our base Docker image
nav: Base Docker Image
modified_at: 2016-08-05 00:00:00
tags: docker image builder buildpack
index: 5
---

Every application deployed on Scalingo are built over our base Docker image.
Internally we name it Scalingo Builder. This image is open source and can be
found on the docker hub under the name
[scalingo/builder](https://hub.docker.com/r/scalingo/builder/). The builder
image is used for all applications hosted on the platform, as a result, it is a
*generic image* which is *unspecialized*. That's why it's based on a stable
**Ubuntu LTS** environment (currently 14.04 LTS).

## The build process

Each time any user deploys a new release of their applications, a new Docker
image is created. A new layer is added on top of the `scalingo/builder` base
image. It's built using the buildpack and contains the application code and all
its dependencies. When the build is done, the resulting Docker image is sent to
our private repository and our orchestrator will use it subsequently to actually
run the application in our infrastructure.

The **maximum build time is 30 minutes**. After that duration the build will be canceled by the platform.

## Installed libraries

We've installed different libraries and softwares which are commonly used in
the build process or used by human when running [one-off
container]({% post_url platform/app/2000-01-01-tasks %}).

You'll find:

* Build essentials utility (GCC, make, autotools, ...)
* Curl, git, telnet, ssh, ssh-client, openssl, dnsutils, sqlite
* Node.js, Ruby, Perl, Python, Java
* ImageMagick
* MySQL, PostgreSQL MongoDB, Redis clients and development libraries

Not all applications will use these libraries but we've considered that
managing a set of builder images instead of only one isn't worth it.

The advantage of using a single builder image is that **once it has been
fetched on a hosting node, we're done**. Even if we sacrifice a few megabytes
of disk space, when a new container starts, only the application layer is
fetched and nothing else.

Of course you can inspect this base image: it's a completely standard Docker
image after all! You can use something like:

```console
$ docker pull scalingo/builder
```

## Timezone

The timezone configured inside our base image is UTC±00:00.
