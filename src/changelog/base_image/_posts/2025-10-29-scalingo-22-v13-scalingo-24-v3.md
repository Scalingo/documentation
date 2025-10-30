---
modified_at: 2025-10-29 00:00:00
title: 'Stack scalingo-24 v3, scalingo-22 v13, scalingo-24-minimal v2 and scalingo-22-minimal:v12'
---

These new versions contain the following changes:

* feat: update `/etc/ssl/certs/java/cacerts` to the most recent version
* feat(dbclient-fetcher): add support for `DEBUG`
* Full `apt upgrade` for all stacks

For a comprehensive list of packages installed in the different stacks, please refer to our documentation:

* [scalingo-22]({% post_url platform/internals/stacks/2000-01-01-scalingo-22-stack %}#ubuntu-packages)
* [scalingo-24]({% post_url platform/internals/stacks/2000-01-01-scalingo-24-stack %}#ubuntu-packages)

As always, the Docker images are available on Docker Hub:

* [scalingo-22](https://hub.docker.com/r/scalingo/scalingo-22)
* [scalingo-24](https://hub.docker.com/r/scalingo/scalingo-24)
