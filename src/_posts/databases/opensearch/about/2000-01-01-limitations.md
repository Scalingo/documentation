---
title: Limitations
nav: Limitations
modified_at: 2025-05-05 12:00:00
tags: database opensearch addon
index: 4
---


As Scalingo for OpenSearch® is a fully managed service, we enforce certain
operational limits and usage policies to maintain reliability and security for
all users.


## Affecting User Management

- Because the `opensearch-security` plugin is not exposed, Scalingo for
  OpenSearch® currently only supports a single reserved user.

- As a consequence, creating additional users is not yet possible.


## Affecting Backups and Restorations

- Backups are fully managed by Scalingo. While you can create and restore
  backups, downloading them is not possible.

- Consequently, restoring a Scheduled or Manual backup is only available from
  the [database dashboard][db-dashboard].


## Affecting Features

- Because the `opensearch-security` plugin is not exposed, some features and
  plugins may behave differently than expected. Please refer to the official
  documentation for further help.

- Remote and cross-cluster replication features are not supported, since this
  would require custom configurations at the instances level.

- The reserved user provided by Scalingo has a limited access to the
  OpenSearch® APIs. These APIs are **forbidden**:
  - [Security APIs][opensearch-api-security]
  - [Snapshot APIs][opensearch-api-snapshot]



[opensearch-api-security]: https://docs.opensearch.org/docs/latest/api-reference/security-apis/
[opensearch-api-snapshot]: https://docs.opensearch.org/docs/latest/api-reference/snapshots/index/

[db-dashboard]: {% post_url databases/about/2000-01-01-database-dashboard %}
