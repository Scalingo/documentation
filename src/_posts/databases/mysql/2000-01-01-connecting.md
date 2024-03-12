---
title: Connecting to Your Scalingo for MySQL® Addon
nav: Connecting
modified_at: 2024-03-04 12:00:00
tags: databases mysql addon
index: 3
---

When a Scalingo for MySQL® addon is provisioned, the platform also adds
two [environment variables]({% post_url platform/app/2000-01-01-environment %})
to your app:

- `SCALINGO_MYSQL_URL`: a string containing all information needed to
  establish a connection between your application and your database. This
  string is called a **connection URI**.
- `DATABASE_URL`: an alias for `SCALINGO_MYSQL_URL`.


## Understanding the Connection URI

The connection URI is made of several **components** separated one from each
other by a **delimiter**. For example, the `@` character is used to mark the
end of the *userinfo* (credentials) component of the URI.

In the case of MySQL®, the connection URI provided by Scalingo is always
formed as follows:

```bash
mysql://[user]:[password]@[url]:[port]/[dbname]?useSSL=true&verifyServerCertificate=false
```

For more information about the connection URI syntax, please see
[RFC 3986](https://datatracker.ietf.org/doc/html/rfc3986) which defines the URI
Generic Syntax.


## Using the Connection URI

**We strongly advise to use one of the two environment variables available to
connect your application to your database**. Please don't use the value, but
the environment variable itself.

While the value of the provided connection URI **should not** change over time,
**we don't guarantee it**. For example, the URI could change for maintenance
reasons. In such a case, using the environment variable guarantees that your
application can restart successfully without human intervention. Otherwise, you
would have to update your code with the new value and trigger a new deployment,
which would most probably contribute to a greater downtime.

In most cases, you can pass the environment variable directly to the client
library you are using. But sometimes, the library requires a specific URI
format, invididual keypairs or another format. In such cases, you
need to parse the connection URI to retrieve the required values and build
what's required by the library you are using. Our advice to use the environment
variable still remains applicable.


## Getting the Connection URI

### Using the Dashboard

1. From your web browser, open your [dashboard](https://dashboard.scalingo.com)
2. Click on the application for which you want to get the connection URI
3. Click on the **Environment** tab
4. Locate the `SCALINGO_MYSQL_URL` line and place your mouse over it to unblur
   the value

### Using the Command Line

1. Make sure you have correctly [setup the Scalingo command line tool]({% post_url platform/cli/2000-01-01-start %})
2. From the command line, get the environment variable value:
   ```bash
   scalingo --app my-app env-get SCALINGO_MYSQL_URL
   ```
   The output is:
   ```bash
   mysql://my_app_wxyz:Q7X7CU2vGjFiLZrA43OG@7e10d74b-c766-40b3-8dad-ce9cfa461311.my-app-wxyz.mysql.a.osc-fr1.scalingo-dbs.com:31000/my_app_wxyz?useSSL=true&verifyServerCertificate=false
   ```


## Enforcing TLS Connection

All MySQL® addons [support TLS](https://dev.mysql.com/doc/refman/8.0/en/encrypted-connections.html)
to encrypt all the network traffic between the client and the server.

By default, all new MySQL® databases have TLS **available**,
which means that you don't have to do anything to connect via TLS with a tool
or library that uses TLS by default.

If you want to enforce TLS connections to your database (so that TLS is
not only available, but **mandatory**):

1. From your web browser, [open your database dashboard]({% post_url databases/mysql/2000-01-01-getting-started %}#accessing-the-scalingo-for-mysql-dashboard)
2. Select the **Overview** tab
3. Locate the **TLS/Internet Access** block
4. Toggle the corresponding option:

{% assign img_url = "https://cdn.scalingo.com/documentation/screenshot_database_mongo_force_tls.png" %}
{% include mdl_img.html %}


Once this option is activated, the database denies any non-TLS connection.
Consequently, your application must be configured to use TLS when connecting to
the database.

Some existing databases may not have TLS support activated yet. To activate
TLS, you need to restart the database. Any action leading to a database
restart (such as a plan update or an upgrade of the database) will activate
TLS.

Please note that while we strongly advise to use TLS, it remains an option,
meaning that you can still access your database without it if needed.


## Connecting Multiple Applications to the Same MySQL® Addon

If you need to connect your MySQL® addon from multiple applications, you
can do it by adding an environment variable in every application wanting to
communicate with the database:

1. Copy [the connection URI](#getting-the-connection-uri) of your addon
2. [Create a new environment variable]({% post_url platform/app/2000-01-01-environment %})
   for the application that needs to access the addon
3. Set the value of this new environment variable to connection URI you just
   copied
4. Restart the application to make the new environment variable available


## Using Ruby on Rails

When using Ruby on Rails, the buildpack reads the `DATABASE_URL` environment
variable (which is an alias for `SCALINGO_MYSQL_URL`), parses it and creates
the `database.yml` configuration file accordingly and automatically.

If you're using the <em>mysql2</em> gem, you will need to copy the value of
`SCALINGO_MYSQL_URL` into `DATABASE_URL` and change the scheme part from
`mysql://` to `mysql2://`.
