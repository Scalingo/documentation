---
title: How to dump and restore my MongoDB database on Scalingo
modified_at: 2016-03-23 14:22:00
tags: databases mongodb tunnel
index: 2
---

{% include info_command_line_tool.md %}

There are two ways to dump a distant database and restore the data in your Scalingo database. The first one involves dumping the data on your local workstation and the second one involves doing the same operations from within a Scalingo one-off container (see [application tasks]({% post_url platform/app/2000-01-01-tasks %})).

## Dump and Restore from your local workstation

To dump and restore database from your local workstation, you will need the MongoDB CLI tools. Installation procedures can be found [here](https://docs.mongodb.com/v3.0/tutorial/). You will also need a way to [access your database]({% post_url platform/databases/2000-01-01-access %}).

A MongoDB URL is usually formatted like:

`mongodb://<username>:<password>@<host>:<port>/<db>`

To get the URL of your database, go to the 'Environment' part of your dashboard or
run the following command:

```bash
$ scalingo --app my-app env | grep MONGO
```

If your remote database URL is:

```bash
mongodb://user:pass@my-db.mongo.dbs.com:30000/my-db
```

### Setup the tunnel

```bash
$ scalingo --app my-app db-tunnel SCALINGO_MONGO_URL

Building tunnel to my-db.mongo.dbs.scalingo.eu:30000
You can access your database on '127.0.0.1:10000'
```

### Dump

The command definition is:

```bash
$ mongodump -u <username> -p <password> -h <host>:<port> -d <db>
```

Applied to our example:

```bash
$ mongodump -u my-db -p pass -h 127.0.0.1:10000 -d my-db
```

The command will create a dump directory in your current working directory.

As you can see we use the host and port provided by the tunnel, not those of the URL.

### Restore

The command definition is:

```bash
$ mongorestore -u <username> -p <password> -h <host>:<port> -d <db> <dump directory>
```

With our example:

```bash
$ mongorestore -u my-db -p pass -h 127.0.0.1:10000 -d my-db dump/my-db
```

In addition you may use the [`--drop`
option](https://docs.mongodb.com/v3.4/reference/program/mongorestore/#cmdoption-mongorestore-drop)
to delete the existing data in the database.

## Dump and Restore from Scalingo one-off container

You can dump and restore your database remotely using
[the command-line-tool]({% post_url platform/cli/2000-01-01-start %})
and a one-off container (see [application tasks]({% post_url platform/app/2000-01-01-tasks %})).
The advantage of this method is the network.
From your workstation you don't always have a good bandwidth. From our infrastructure,
data transfers will be way faster.

### Dump

```bash
$ scalingo --app my-app run bash

[00:00] Scalingo ~ $ mongodump -u user -p pass -h my-db.mongo.dbs.scalingo.com:30000 -d my-db

# Do something with the dump, i.e send it with FTP or to an external server
```

### Restore

```bash
$ scalingo --app my-app run bash

# Get a dump from a remote place, with 'curl' or 'ftp'

[00:00] Scalingo ~ $ mongorestore -u my-db -p pass -h my-db.mongo.dbs.scalingo.com:30000 -d my-db dump/my-db
```

After exiting the one-off container, the dump will be lost, you've to do something with it in the container.
