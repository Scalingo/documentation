---
title: How to dump and restore my PostgreSQL database on Scalingo
modified_at: 2016-01-08 18:04:00
category: databases
tags: databases postgresql tunnel
index: 3
permalink: /databases/postgresql/dump-restore/
---

{% include info_command_line_tool.md %}

There's two ways to dump a distant database and restore the data in your Scalingo database. The first one involves dumping the data on your local workstation and the second one involves doing the same operations from within a Scalingo one-off container (see [application tasks]({% post_url app/2014-10-02-tasks %})).

## Dump and Restore from your local workstation

You can dump and restore your database from your local workstation using [Scalingo CLI]({% post_url cli/2015-09-18-command-line-tool %}) to [create a tunnel]({% post_url databases/2014-11-24-tunnel %}) to your database:

A PostgreSQL URL is usually formatted like: <br>
`postgresql://<username>:<password>@<host>:<port>/<db>`

To get the URL of your database, go to the 'Environment' part of your dashboard or
run the following command:

```bash
$ scalingo -a myapp env | grep POSTGRESQL
```

If your remote database URL is:

```bash
postgresql://user:pass@my-db.postgresql.dbs.com:30000/my-db
```

### Setup the tunnel

```bash
$ scalingo -a myapp db-tunnel SCALINGO_POSTGRESQL_URL
scalingo -a myapp db-tunnel SCALINGO_POSTGRESQL_URL
Building tunnel to my-db.postgresql.dbs.scalingo.eu:30000
You can access your database on '127.0.0.1:10000'
```

### Dump

The command definition is:

```bash
$ PGPASSWORD=<password> pg_dump --clean --format c --host <host> --port <port> --username <username> --no-owner --no-privileges --exclude-schema 'information_schema' --exclude-schema '^pg_*' --dbname <db> --file dump.pgsql
```

If your PostgreSQL version is 9.4 or higher, you should consider also using the `--if-exists` flag.

Applied to our example:

```bash
$ PGPASSWORD=pass pg_dump --clean --if-exists --format c --host 127.0.0.1 --port 10000 --username my-db --no-owner --no-privileges --exclude-schema 'information_schema' --exclude-schema '^pg_*' --dbname my-db --file dump.pgsql
```

As you can see we're using the host and port provided by the tunnel, not those of the URL.

### Restore

The command definition is:

```bash
$ PGPASSWORD=<password> pg_restore --clean --host <host> --port <port> --username <username> --no-owner --no-privileges --dbname <db> dump.pgsql
```

If your PostgreSQL version is 9.4 or higher, you should consider also using the `--if-exists` flag.

With our example:

```bash
$ PGPASSWORD=pass pg_restore --clean --host 127.0.0.1 --port 10000 --username my-db --no-owner --no-privileges --dbname my-db dump.pgsql
```

## Dump and Restore from Scalingo one-off container

You can dump and restore your database remotely using
[the command-line-tool]({% post_url cli/2015-09-18-command-line-tool %})
and a one-off container (see [application tasks]({% post_url app/2014-10-02-tasks %})).
The advantage of this method is the network.
From your workstation you don’t always have a good bandwidth. From our infrastructure,
data transfers will be way faster.

### Dump & Restore

```bash
$ scalingo -a myapp run bash

[00:00] Scalingo ~ $ PGPASSWORD=pass pg_dump --clean --if-exists --format c --host my-db.postgresql.dbs.scalingo.com --port 30000 --username user --no-owner --no-privileges --exclude-schema 'information_schema' --exclude-schema '^pg_*' --dbname my-db --file dump.pgsql
...

# Do something with the dump, i.e.e send through FTP or to an external server

[00:00] Scalingo ~ $ PGPASSWORD=pass pg_restore --clean --if-exists --host my-db.postgresql.dbs.scalingo.com --port 30000 --username user --no-owner --no-privileges --dbname my-db dump.pgsql
...
[00:00] Scalingo ~ $ exit
exit
```

After exiting the one-off container, the dump will be lost, you've to do something with it in the container.
