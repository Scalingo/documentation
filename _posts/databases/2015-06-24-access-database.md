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
  SSH-encrypted tunnel, then you will be able to access the database as if it was running locally.
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
scalingo --app my-app mysql-console

# Open a console using the `psql` client
scalingo --app my-app pgsql-console

# Open a console using the `mongo` client
scalingo --app my-app mongo-console

# Open a console using the `redis-cli` client
scalingo --app my-app redis-console
```

## Connect your workstation to the database

To access your database remotely from your workstation you need to setup an
encrypted connection: either via an [encrypted tunnel]({% post_url
databases/2014-11-24-tunnel %}) or by forcing TLS connection to your database.

## Direct encrypted access to the database

It is possible to make your database reachable from anywhere on internet. You
first need to [force TLS connections]({% post_url
databases/2000-01-01-scalingo-mongodb-addon %}) to your databases. Then head to
your database dashboard and click on the toggle button to make it reachable
from internet.
