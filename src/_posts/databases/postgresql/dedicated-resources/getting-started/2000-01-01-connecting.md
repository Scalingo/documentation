---
title: Connecting Your Scalingo for PostgreSQL® Dedicated Resources Database
nav: Connecting
modified_at: 2026-02-13 12:00:00
tags: databases postgresql dedicated
index: 2
---


Each Scalingo for PostgreSQL® Dedicated Resources database has its own
**connection URI**, containing all information needed to connect to it.


## Understanding the Connection URI

The connection URI is made of several **components** separated one from each
other by a **delimiter**. For example, the `@` character is used to mark the
end of the *userinfo* (credentials) component of the URI.

In the case of PostgreSQL®, the connection URI provided by Scalingo is always
formed as follows:

```bash
postgresql://[user]:[password]@[url]:[port]/[dbname]?sslmode=require
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
format, individual keypairs or another format. In such cases, your code
needs to parse the connection URI to retrieve the different values and build
what's required by the library. Our advice to use the environment variable
still remains applicable.


## Getting the Connection URI

### Using the Dashboard

1. From your web browser, open your [dashboard][dashboard]
2. Open the **Project** containing the database you want to manage
3. In the **Databases** section, click the database name
4. Locate the **Connect** section then copy its **Connection String**

### Using the Command Line

1. Make sure you have correctly [setup the Scalingo command line tool][cli]
2. From the command line, get the environment variable value:
   ```bash
   scalingo --app my-dedicated-database env-get SCALINGO_POSTGRESQL_URL
   ```
   The output is:
   ```bash
   postgresql://my_dedicate_wxyz:YANs3y07m5_KJC2MSDGebh8tx1lliFWh2Yb239zVqGQvbElWDjIN7QWspVH92Ul8@my-dedicate-wxyz.postgresql.a.osc-fr1.scalingo-dbs.com:31000/my_dedicate_xyz?sslmode=require
   ```


## TLS Connections Are Enforced

By default, all PostgreSQL® Dedicated Resources databases enforce TLS.
Any non-TLS connection is denied. Consequently, your application must be
configured to use TLS when connecting to the database.


## Connecting Multiple Applications to the Same Database

To share a database across multiple Scalingo applications, first make sure the
Dedicated Resources firewall allows traffic from the application's region (see
[Allowing Scalingo Apps to Reach a Dedicated Resources Database][dr-firewall-regions]).
Then add the database connection string as an environment variable in each
application that needs access.

1. Copy [the connection URI](#getting-the-connection-uri) of your database instance
2. [Create a new environment variable][environment] for the application that
   needs to access the addon
3. Set the value of this new environment variable to connection URI you just
   copied
4. Restart the application to make the new environment variable available


[rfc3986]: https://datatracker.ietf.org/doc/html/rfc3986
[dashboard]: https://dashboard.scalingo.com

[cli]: ({% post_url tools/cli/2000-01-01-start %})
[environment]: {% post_url platform/app/2000-01-01-environment %}
[dr-firewall-regions]: {% post_url databases/about/2000-01-01-network-exposure %}#allowing-scalingo-apps-to-reach-a-dedicated-resources-database

[database-dashboard]: {% post_url databases/postgresql/dedicated-resources/getting-started/2000-01-01-provisioning %}#accessing-the-scalingo-for-postgresql-dashboard
