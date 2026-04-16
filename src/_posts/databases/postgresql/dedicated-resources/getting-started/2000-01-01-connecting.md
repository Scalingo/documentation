---
title: Connecting Your Scalingo for PostgreSQL® Dedicated Resources Database
description: "Retrieve and understand the Dedicated PostgreSQL connection URI, map each URI component, and connect applications securely with SSL-ready settings."
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


## Getting the Connection URI

Scalingo exposes a connection URI you can use to connect to your Dedicated
Resources database with its default protected user.

Depending on the client or driver you use, you can either use this URI as-is or
split it into separate values (host, port, database, user, password, TLS
settings) to match the expected format.

If you connect with another database user you created, keep the same endpoint
and database name, and replace the credentials with this user's credentials.

### Using the Dashboard

1. From your web browser, open your [dashboard][database-dashboard]
2. Locate the **Connect** section then copy its **Connection String**

### Using the Command Line

1. Make sure you have correctly [setup the Scalingo command line tool][cli]
2. From the command line, list your databases:
   ```bash
   scalingo databases
   ```
3. Locate the `ID` of the database you would like to connect to
4. From the command line, get the connection URI value:
   ```bash
   scalingo --database <database_ID> env-get SCALINGO_POSTGRESQL_URL
   ```
   The output is:
   ```bash
   postgresql://my_dedicate_wxyz:YANs3y07m5_KJC2MSDGebh8tx1lliFWh2Yb239zVqGQvbElWDjIN7QWspVH92Ul8@my-dedicate-wxyz.postgresql.a.osc-fr1.scalingo-dbs.com:31000/my_dedicate_wxyz?sslmode=require
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
   needs to access the database
3. Set the value of this new environment variable to connection URI you just
   copied
4. Restart the application to make the new environment variable available


[rfc3986]: https://datatracker.ietf.org/doc/html/rfc3986

[cli]: {% post_url tools/cli/2000-01-01-start %}
[environment]: {% post_url platform/app/2000-01-01-environment %}
[dr-firewall-regions]: {% post_url databases/postgresql/dedicated-resources/getting-started/2000-01-01-accessing %}#allowing-scalingo-apps-to-reach-a-dedicated-resources-database
[database-dashboard]: {% post_url databases/postgresql/dedicated-resources/getting-started/2000-01-01-provisioning %}#accessing-the-scalingo-for-postgresql-dashboard
