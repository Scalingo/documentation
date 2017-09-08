---
title: Access your database
modified_at: 2017-09-08 00:00:00
category: databases
tags: databases
index: 1
---

There are three different solutions to access Scalingo's databases:

* Remote console: an interactive console is started and you access it directly.
* Encrypted tunnel: if you want a full access to the database, you have to build an
  SSH-encrypted tunnel, then you'll be able to access the database as if it was running locally.
  You have to use this solution if you want to import/export data.
* Direct encrypted access to the database.

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

To access them remotely from your workstation you need to setup an encrypted
connection.

How-to: [build an encrypted tunnel to your database]({% post_url databases/2014-11-24-tunnel %})

## Direct encrypted access to the database

<blockquote class="warning">
  This feature is only available for MongoDB databases.
  It will be expanded to others databases in the future.
</blockquote>

It is then required to force encrypted connections to the database first,
before enabling the accessibility from the Internet. Just head to your
database dashboard and click on the toggle button to make it reachable from
internet.
