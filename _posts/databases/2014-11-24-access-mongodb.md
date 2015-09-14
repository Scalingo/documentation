---
title: Access your MongoDB database
modified_at: 2014-11-24 00:00:00
category: databases
tags: databases, mongodb,
index: 2
---

# Access your MongoDB database

{% include info_command_line_tool.md %}


## Use `scalingo run`

{% highlight bash %}
scalingo -a <application name> run mongo -u <user> -p <password> <host:port>/<db>
{% endhighlight %}

### Example

If my application's name is 'example' and it has the environment variable
`SCALINGO_MONGO_URL = "mongodb://example-123:H_grwjqBteMMrVye442Zw6@example-123.mongo.dbs.scalingo.com:30000/example-123"`

You can run:

{% highlight bash %}
$ scalingo -a example run 'mongo -u example-123 -p H_grwjqBteMMrVye442Zw6 example-123.mongo.dbs.scalingo.com:30000/example-123'
,
> db
example
> db.version()
2.6.5
{% endhighlight %}
