---
title: Building a tunnel to access databases
category: databases
date: 24/11/2014
tags: databases, mongodb, mysql, postgresql, redis, elasticsearch
---

# Building a tunnel to access databases

## Context

Databases hosted on Scalingo are not directly available on the Internet. By default
access to most databases are unencrypted, so unsecure. To access them remotely
from your workstation you need to setup an encrypted connection.

## Requirements

You need to have Scalingo's [command line interface](http://cli.scalingo.com) to
achieve this action.

## Build the tunnel

By running the following command, an encrypted SSH tunnel will be built between you and your database.

```
$ scalingo -a example-app db-tunnel MONGO_URL
Building tunnel to <dbhost>:<dbport>
You can access your database on '127.0.0.1:<localport>'
```

> We use MONGO\_URL in the example, but it can be REDIS\_URL or DATABASE\_URL according to the database you're using.

## Use any client to read, import or export your data

Once the tunnel has been built, you can use any tool you need by connecting it to the
`127.0.0.1:<localport>` host.

> Credentials to connect to the database are still the same, so read them from `scalingo -a example-app env`

## Example

```
$ scalingo -a example-app db-tunnel MONGO_URL
Building tunnel to <dbhost>:<dbport>
You can access your database on '127.0.0.1:50123'

# In another terminal
$ scalingo -a example-app env | grep MONGO_URL
MONGO_URL=mongo://user:secret@<dbhost>:<dbport>/database

$ mongo -u user -p secret localhost:50123/database
$ mongodump -u user -p secret -h localhost:50123 -d database
```
