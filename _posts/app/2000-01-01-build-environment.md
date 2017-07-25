---
title: Deployment Environment
modified_at: 2016-04-26 00:00:00
category: environment
tags: build deployment configuration environment app
permalink: /your-application/environment/build-environment/
---

When your application is deployed, the build container is containing the environment
variables defined in the application configuration and the platform is also injecting
the following variable:

* `$SOURCE_VERSION`: SHA of the currently deployed GIT commit.
