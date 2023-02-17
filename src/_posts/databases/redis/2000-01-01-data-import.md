---
title: Importing Data From an External Redis Database
nav: Importing Data
modified_at: 2023-02-17 00:00:00
tags: databases redis dump restore migration
index: 3
---

This tutorial aims at transferring all the data from a remote Redis database
(from another provider) to a Redis instance provisioned through the [Scalingo
Redis Addon]({% post_url databases/redis/2000-01-01-start %}).

{% include info_command_line_tool.md %}

## Requirements

The remote Redis instance should be accessible on the Internet.

These instructions require Redis Input/Output Tools (RIOT) to be installed. This is a set of tools developed by the Redis team. The installation instructions are available on [this page](https://developer.redis.com/riot/riot-redis).

## Install RIOT in a One-Off Container

You first need to install RIOT in a one-off container of your application. RIOT needs a Java Runtime Environment (JRE) to work. When JRE and RIOT are installed, we can replicate the Redis running on an external server:

```sh
$ scalingo --app my-app run bash
[00:00] Scalingo ~ $ wget https://github.com/redis-developer/riot/releases/latest/download/riot-redis-$(wget -q --output-document=- https://github.com/redis-developer/riot/releases/latest/download/VERSION).zip
[00:00] Scalingo ~ $ unzip riot-redis*.zip
[00:00] Scalingo ~ $ git clone https://github.com/Scalingo/buildpack-jvm-common.git
[00:00] Scalingo ~ $ echo "java.runtime.version=15" > system.properties
[00:00] Scalingo ~ $ ./buildpack-jvm-common/bin/compile /app
[00:00] Scalingo ~ $ export PATH=$PATH:/app/.jdk/bin/
[00:00] Scalingo ~ $ ./riot-redis-*/bin/riot-redis --uri $SCALINGO_REDIS_URL replicate --uri $REDIS_SOURCE_URL
```

The `REDIS_SOURCE_URL` variable must contain the connection string to the external Redis instance. For Redis URI syntax see [here](https://github.com/lettuce-io/lettuce-core/wiki/Redis-URI-and-connection-details#uri-syntax).

At that point, the replication process has started. Its duration is relative to
the amount of data contained on the remote database. It's usually a matter of seconds.

Note that the `riot-redis` tool is powerful and includes various arguments. All the information is on the [documentation page](https://developer.redis.com/riot/riot-redis/). You may want to have a look at the `--mode live` option for continuous replication. It could be useful for a 0-downtime migration.
