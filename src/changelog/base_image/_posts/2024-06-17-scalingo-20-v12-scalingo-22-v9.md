---
modified_at: 2024-06-17 11:00:00
title: 'Stack scalingo-22 v9, scalingo-20 v12, scalingo-22-minimal:v8 and scalingo-20-minimal:v11'
---

This new versions contain the following changes:

* Full `apt-get upgrade` for all stacks.
* Security: Change default `umask` to `0077`
* Configuration: Ability to change local thanks to the [locale buildpack](https://github.com/Scalingo/locale-buildpack)
* Executables: Removal of pre-installed `sass` executable which is unmaintained and could lead to a security risk. Please install `sass` from your app dependency manager.

For a comprehensive list of packages installed in the different stacks, please refer to our documentation:

* [scalingo-20]({% post_url platform/internals/stacks/2000-01-01-scalingo-20-stack %}#ubuntu-packages)
* [scalingo-22]({% post_url platform/internals/stacks/2000-01-01-scalingo-22-stack %}#ubuntu-packages)

As always, the Docker images are available on Docker Hub:

* [scalingo-20](https://hub.docker.com/r/scalingo/scalingo-20)
* [scalingo-22](https://hub.docker.com/r/scalingo/scalingo-22)
