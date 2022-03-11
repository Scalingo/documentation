---
title: How to dump and restore my MongoDB database on Scalingo
nav: Dump and Restore
modified_at: 2022-03-11 00:00:00
tags: databases mongodb mongo tunnel dump restore
index: 2
---

{% include info_command_line_tool.md %}

There are two ways to dump a distant database and restore the data in your
Scalingo database.
The first one involves dumping the data on your local workstation and the second
one involves doing the same operations from within a Scalingo one-off container
(see [application tasks]({% post_url platform/app/2000-01-01-tasks %})).

## Dump and Restore From Your Local Workstation


To dump and restore your database from your local workstation, you need the
connection string to connect to your database and a way to
[access your database]({% post_url platform/databases/2000-01-01-access %}).

You can get the connection string of your database in your Scalingo
application environment. Go to the `Environment` page of your
dashboard or run the following command:

```bash
$ scalingo --app my-app env | grep MONGO_URL
```

Your database connection string conforms to the syntax of a generic URI:

```bash
mongodb://<username>:<password>@<host>:<port>/<db>
```

There are two ways to access your database from your local workstation:
- Setting up a tunnel
- Making your database accessible from anywhere on the Internet

### Setup the Tunnel

```bash
$ scalingo --app my-app db-tunnel SCALINGO_MONGO_URL

Building tunnel to my-db.mongo.dbs.scalingo.com:30000
You can access your database on:
127.0.0.1:10000
```

In this situation you need to use a different connection string than the one
from your application environment.
The `<host>` part is replaced by `127.0.0.1` and the `<port>` is replaced by
`10000`.

{% warning %}
If your database uses Business plan, you have a replica set.
It is not possible to access a replica set using the DB tunnel.
You should enable [Internet Accessibility]({% post_url platform/databases/2000-01-01-access %}#direct-access)
to your database. The reason is that the DB tunnel is designed to connect to
only one node.
On the other hand, MongoDB clients require to reach all the instances
of the replica set to work.
{% endwarning %}

### Internet Accessibility

In order to make your database reachable from anywhere on the internet, head to
your database dashboard. You first need to force TLS connections to your
database. Then toggle `Internet Accessibility` to make it reachable from the
Internet.

In this situation, the connection string to use is exactly the same as the one
from your application environment.

### Dump

This command will create a `dump` directory in your current working directory.

```bash
$ mongodump --username <username> --password <password> --host <host> --port <port> --db <db>
```

You can also use the URI format instead of splitting the URI in parts:
```bash
$ mongodump --uri $SCALINGO_MONGO_URL
```

#### Common Error

If you have this error when executing the `mongodump` command:
```bash
error reading collection: Failed to parse: { find: "<collection name>", skip: 0,
snapshot: true, $readPreference: { mode: "secondaryPreferred" }, $db: "<db>" }.
Unrecognized field 'snapshot'.
```

You can use `--forceTableScan` option to resolve the issue.

### Restore

This command will restore a `dump` into your database.

```bash
$ mongorestore --username <username> --password <password> --host <host> --port <port> --db <db> <dump directory OR bson file>
```

You can also use the URI format instead of splitting the URI in parts:
```bash
$ mongorestore --uri $SCALINGO_MONGO_URL --db <db> <dump directory OR bson file>
```

{% warning %}
  For this command you need to specify the database name with `--db`.
  It will not work to have the database name in the `--uri` option.
{% endwarning %}

In addition you may use the [--drop
option](https://docs.mongodb.com/v3.4/reference/program/mongorestore/#cmdoption-mongorestore-drop)
to delete the existing data in the database.

## Dump and Restore From Scalingo One-off Container

You can dump and restore your database remotely using
[the command-line-tool]({% post_url platform/cli/2000-01-01-start %})
and a one-off container
(see [application tasks]({% post_url platform/app/2000-01-01-tasks %})).

The advantage of this method is the network.
From your workstation you don't always have a good bandwidth.
From our infrastructure, data transfers will be way faster.

You need to install the MongoDB CLI tools in the one-off before executing
`mongodump` or `mongorestore`:

```bash
$ scalingo --app my-app run bash

[00:00] Scalingo ~ $ dbclient-fetcher mongo
```

### Dump

```bash
$ scalingo --app my-app run bash

[00:00] Scalingo ~ $ dbclient-fetcher mongo
[00:00] Scalingo ~ $ mongodump --username user --password pass --host my-db.mongo.dbs.scalingo.com --port 30000 --db my-db

# Do something with the dump, i.e send it with FTP or to an external server
```

### Restore

```bash
$ scalingo --app my-app run bash

[00:00] Scalingo ~ $ dbclient-fetcher mongo

# Get a dump from a remote place, with 'curl' or 'ftp'

[00:00] Scalingo ~ $ mongorestore --uri $SCALINGO_MONGO_URL --db my-db dump/my-db
```

After exiting the one-off container, the dump will be lost, you've to do
something with it in the container.
