---
title: Connecting to Your Scalingo for OpenSearch® Addon
nav: Connecting
modified_at: 2025-04-28 12:00:00
tags: databases opensearch addon
index: 2
---

When a Scalingo for OpenSearch® addon is provisioned, the platform also adds
two [environment variables][env] to your app:

- `SCALINGO_OPENSEARCH_URL`: a string containing all information needed to
  establish a connection between your application and your database. This
  string is called a **connection URI**.
- `OPENSEARCH_URL`: an alias for `SCALINGO_OPENSEARCH_URL`.


## Understanding the Connection URI

The connection URI is made of several **components** separated one from each
other by a **delimiter**. For example, the `@` character is used to mark the
end of the *userinfo* (credentials) component of the URI.

In the case of OpenSearch®, the connection URI provided by Scalingo is always
formed as follows:

```bash
http://[user]:[password]@[url]:[port]
```

Or, when [TLS is enabled](#enforcing-tls-connection):

```bash
https://[user]:[password]@[url]:[port]
```

For more information about the connection URI syntax, please see
[RFC 3986][rfc3986] which defines the URI Generic Syntax.


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
format, invididual keypairs or another format. In such cases, your code
needs to parse the connection URI to retrieve the different values and build
what's required by the library. Our advice to use the environment variable
still remains applicable.


## Getting the Connection URI

### Using the Dashboard

1. From your web browser, open your [dashboard][dashboard]
2. Click on the application for which you want to get the connection URI
3. Click on the **Environment** tab
4. Locate the `SCALINGO_OPENSEARCH_URL` line and place your mouse over it to
   unblur the value

### Using the Command Line

1. Make sure you have correctly [setup the Scalingo command line tool][cli]
2. From the command line, get the environment variable value:
   ```bash
   scalingo --app my-app env-get SCALINGO_OPENSEARCH_URL
   ```
   The output is:
   ```bash
   http://my_app_wxyz:YANs3y07m5_KJC2MSDGebh8tx1lliFWh2Yb239zVqGQvbElWDjIN7QWspVH92Ul8@my-app-wxyz.opensearch.b.osc-fr1.scalingo-dbs.com:35110
   ```


## Enforcing TLS Connection

By default, all new OpenSearch® databases have TLS **disabled**, which means
that the traffic between the database and the application is **not** encrypted.

If you want to enforce TLS connections to your database:

1. From your web browser, [open your database dashboard][db-dashboard]
2. Select the **Settings** tab
3. In the **Settings** submenu, select **Internet Access**
4. Locate the **Force TLS connections** block
5. Click the **Enable** button

Once this option is activated, the database denies any non-TLS connection.
Consequently, your application must be configured to use TLS when connecting to
the database.

Please note that while we strongly advise to use TLS, it remains an option,
meaning that you can still access your database without it if needed.


## Connecting Multiple Applications to the Same OpenSearch® Addon

To connect multiple applications to the same OpenSearch® addon, we usually
advise to duplicate the value of the `SCALINGO_OPENSEARCH_URL` environment
variable from the application owning the addon to the others:

1. Copy [the connection URI](#getting-the-connection-uri) of your addon
2. For each application that connects to the database, [create a new
   environment variable][env] (naming it `OPENSEARCH_URL` is generally a good
   idea)
3. Set the value of this new environment variable to connection URI you just
   copied
4. Restart the application to make the new environment variable available

{% note %}
When doing so, please keep in mind that any change applied to the original
`SCALINGO_OPENSEARCH_URL` environment variable will also have to be applied on
the others applications.
{% endnote %}


[rfc3986]: https://datatracker.ietf.org/doc/html/rfc3986
[dashboard]: https://dashboard.scalingo.com

[cli]: {% post_url tools/cli/2000-01-01-start %}
[db-dashboard]: {% post_url databases/opensearch/guides/2000-01-01-monitoring %}#accessing-the-opensearch-dashboard
[env]: {% post_url platform/app/2000-01-01-environment %}
