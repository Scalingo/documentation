---
title: Deployment Environment
modified_at: 2016-04-26 00:00:00
category: app
tags: app build deployment configuration environment
---

When your application is deployed, the build container is containing the environment
variables defined in the application configuration and the platform is also injecting
the following variable:

* `$SOURCE_VERSION`: SHA of the currently deployed Git commit.
