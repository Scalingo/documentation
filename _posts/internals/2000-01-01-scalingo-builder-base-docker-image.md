---
title: Scalingo Builder - Our base Docker image
modified_at: 2016-08-05 00:00:00
category: internals
tags: docker, image, builder, buildpack
---

Every application deployed on Scalingo are built over our base Docker image. Internally we name it Scalingo Builder. This
image is open source and can be found on the docker hub under the name [scalingo/builder](https://hub.docker.com/r/scalingo/builder/). The builder image is used for all applications hosted on the platform, as a result, it is a *generic image* which is *unspecialized*. That's why it's based on a stable
**Ubuntu LTS** environment (currently 14.04 LTS).

The build process
-----------------

Each time any user deploys a new release of their application, a new container is created based on the `scalingo/builder` image. The build of the app and its dependencies are done via a single script executing the buildpack(s). Once done,
it generates a unique layer added to the builder image. So when we send it to the repository, only a single layer is sent.

Installed libraries
-----------------

We've installed different libraries and softwares which are commonly used in the buid process or used by human when running
[one off container](http://doc.scalingo.com/app/tasks.html).

You'll find:

* Build essentials utility (GCC, make, autotools, ...)
* Curl, git, telnet, ssh, ssh-client, openssl, dnsutils, sqlite
* NodeJs, Ruby, Perl, Python, Java
* ImageMagick
* Mysql, Postgresql MongoDB, Redis clients and development libraries

Not all application will use these libraries but we've considered that managing a set of builder image instead of only one isn't worth it.

The advantage of using a single builder image is that **once it has been fetched on a hosting node, we're done**. Even if we we sacrifice a few megabytes of disk space, when a new container starts, only the application layer is fetched and nothing else.
