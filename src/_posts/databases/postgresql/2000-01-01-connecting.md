---
title: Connecting to Your Scalingo for PostgreSQL® Addon
nav: Connecting
modified_at: 2023-11-23 00:00:00
tags: databases postgresql addon
index: 3
---



## Getting Your Connection URI



### Using the Dashboard

1. From your web browser, open your [dashboard]()
2. Click on the application for which you want to get the connection URI
3. Click on the **Environment** tab
4. Locate the `SCALINGO_POSTGRESQL_URL` line and place your mouse over this
   line to unblur the value

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

## Understanding the Connection URI

The connection URI is made of several **components** separated one from each
other by a **delimiter**. For example, the `@` character is used to mark the end of the *userinfo*
(credentials) component of the URI.

In the case of PostgreSQL, the connection URI provided by Scalingo is always
formed as follows:

```bash
postgresql://[user]:[password]@[url]:[port]/[dbname]?sslmode=prefer
```

For more information about the connection URI syntax, please see
[RFC 3986](https://datatracker.ietf.org/doc/html/rfc3986) which defines the URI
Generic Syntax.


## Enforcing TLS Connection

FIXME

