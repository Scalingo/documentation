---
index: 5
title: Customizing
modified_at: 2026-02-05 12:00:00
---


## Environment

Keycloak supports [many environment variables][keycloak-config].

Moreover, the buildpack makes use of the following environment variables. They
can be leveraged to customize your deployment:

- `KEYCLOAK_VERSION`\\
  Allows to specify the version of Keycloak to deploy.

- `KEYCLOAK_PRIVATE_DOMAIN_NAME`\\
  When [deploying behind a reverse proxy][deploy-behind-reverse-proxy], allows
  the reverse proxy to know where the requests must be passed.


[keycloak-config]: https://www.keycloak.org/server/all-config?f=config

[deploy-behind-reverse-proxy]: {% post_url platform/getting-started/getting-started-with-keycloak/2000-01-01-deploying-behind-a-reverse-proxy %}

