---
title: Understanding Database Endpoints
nav: Endpoints
modified_at: 2026-06-16 00:00:00
tags: databases postgresql dedicated endpoints
index: 4
---

Database endpoints are the different ways to access the database through the network.

## Listing Database Endpoints with CLI

Because Dedicated Resources databases are not yet generally available,
you must first enable preview features to use the related CLI commands:

```sh
export SCALINGO_PREVIEW_FEATURES=true
```

Run the following command to list your database endpoints:

```sh
scalingo --database <db-id> database-endpoints
┌──────────────────────────┬────────────────────┬───────────────────────────────────────────────────────┬───────┐
│            ID            │        TYPE        │                       HOSTNAME                        │ PORT  │
├──────────────────────────┼────────────────────┼───────────────────────────────────────────────────────┼───────┤
│ 6a316183d0f1f10ecbcca123 │ public-rw          │ mydb-1234.postgresql.osc-fr1.scalingo-dbs.com         │ 30092 │
│ 6a316183d0f1f10ecbcca456 │ private-peering-rw │ mydb-1234.peering.postgresql.osc-fr1.scalingo-dbs.com │ 30092 │
└──────────────────────────┴────────────────────┴───────────────────────────────────────────────────────┴───────┘
```

## Types of Database Endpoints


### Public RW

Public RW (`public-rw`) stands for public read/write. Its hostname resolves to
the public IP configured for the database. It will always route requests to the
servers able to receive read and writes operations on the database.

In case of a cluster failover (maintenance/incident), the gateway instance
targeted by the endpoint will change transparently, the IP resolved by the
hostname will not change.

### Private Peering RW

Private Peering RW (`private-peering-rw`) standard for private peering
read/write. Its hostname resolved to the private IP address on the database
gateway instance which is consider as primary at a given time.

This couple hostname:port will only be reachable from networks linked with a
Net Peering to the database.

In case of a cluster failover (maintenance/incident), the hostname DNS
resolution will be automatically updated to resolve on an available gateway
instance.

## Build a Connection String from an endpoint

When you know which endpoint you will use to access your database, you can
configure your applications using the following scheme:

```text
postgresql://<username>:<password>@<endpoint-hostname>:<endpoint-port>/<database-name>?<options>
```

The user and password can be the ones created by default, or after having created a [custom user][managing-users]

[managing-users]: {% post_url databases/postgresql/dedicated-resources/guides/2000-01-01-managing-users %}
