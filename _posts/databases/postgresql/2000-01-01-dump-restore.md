---
title: How to dump and restore my PostgreSQL database on Scalingo
nav: Dump and Restore
modified_at: 2020-03-31 18:04:00
tags: databases postgresql tunnel
index: 2
---

{% include info_command_line_tool.md %}

There are different ways to dump a distant database and restore the data in your Scalingo database. The first one involves dumping the data on your local workstation and the second one involves doing the same operations from within a Scalingo one-off container (see [application tasks]({% post_url platform/app/2000-01-01-tasks %})).

## Dump and Restore from your local workstation

To dump and restore your database from your local workstation, you need a way
to [access your database]({% post_url platform/databases/2000-01-01-access %}).

A PostgreSQL URL is usually formatted like:

`postgresql://<username>:<password>@<host>:<port>/<db>`

To get the URL of your database, go to the 'Environment' part of your dashboard or
run the following command:

```bash
$ scalingo --app my-app env | grep POSTGRESQL
```

If your remote database URL is:

```bash
postgresql://user:pass@my-db.postgresql.dbs.com:30000/my-db
```

### Setup the Tunnel

```bash
$ scalingo --app my-app db-tunnel SCALINGO_POSTGRESQL_URL
scalingo --app my-app db-tunnel SCALINGO_POSTGRESQL_URL
Building tunnel to my-db.postgresql.dbs.scalingo.eu:30000
You can access your database on '127.0.0.1:10000'
```

### Dump

The command definition is:

```bash
# We are using the SSH tunnel endpoint:
$ DATABASE_URL=postgresql://<username>:<password>@127.0.0.1:10000/<db>

$ pg_dump --clean --if-exists --format c --dbname $DATABASE_URL --no-owner --no-privileges --exclude-schema 'information_schema' --exclude-schema '^pg_*' --file dump.pgsql
```

With PostgreSQL version prior to 9.4 the `--if-exists` flag may not exist.

As you can see we use the host and port provided by the tunnel, not those of the URL.

### Restore

The command definition is:

```bash
# We are using the SSH tunnel endpoint:
$ DATABASE_URL=postgresql://<username>:<password>@127.0.0.1:10000/<db>

$ pg_restore --clean --if-exists --no-owner --no-privileges --dbname $DATABASE_URL dump.pgsql
```

With PostgreSQL version prior to 9.4 the `--if-exists` flag may not exist.

Alternatively you can use the Adminer instance provided by Scalingo. Choose the
one hosted in the region where your database is hosted.

- `osc-fr1`: [https://adminer.osc-fr1.scalingo.com](https://adminer.osc-fr1.scalingo.com).
- `osc-secnum-fr1`: [https://adminer.osc-secnum-fr1.scalingo.com](https://adminer.osc-secnum-fr1.scalingo.com).
- `agora-fr1`: [https://adminer.agora-fr1.scalingo.com](https://adminer.agora-fr1.scalingo.com).


## Dump and Restore from Scalingo one-off container

You can dump and restore your database remotely using
[the command-line-tool]({% post_url platform/cli/2000-01-01-start %})
and a one-off container (see [application tasks]({% post_url platform/app/2000-01-01-tasks %})).
The advantage of this method is the network.
From your workstation you don't always have a good bandwidth. From our infrastructure,
data transfers will be way faster.

### Dump & Restore

```bash
$ scalingo --app my-app run bash

[00:00] Scalingo ~ $ dbclient-fetcher psql
[00:00] Scalingo ~ $ pg_dump --clean --if-exists --format c --no-owner --no-privileges --exclude-schema 'information_schema' --exclude-schema '^pg_*' --dbname $DATABASE_URL --file dump.pgsql
...

# Do something with the dump, i.e.e send through FTP or to an external server

[00:00] Scalingo ~ $ pg_restore --clean --if-exists --no-owner --no-privileges --dbname $DATABASE_URL dump.pgsql
...
[00:00] Scalingo ~ $ exit
exit
```

After exiting the one-off container, the dump will be lost, you've to do something with it in the container.
