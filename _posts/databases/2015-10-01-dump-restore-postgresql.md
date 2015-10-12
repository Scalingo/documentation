---
title: How to dump and restore my PostgreSQL database on Scalingo
modified_at: 2015-10-12 18:04:00
category: databases
tags: databases postgresql tunnel
index: 3
permalink: /databases/postgresql/dump-restore
---

{% include info_command_line_tool.md %}

There are two ways to dump a remote database and restore the data in your Scalingo database. The first one involves dumping the data on your local workstation and the second one involves doing the same operations from within a Scalingo one-off container (see [application tasks]({% post_url /app/2014-10-02-tasks %})).

## Dump and Restore from your local workstation

You can dump and restore your database from your local workstation using [Scalingo CLI]({% post_url cli/2015-09-18-command-line-tool %}) to [create a tunnel]({% post_url /databases/2014-11-24-tunnel %}) to your database:

A PostgreSQL URL is usually formatted like: <br>
`postgres://<username>:<password>@<host>:<port>/<db>`

### Dump

{% highlight bash %}
$ PGPASSWORD=<password> pg_dump -U <username> -h <host> -p <port> <db> > dump_sql_file.sql
{% endhighlight %}

If your remote database URL is : `postgres://user:pass@my-db.postgresql.dbs.com:30000/my-db`

Example:
{% highlight bash %}
$ PGPASSWORD=pass pg_dump -U user -h my-db.postgresql.dbs.com -p 30000 my-db > dump_sql_file.sql
{% endhighlight %}

### Restore

To restore a database to Scalingo, you need to [create a tunnel]({% post_url /databases/2014-11-24-tunnel %}) and run pg_restore:

{% highlight bash %}
$ scalingo -a <app_name> db-tunnel <db_url>
{% endhighlight %}
{% highlight bash %}
$ PGPASSWORD=<password> pg_restore -U <username> -h <host> -p <port> -d <db> dump_sql_file.sql
{% endhighlight %}

If your Scalingo database URL is : `postgres://myapp-123:H_grwjqBteMMrVye442Zw6@myapp-123.postgresql.dbs.scalingo.com:12345/myapp-123`

Example:
{% highlight bash %}
$ scalingo -a myapp db-tunnel SCALINGO_POSTGRESQL_URL &
scalingo -a myapp db-tunnel SCALINGO_POSTGRESQL_URL
Building tunnel to myapp-123.postgresql.dbs.scalingo.eu:12345
You can access your database on '127.0.0.1:54321'

$ PGPASSWORD=H_grwjqBteMMrVye442Zw6 pg_restore -U myapp-123 -h 127.0.0.1 -p 54321 -d myapp-123 dump_sql_file.sql
{% endhighlight %}

## Dump and Restore from Scalingo one-off container

You can dump and restore your database remotely using [the command-line-tool]({% post_url cli/2015-09-18-command-line-tool %}) and a one-off container (see [application tasks]({% post_url app/2014-10-02-tasks %})). The advantage of this method is the network. From your workstation you don't always have a good bandwidth. From our infrastructure, data transfers will be way faster.

{% highlight bash %}
$ scalingo -a myapp run bash

[00:01] Scalingo ~ $ env | grep SCALINGO_POSTGRESQL_URL
SCALINGO_POSTGRESQL_URL=postgres://myapp-123:H_grwjqBteMMrVye442Zw6@myapp-123.postgresql.dbs.scalingo.com:12345/myapp-123

[00:01] Scalingo ~ $ exit
exit
{% endhighlight %}

### Dump & Restore

{% highlight bash %}
$ PGPASSWORD=<password> pg_dump -U <username> -h <host> -p <port> <db> > dump_sql_file.sql
{% endhighlight %}
{% highlight bash %}
$ PGPASSWORD=<password> pg_restore -U <user> -h <host> -p <port> -d <db> dump_sql_file.sql
{% endhighlight %}

Example:
{% highlight bash %}
$ scalingo -a myapp run bash

[00:02] Scalingo ~ $ PGPASSWORD=pass pg_dump -U user -h my-db.postgresql.dbs.com -p 30000 my-db > dump_sql_file.sql

[00:03] Scalingo ~ $ PGPASSWORD=H_grwjqBteMMrVye442Zw6 pg_restore -U myapp-123 -h myapp-123.postgresql.dbs.scalingo.com -p 12345 -d myapp-123 dump_sql_file.db

[00:03] Scalingo ~ $ exit
exit
{% endhighlight %}
