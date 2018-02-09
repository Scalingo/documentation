---
title: Runtime Environment
modified_at: 2017-09-07 00:00:00
category: app
tags: app runtime configuration environment
---

When an application container is started, the platform is using the environment
variables defined in the application configuration but is also injecting a set of
environment variables in its environment. In the case of `web` containers, an
additional variable `$PORT` is defined.

* `$PORT`: Port number your server has to bind on.
* `$CONTAINER`: Type and index of the container, `web-1` or `worker-1` for instance
* `$CONTAINER_VERSION`: Version of the container started, usually the Git commit SHA.
* `$CONTAINER_SIZE`: Name of the size of the container `M`, `L`, `XL` etc.
* `$CONTAINER_MEMORY`: Available RAM memory of the container (in bytes)
* `$APP`: Name of the application deployed
