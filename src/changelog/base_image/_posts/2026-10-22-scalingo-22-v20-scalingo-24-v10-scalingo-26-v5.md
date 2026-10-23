---
modified_at: 2026-10-22 00:00:00
title: 'Stack scalingo-26 v5, scalingo-24 v10, scalingo-22 v20, scalingo-26-minimal v6, scalingo-24-minimal v9 and scalingo-22-minimal v19'
---

These new versions contain the following changes:

* Update the CA certificate store to remove trust paths affected by the eMudhra intermediate CA compromise; see [our security bulletin]({% post_url security/bulletins/2026-10-21-SSB-2026-006 %})
* feat(jks): update to the most recent version
* Full `apt upgrade`

For a comprehensive list of packages installed in the different stacks, please refer to our documentation:

* [scalingo-22]({% post_url platform/internals/stacks/2000-01-01-scalingo-22-stack %}#ubuntu-packages)
* [scalingo-24]({% post_url platform/internals/stacks/2000-01-01-scalingo-24-stack %}#ubuntu-packages)
* [scalingo-26]({% post_url platform/internals/stacks/2000-01-01-scalingo-26-stack %}#ubuntu-packages)

As always, the Docker images are available on Docker Hub:

* [scalingo-22](https://hub.docker.com/r/scalingo/scalingo-22)
* [scalingo-22-minimal](https://hub.docker.com/r/scalingo/scalingo-22-minimal)
* [scalingo-24](https://hub.docker.com/r/scalingo/scalingo-24)
* [scalingo-24-minimal](https://hub.docker.com/r/scalingo/scalingo-24-minimal)
* [scalingo-26](https://hub.docker.com/r/scalingo/scalingo-26)
* [scalingo-26-minimal](https://hub.docker.com/r/scalingo/scalingo-26-minimal)
