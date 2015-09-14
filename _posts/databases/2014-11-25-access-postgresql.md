---
title: Access your PostgreSQL database
modified_at: 2014-11-25 00:00:00
category: databases
tags: databases, postgresql,
index: 2
---

# Access your PostgreSQL database

{% include info_command_line_tool.md %}


## Use `scalingo run`

{% highlight bash %}
scalingo -a <application name> run -e PGPASSWORD=<password> psql -U <user> -h <host> -p <port> <db>
{% endhighlight %}

### Example

If my application's name is 'example' and it has the environment variable
`SCALINGO_POSTGRESQL_URL = "postgresql://example_123:H_grwjqBteMMrVye442Zw6@example-123.postgresql.dbs.scalingo.com:30000/example_123"`

You can run:

{% highlight bash %}
$ scalingo -a example run -e PGPASSWORD=H_grwjqBteMMrVye442Zw6 'psql -U example_123 -h example-123.postgresql.dbs.scalingo.com -p 30000 example_123'
psql (9.3.5)
Type "help" for help.

example_123=> SELECT version();
                                               version
------------------------------------------------------------------------------------------------------
 PostgreSQL 9.3.5 on x86_64-unknown-linux-gnu, compiled by gcc (Ubuntu 4.8.2-19ubuntu1) 4.8.2, 64-bit

{% endhighlight %}
