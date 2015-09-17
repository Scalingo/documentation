---
title: Access your MySQL database
modified_at: 2014-11-25 00:00:00
category: databases
tags: databases mysql
index: 2
permalink: /databases/mysql/access
---

{% include info_command_line_tool.md %}


## Use `scalingo run`

{% highlight bash %}
scalingo -a <application name> run mysql -u <user> --password=<password> -h <host> -P <port> <db>
{% endhighlight %}

### Example

If my application's name is 'example' and it has the environment variable
`SCALINGO_MYSQL_URL = "mysql://example_123:H_grwjqBteMMrVye442Zw6@example-123.mysql.dbs.scalingo.com:30000/example_123"`

You can run:

{% highlight bash %}
$ scalingo -a example run 'mysql -u example_123 --password=H_grwjqBteMMrVye442Zw6 -h example-123.mysql.dbs.scalingo.com -P 30000 example_123'

Reading table information for completion of table and column names
You can turn off this feature to get a quicker startup with -A

Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 1
Server version: 5.5.40-0ubuntu0 (Ubuntu)

Copyright (c) 2000, 2014, Oracle and/or its affiliates. All rights reserved.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql> SHOW VARIABLES LIKE "%version%";
+-------------------------+------------------+
| Variable_name           | Value            |
+-------------------------+------------------+
| innodb_version          | 1.1.8            |
| protocol_version        | 10               |
| slave_type_conversions  |                  |
| version                 | 5.5.40-0ubuntu0  |
| version_comment         | (Ubuntu)         |
| version_compile_machine | x86_64           |
| version_compile_os      | debian-linux-gnu |
+-------------------------+------------------+
7 rows in set (0.00 sec)
{% endhighlight %}
