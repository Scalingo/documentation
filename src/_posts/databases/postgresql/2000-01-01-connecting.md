---
title: Connecting to Your Scalingo for PostgreSQL® Addon
nav: Connecting
modified_at: 2023-11-23 00:00:00
tags: databases postgresql addon
index: 3
---

When a PostgreSQL addon is provisioned, the platform also adds 2 [environment
variables]({% post_url platform/app/2000-01-01-environment %}) to your app:

- `SCALINGO_POSTGRESQL_URL`: a string containing all information needed to
  establish a connection between your application and your database. This
  string is called a **connection URI**.
- `DATABASE_URL`: an alias for `SCALINGO_POSTGRESQL_URL`.


## Understanding the Connection URI

The connection URI is made of several **components** separated one from each
other by a **delimiter**. For example, the `@` character is used to mark the
end of the *userinfo* (credentials) component of the URI.

In the case of PostgreSQL, the connection URI provided by Scalingo is always
formed as follows:

```bash
postgresql://[user]:[password]@[url]:[port]/[dbname]?sslmode=prefer
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
format, invididual keypairs or another format. In such cases, you will probably
need to parse the connection URI to retrieve the required values and build
what's required by the library you are using. Our advice to use the environment
variable still remains applicable.


## Getting the Connection URI

### Using the Dashboard

1. From your web browser, open your [dashboard]()
2. Click on the application for which you want to get the connection URI
3. Click on the **Environment** tab
4. Locate the `SCALINGO_POSTGRESQL_URL` line and place your mouse over it to
   unblur the value

### Using the Command Line

1. Make sure you have correctly [setup the Scalingo Command Line tool]({% post_url platform/cli/2000-01-01-start %})
2. From the command line, list the environment variables available in your app
   and filter the output using `grep`:
   ```bash
   scalingo --app my-app env | grep POSTGRESQL
   ```
   The output should look like this:
   ```bash
   DATABASE_URL=$SCALINGO_POSTGRESQL_URL
   SCALINGO_POSTGRESQL_URL=postgresql://my_app_wxyz:ptojfrxzRi-lDfDYyahe@my-app-wxyz.postgresql.a.osc-fr1.scalingo-dbs.com:31000/my_app_wxyz?sslmode=prefer
   ```


## Enforcing TLS Connection

All Scalingo for PostgreSQL® addons [support TLS](https://www.postgresql.org/docs/current/static/ssl-tcp.html)
to encrypt all the network traffic between the client and the server.

By default, all new Scalingo for PostgreSQL® databases have TLS **activated**
(available), which means that you don't have to do anything to connect via TLS
with a tool or library that uses TLS by default.

Let's see an example with `psql`:

```shell
> psql $SCALINGO_POSTGRESQL_URL
psql (14.8)
SSL connection (protocol: TLSv1.3, cipher: TLS_AES_256_GCM_SHA384, bits: 256, compression: off)
Type "help" for help.

my_app_wxyz=>
```

If you want to enforce TLS connections to your database (so that TLS is
not only available, but **mandatory**), head to your database dashboard and
toggle the corresponding option:

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