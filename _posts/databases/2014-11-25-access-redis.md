---
title: Access your Redis database
modified_at: 2014-11-25 00:00:00
category: databases
tags: databases redis
index: 2
---

{% include info_command_line_tool.md %}

## Use `scalingo run`

{% highlight bash %}
scalingo -a <application name> run redis-cli -a <password> -h <host> -p <port>
{% endhighlight %}

### Example

If my application's name is 'example' and it has the environment variable
`SCALINGO_REDIS_URL = "redis://example-123:H_grwjqBteMMrVye442Zw6@example-123.redis.dbs.scalingo.com:30000/example-123"`

You can run:

{% highlight bash %}
$ scalingo -a example run 'redis-cli -a H_grwjqBteMMrVye442Zw6 -h example-123.redis.dbs.scalingo.com -p 30000'
example-123.redis.dbs.scalingo.com:30000> INFO
# Server
redis_version:2.8.17
redis_git_sha1:00000000
redis_git_dirty:0
redis_build_id:f5241507149db826
redis_mode:standalone
os:Linux 3.13.0-32-generic x86_64
arch_bits:64
multiplexing_api:epoll
gcc_version:4.8.2
[...]
{% endhighlight %}
