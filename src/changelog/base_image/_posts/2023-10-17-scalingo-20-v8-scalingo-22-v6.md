---
modified_at: 2023-10-17 18:00:00
title: 'Stack scalingo-22 v6, scalingo-20 v8, scalingo-22-minimal:v5 and scalingo-20-minimal:v8'
---

This new versions contain the following changes:

* Full `apt-get upgrade` for all stacks.
* Add `libyaml-dev` to `scalingo-20` and `scalingo-22`.

For a comprehensive list of packages installed in each stack, please refer to
our documentation:

* [scalingo-20]({% post_url platform/internals/stacks/2000-01-01-scalingo-20-stack %}#ubuntu-packages)
* [scalingo-22]({% post_url platform/internals/stacks/2000-01-01-scalingo-22-stack %}#ubuntu-packages)

As always, the Docker images are available on Docker Hub:

* [scalingo-20](https://hub.docker.com/r/scalingo/scalingo-20)
* [scalingo-22](https://hub.docker.com/r/scalingo/scalingo-22)
