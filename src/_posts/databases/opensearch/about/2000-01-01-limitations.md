---
title: Limitations
nav: Limitations
modified_at: 2025-05-22 12:00:00
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

- OpenSearch® plugins can't be added, modified, nor removed.

- Because the `opensearch-security` plugin is not exposed, some features and
  plugins may behave differently than expected. Please refer to the official
  documentation for further help.

- Remote and cross-cluster replication features are not supported, since this
  would require custom configurations at the instances level.

- The reserved user provided by Scalingo has a limited access to the
  OpenSearch® APIs. These APIs are **forbidden**:
  - [Security APIs][opensearch-api-security]
  - [Snapshot APIs][opensearch-api-snapshot]


## Timeouts

Scalingo for OpenSearch addons have, depending on the plan, one or two HAProxy
instances as entry point. These HAProxy instances have a few timeouts
configured which may impact your application, especially when reusing
connections.

| Context                                                  | Timeout   |
| -------------------------------------------------------- | --------- |
| Client is inactive                                       | 1 minute  |
| Server is inactive                                       | 2 minutes |
| Maximum allowed time to wait for a complete HTTP request | 5 seconds |


[opensearch-api-security]: https://docs.opensearch.org/docs/2.19/api-reference/security-apis/
[opensearch-api-snapshot]: https://docs.opensearch.org/docs/2.19/api-reference/snapshots/index/

[db-dashboard]: {% post_url databases/about/2000-01-01-database-dashboard %}
