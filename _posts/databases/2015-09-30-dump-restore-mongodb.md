---
title: How to dump and restore my MongoDB database on Scalingo
modified_at: 2015-10-01 14:22:00
category: databases
tags: databases mongodb tunnel
index: 3
permalink: /databases/mongodb/dump-restore/
---

{% include info_command_line_tool.md %}

There are two ways to dump a remote database and restore the data in your Scalingo database. The first one involves dumping the data on your local workstation and the second one involves doing the same operations from within a Scalingo one-off container (see [application tasks]({% post_url /app/2014-10-02-tasks %})).

## Dump and Restore from your local workstation

You can dump and restore your database from your local workstation using [Scalingo CLI]({% post_url cli/2015-09-18-command-line-tool %}) to [create a tunnel]({% post_url /databases/2014-11-24-tunnel %}) to your database:

A mongodb URL is usually formatted like: <br>
`mongodb://<username>:<password>@<host>:<port>/<db>`

### Dump

{% highlight bash %}
$ mongodump --username <user> --password <pass> --host <host> --port <port> -d <db> --out <directory>
{% endhighlight %}

If your remote database URL is : `mongodb://user:pass@my-db.mongo.dbs.com:30000/my-db`

Example:
{% highlight bash %}
$ mongodump --username user --password pass --host my-db.mongo.dbs.com --port 30000 -d my-db --out dump_directory
{% endhighlight %}

### Restore

To restore a database to Scalingo, you need to [create a tunnel]({% post_url /databases/2014-11-24-tunnel %}) and run mongorestore:

{% highlight bash %}
$ scalingo -a <app_name> db-tunnel <db_url>
{% endhighlight %}
{% highlight bash %}
$ mongorestore --username <user> --password <pass> --host <host> --port <port> -d <db> <directory>
{% endhighlight %}

If your Scalingo database URL is : `mongodb://myapp-123:H_grwjqBteMMrVye442Zw6@myapp-123.mongo.dbs.scalingo.com:12345/myapp-123`

Example:
{% highlight bash %}
$ scalingo -a myapp db-tunnel SCALINGO_MONGO_URL &
scalingo -a myapp db-tunnel SCALINGO_MONGO_URL
Building tunnel to myapp-123.mongo.dbs.scalingo.eu:12345
You can access your database on '127.0.0.1:54321'

$ mongorestore --username myapp-123 --password H_grwjqBteMMrVye442Zw6 --host 127.0.0.1 --port 54321 -d myapp-123 dump_directory/my-db
{% endhighlight %}

## Dump and Restore from Scalingo one-off container

You can dump and restore your database remotely using [the command-line-tool]({% post_url cli/2015-09-18-command-line-tool %}) and a one-off container (see [application tasks]({% post_url app/2014-10-02-tasks %})). The advantage of this method is the network. From your workstation you don't always have a good bandwidth. From our infrastructure, data transfers will be way faster.

{% highlight bash %}
$ scalingo -a myapp run bash

[00:01] Scalingo ~ $ env | grep SCALINGO_MONGO_URL
SCALINGO_MONGO_URL=mongodb://myapp-123:H_grwjqBteMMrVye442Zw6@myapp-123.mongo.dbs.scalingo.com:12345/myapp-123

[00:01] Scalingo ~ $ exit
exit
{% endhighlight %}

### Dump & Restore

{% highlight bash %}
$ mongodump --username <user> --password <pass> --host <host> --port <port> -d <db> --out <directory>
{% endhighlight %}
{% highlight bash %}
$ mongorestore --username <user> --password <pass> --host <host> --port <port> -d <db> <directory>
{% endhighlight %}

Example:
{% highlight bash %}
$ scalingo -a myapp run bash

[00:02] Scalingo ~ $ cd /tmp

[00:02] Scalingo /tmp $ mongodump --username user --password pass --host my-db.mongo.dbs.com --port 30000 -d my-db --out dump_directory

[00:03] Scalingo /tmp $ mongorestore --username myapp-123 --password H_grwjqBteMMrVye442Zw6 --host myapp-123.mongo.dbs.scalingo.com --port 12345 -d myapp-123 /tmp/dump_directory/my-db

[00:03] Scalingo /tmp $ exit
exit
{% endhighlight %}
