---
title: How to dump and restore my MySQL database on Scalingo
modified_at: 2015-10-01 14:22:00
category: databases
tags: databases mysql tunnel
index: 3
permalink: /databases/mysql/dump-restore
---

{% include info_command_line_tool.md %}

There's two ways to dump a distant database and restore the data in your Scalingo database. The first one involves dumping the data on your local workstation and the second one involves doing the same operations from within a Scalingo one-off container (see [application tasks]({% post_url app/2014-10-02-tasks %})).

## Dump and Restore from your local workstation

You can dump and restore your database from your local workstation using [Scalingo CLI]({% post_url cli/2015-09-18-command-line-tool %}) to [create a tunnel]({% post_url /databases/2014-11-24-tunnel %}) to your database:

A mysql URL is usually formatted like: <br>
`mysql://<username>:<password>@<host>:<port>/<db>`

### Dump

{% highlight bash %}
$ mysqldump -u <username> -p <password> -h <host> -P <port> <db> > output_sql_file.sql
{% endhighlight %}

If your remote database URL is : `mysql://user:pass@my-db.mysql.dbs.com:30000/my-db`

Example:
{% highlight bash %}
$ mysqldump -u user -p pass -h my-db.mysql.dbs.com -P 30000 my-db > /tmp/dumped_db.sql
{% endhighlight %}

### Restore

To restore a database to Scalingo, you need to [create a tunnel]({% post_url /databases/2014-11-24-tunnel %}) and simply run `mysql` with your dumped database as standart input:

{% highlight bash %}
$ scalingo -a <app_name> db-tunnel <db_url>
{% endhighlight %}
{% highlight bash %}
$ mysql -u <user> -p <password> -h <host> -P <port> <db> < input_sql_file.sql
{% endhighlight %}

If your Scalingo database URL is : `mysql://myapp-123:H_grwjqBteMMrVye442Zw6@myapp-123.mysql.dbs.scalingo.com:30000/myapp-123`

Example:
{% highlight bash %}
$ scalingo -a myapp db-tunnel SCALINGO_MYSQL_URL &
scalingo -a myapp db-tunnel SCALINGO_MYSQL_URL
Building tunnel to myapp-123.mysql.dbs.scalingo.eu:12345
You can access your database on '127.0.0.1:54321'

$ mysql -u myapp-123 -p H_grwjqBteMMrVye442Zw6 -h 127.0.0.1 -P 54321 myapp-123 < /tmp/dumped_db.sql
{% endhighlight %}

## Dump and Restore from Scalingo one-off container

You can dump and restore your database remotely using [the command-line-tool]({% post_url cli/2015-09-18-command-line-tool %}) and a one-off container (see [application tasks]({% post_url app/2014-10-02-tasks %})). The advantage of this method is the network. From your workstation you don’t always have a good bandwidth. From our infrastructure, data transfers will be way faster.

{% highlight bash %}
$ scalingo -a myapp run bash

[00:01] Scalingo ~ $ env | grep SCALINGO_MYSQL_URL
SCALINGO_MYSQL_URL=mysql://myapp-123:H_grwjqBteMMrVye442Zw6@myapp-123.mysql.dbs.scalingo.com:12345/myapp-123

[00:01] Scalingo ~ $ exit
exit
{% endhighlight %}

### Dump & Restore

{% highlight bash %}
$ mysqldump -u <username> -p <password> -h <host> -P <port> <db> > output_sql_file.sql
{% endhighlight %}
{% highlight bash %}
$ mysql -u <user> -p <password> -h <host> -P <port> <db> < input_sql_file.sql
{% endhighlight %}

Example:
{% highlight bash %}
$ scalingo -a myapp run bash

[00:02] Scalingo ~ $ mysqldump -u user -p pass -h my-db.mysql.dbs.com -P 30000 my-db > /tmp/dumped_db.sql

[00:02] Scalingo ~ $ mysql -u myapp-123 -p H_grwjqBteMMrVye442Zw6 -h myapp-123.mysql.dbs.scalingo.com -P 12345 myapp-123 < /tmp/dumped_db.sql

[00:03] Scalingo ~ $ exit
exit
{% endhighlight %}
