---
title: How to dump and restore my Redis database on Scalingo
nav: Dump and Restore
modified_at: 2023-02-17 00:00:00
tags: databases redis tunnel
index: 2
---

{% include info_command_line_tool.md %}

There are different ways to dump a Scalingo hosted database. The first one involves dumping the data on your local workstation and the second one involves doing the same operation from within a Scalingo one-off container (see [application tasks]({% post_url platform/app/2000-01-01-tasks %})).

Redis backups cannot be restored on Scalingo. To restore a Redis backup, one need to get access to the database file system which is not possible on Scalingo. However it is possible to [import data from an external Redis database]({% post_url databases/redis/2000-01-01-data-import %}).

## Dump From Your Local Workstation

To dump your database from your local workstation, you need the connection string to connect to your database and a way to [access your database]({% post_url platform/databases/2000-01-01-access %}).

You can get the connection string of your database in your Scalingo application environment. Go to the 'Environment' tab of your dashboard or run the following command:

```sh
$ scalingo --app my-app env-get SCALINGO_REDIS_URL
```

Your database connection string conforms to the syntax of a generic URI:

```sh
redis://:<password>@<host>:<port>
```

There are two ways to access your database from your local workstation: setting up a tunnel or making your database accessible from anywhere on the Internet.

### Setup the Tunnel

```sh
$ scalingo --app my-app db-tunnel SCALINGO_REDIS_URL
Building tunnel to my-db.redis.dbs.scalingo.eu:30000
You can access your database on '127.0.0.1:10000'
```

In this situation you need to use a different connection string than the one from your application environment. The `<host>` part is replaced by `127.0.0.1` and the `<port>` is replaced by `10000`.

### Internet Accessibility

In order to make your database reachable from anywhere on the internet, head to your database dashboard. You first need to force TLS connections to your database. Then toggle "Internet Accessibility" to make it reachable from the Internet.

In this situation, the connection string to use is exactly the same as the one from your application environment.

### Dump

The command definition is:

```sh
# If we are using the SSH tunnel endpoint:
$ redis-cli -h localhost -p 10000 -a <password> --rdb ./dump.rdb
```

## Dump From Scalingo One-off Container

You can dump your database remotely using [the command-line-tool]({% post_url platform/cli/2000-01-01-start %}) and a one-off container (see [application tasks]({% post_url platform/app/2000-01-01-tasks %})). The advantage of this method is the network. From your workstation you don't always have a good bandwidth. From our infrastructure, data transfers will be way faster.

You need to install the Redis CLI tools in the one-off before executing `redis-cli`:

```sh
$ scalingo --app my-app run bash

[00:00] Scalingo ~ $ dbclient-fetcher redis
```

### Dump

```sh
$ scalingo --app my-app run bash

[00:00] Scalingo ~ $ dbclient-fetcher redis
[00:00] Scalingo ~ $ redis-cli -h <host> -p <port> -a <password> --rdb ./dump.rdb

# Do something with the dump, e.g. send through FTP or to an external server

[00:00] Scalingo ~ $ exit
exit
```

After exiting the one-off container, the dump is lost. You have to do something with it in the container.
