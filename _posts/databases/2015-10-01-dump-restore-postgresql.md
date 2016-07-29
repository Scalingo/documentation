---
title: How to dump and restore my PostgreSQL database on Scalingo
modified_at: 2016-01-08 18:04:00
category: databases
tags: databases postgresql tunnel
index: 3
permalink: /databases/postgresql/dump-restore/
---

{% include info_command_line_tool.md %}

There's two ways to dump a distant database and restore the data in your Scalingo database. The first one involves dumping the data on your local workstation and the second one involves doing the same operations from within a Scalingo one-off container (see [application tasks]({% post_url 2014-10-02-tasks %})).

## Dump and Restore from your local workstation

You can dump and restore your database from your local workstation using [Scalingo CLI]({% post_url 2015-09-18-command-line-tool %}) to [create a tunnel]({% post_url 2014-11-24-tunnel %}) to your database:

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
$ PGPASSWORD=<password> pg_dump -O -n public -U <username> -h <host> -p <port> <db> > dump.sql
```

Applied to our example:

```bash
$ PGPASSWORD=pass pg_dump -O -n public -U my-db -h 127.0.0.1 -p 10000 my-db > dump.sql
```

As you can see we're using the host and port provided by the tunnel, not those of the URL.

### Restore

The command definition is:

```bash
$ PGPASSWORD=<password> psql -U <username> -h <host> -p <port> -d <db> < dump.sql
```

With our example:

```bash
$ PGPASSWORD=pass psql -U my-db -h 127.0.0.1 -p 10000 -d my-db < dump.sql
```

## Dump and Restore from Scalingo one-off container

You can dump and restore your database remotely using
[the command-line-tool]({% post_url 2015-09-18-command-line-tool %})
and a one-off container (see [application tasks]({% post_url 2014-10-02-tasks %})).
The advantage of this method is the network.
From your workstation you don’t always have a good bandwidth. From our infrastructure,
data transfers will be way faster.

### Dump & Restore

```bash
$ scalingo -a myapp run bash

[00:00] Scalingo ~ $ PGPASSWORD=pass pg_dump -U user -h my-db.postgresql.dbs.scalingo.com -P 30000 my-db > /tmp/dump.sql
...

# Do something with the dump, i.e.e send through FTP or to an external server

[00:00] Scalingo ~ $ PGPASSWORD=pass psql -U my-db -h my-db.postgresql.dbs.scalingo.com -P 30000 my-db < /tmp/dump.sql
...
[00:00] Scalingo ~ $ exit
exit
```

After exiting the one-off container, the dump will be lost, you've to do something with it in the container.
