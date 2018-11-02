---
title: Importing data from an external Redis database
nav: Importing data
tags: databases redis dump restore migration
index: 2
---

This tutorial aims at transfering all the data from a remote Redis database
(from another provider) to a Redis instance provisioned through the [Scalingo
Redis Addon]({% post_url databases/redis/2000-01-01-start %}).

{% include info_command_line_tool.md %}

## Requirements

The remote redis instance should be accessible on the Internet, and you could connect with:

```console
$ redis-cli -a <password> -h <host> -p <port>
```

## Create a redis-console on Scalingo

Thanks to the `redis-console` utility of the `scalingo` command, create a
console to your Redis addon:

```console
$ scalingo -a my-app redis-console
-----> Connecting to container [one-off-5541]...
-----> Process 'redis-console' is starting...

---> Download and extract the database CLI
---> Database CLI installed: redis-cli 4.0.8
[host:port] >
```

## Copy data from the remote Redis instance

<aside class="warning" markdown="1">
These actions will erase all the existing content of the Scalingo redis
instance, don't do it if you've precious data stored.
</aside>

You need to own the source Redis connection information in order to copy its
content. Let's consider the following example:

* Host: `ec2-34-242-7-204.eu-west-1.compute.amazonaws.com`
* Port: `10189`
* Password: `pfe8060d30f6059b98a7ce7d`

The following method configures temporarily the Redis instance hosted on
Scalingo to be become a slave of the remote your want to copy the content from.
Once the operation will be over, the replication link will be disabled, all the
keys and values will have been transfered.

Back in the `redis-console`:

```console
[host:port] > CONFIG SET masterauth pfe8060d30f6059b98a7ce7d
OK
[host:port] > SLAVEOF ec2-34-242-7-204.eu-west-1.compute.amazonaws.com 10189
OK
```

At that point, the replication process has started, its duration is relative to
the amount of data contained by the remote database, it's usually a matter of seconds.
To check if the process is over, look at the `INFO` command:

```console
[host:port] > INFO replication
# Replication
role:slave
master_host:ec2-34-242-7-204.eu-west-1.compute.amazonaws.com
master_port:10189
master_link_status:up
master_last_io_seconds_ago:1
master_sync_in_progress:0
```

<aside class="warning" markdown="1">
First check the `master_link_status`, it should be `up`, otherwise, it means
the replication process did not start, probably because of an error in the
connection information, check you can connect to the remote server with `redis-cli`
</aside>

Once the `master_sync_in_progress` value becomes `0`, it means the data
synchronization is over.

## Restore configuration

Once the synchronization is over, you need to disable the replication configuration:

```console
[host:port] > SLAVEOF NO ONE
```

That's it, your Redis instance, owns all the data of your remote Redis, and is
ready to accept queries from your application.
