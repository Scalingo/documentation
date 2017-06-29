---
title: Access your database
modified_at: 2015-06-24 00:00:00
category: databases
tags: databases
index: 1
---

Databases hosted on Scalingo are not directly available on the Internet. By default
access to most databases are unencrypted, so unsecure. Applications are on the same
network than your database, but you can not connect your machine to it directly.

We've built two different solutions to access Scalingo's databases:

* Remote console: an interactive console is started and you access it directly.
* Encrypted tunnel: if you want a full access to the database, you have to build an
  SSH-encrypted tunnel, then you'll be able to access the database as if it was running locally.
  You have to use this solution if you want to import/export data.

## Open an interactive remote console

<blockquote class="bg-info">
You need to have Scalingo's <a href="http://cli.scalingo.com" target="_blank">command line interface</a> to
achieve this action.
</blockquote>

The following commands let you open a console for the database
of your choice. Note that your should have added the appropriate addon from
your application dashboard prior to run one of these commands.

```bash
# Open a console using the `mysql` client
scalingo -a example-app mysql-console

# Open a console using the `psql` client
scalingo -a example-app pgsql-console

# Open a console using the `mongo` client
scalingo -a example-app mongo-console

# Open a console using the `redis-cli` client
scalingo -a example-app redis-console
```

## Connect your workstation to the database

 To access them remotely
from your workstation you need to setup an encrypted connection.

How-to: [build an encrypted tunnel to your database]({% post_url databases/2014-11-24-tunnel %})
