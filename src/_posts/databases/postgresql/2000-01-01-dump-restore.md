---
title: How to dump and restore my PostgreSQL database on Scalingo
nav: Dump and Restore
modified_at: 2020-11-13 00:00:00
tags: databases postgresql tunnel
index: 2
---

{% include info_command_line_tool.md %}

There are different ways to dump a distant database and restore the data in your Scalingo database. The first one involves dumping the data on your local workstation and the second one involves doing the same operations from within a Scalingo one-off container (see [application tasks]({% post_url platform/app/2000-01-01-tasks %})).

## Dump and Restore From Your Local Workstation

To dump and restore your database from your local workstation, you need the connection string to connect to your database and a way to [access your database]({% post_url platform/databases/2000-01-01-access %}).

You can get the connection string of your database in your Scalingo application environment. Go to the 'Environment' tab of your dashboard or run the following command:

```bash
$ scalingo --app my-app env | grep POSTGRESQL
```

Your database connection string conforms to the syntax of a generic URI:

```bash
postgresql://<username>:<password>@<host>:<port>/<db>
```

There are two ways to access your database from your local workstation: setting up a tunnel or making your database accessible from anywhere on the Internet.

### Setup the Tunnel

```bash
$ scalingo --app my-app db-tunnel SCALINGO_POSTGRESQL_URL
scalingo --app my-app db-tunnel SCALINGO_POSTGRESQL_URL
Building tunnel to my-db.postgresql.dbs.scalingo.eu:30000
You can access your database on '127.0.0.1:10000'
```

In this situation you need to use a different connection string than the one from your application environment. The `<host>` part is replaced by `127.0.0.1` and the `<port>` is replaced by `10000`.

### Internet Accessibility

In order to make your database reachable from anywhere on the internet, head to your database dashboard. You first need to force TLS connections to your database. Then toggle "Internet Accessibility" to make it reachable from the Internet.

In this situation, the connection string to use is exactly the same as the one from your application environment.

### Dump

The command definition is:

```bash
# If we are using the SSH tunnel endpoint:
$ DATABASE_URL=postgresql://<username>:<password>@127.0.0.1:10000/<db>

$ pg_dump --clean --if-exists --format c --dbname $DATABASE_URL --no-owner --no-privileges --no-comments --exclude-schema 'information_schema' --exclude-schema '^pg_*' --file dump.pgsql
```

### Restore

{% warning %}
  If you use TimescaleDB extension, do not try to restore. You mush ask the support
  to handle it. It can put the base in an undesirable state.
  Go to [TimescaleDB dump and restore page]({% post_url databases/postgresql/timescaledb/2000-01-01-dump-restore %})
  for more details.
{% endwarning %}

The command definition is:

```bash
# We are using the SSH tunnel endpoint:
$ DATABASE_URL=postgresql://<username>:<password>@127.0.0.1:10000/<db>

$ pg_restore --clean --if-exists --no-owner --no-privileges --no-comments --dbname $DATABASE_URL dump.pgsql
```

Alternatively you can use the Adminer instance provided by Scalingo. More information in the [dedicated page]({% post_url platform/databases/2000-01-01-adminer %}).

## Dump and Restore From Scalingo One-off Container

You can dump and restore your database remotely using
[the command-line-tool]({% post_url platform/cli/2000-01-01-start %})
and a one-off container (see [application tasks]({% post_url platform/app/2000-01-01-tasks %})).
The advantage of this method is the network.
From your workstation you don't always have a good bandwidth. From our infrastructure,
data transfers will be way faster.

You need to install the PostgreSQL CLI tools in the one-off before executing `pg_dump` or `pg_restore`:

```bash
$ scalingo --app my-app run bash

[00:00] Scalingo ~ $ dbclient-fetcher psql
```

### Dump & Restore

{% warning %}
  If you use TimescaleDB extension, do not try to restore. You mush ask the support
  to handle it. It can put the base in an undesirable state.
  Go to [TimescaleDB dump and restore page]({% post_url databases/postgresql/timescaledb/2000-01-01-dump-restore %})
  for more details.
{% endwarning %}

```bash
$ scalingo --app my-app run bash

[00:00] Scalingo ~ $ dbclient-fetcher psql
[00:00] Scalingo ~ $ pg_dump --clean --if-exists --format c --no-owner --no-privileges --no-comments --exclude-schema 'information_schema' --exclude-schema '^pg_*' --dbname $DATABASE_URL --file dump.pgsql
...

# Do something with the dump, e.g. send through FTP or to an external server

[00:00] Scalingo ~ $ pg_restore --clean --if-exists --no-owner --no-privileges --no-comments --dbname $DATABASE_URL dump.pgsql
...
[00:00] Scalingo ~ $ exit
exit
```

After exiting the one-off container, the dump will be lost, you've to do something with it in the container.
