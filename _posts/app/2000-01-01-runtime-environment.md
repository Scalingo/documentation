---
title: Runtime Environment
modified_at: 2016-04-26 00:00:00
category: config
order: 9
tags: runtime configuration environment app
---

When an application container is started, the platform is using the environment
variables defined in the application configuration but is also injecting a set of
environment variables in its environment. In the case of `web` containers, an
additional variable `$PORT` is defined.

* `$PORT`: Port number your server has to bind on.
* `$CONTAINER`: Type and index of the container, `web-1` or `worker-1` for instance
* `$CONTAINER_VERSION`: Version of the container started, usually the GIT commit SHA.
* `$APP`: Name of the application deployed
