---
title: Encrypted Tunnel
modified_at: 2026-02-09 12:00:00
tags: databases
index: 2
---

This page details how to use the Encrypted Tunnel method from
[Access Your Database][access-your-database].

## Availability

Encrypted Tunnel is available on Shared Resources databases.

{% note %}
For Dedicated Resources databases, use direct access with firewall allowlists.
See [Access Your Database][access-your-database].
{% endnote %}

## Build the Tunnel

The DB tunnel encrypts traffic between your computer and Scalingo, so data is
not sent in clear text over the network. It does not add an extra
access-control layer: we only check that your public key is registered on the
platform.

{% include info_command_line_tool.md %}

{% include db_tunnel_requires_ssh.md %}

By running the following command, an encrypted SSH tunnel is built between you
and your database:

```bash
scalingo --app my-app db-tunnel DATABASE_URL
```

You can use any database environment variable according to the database you are
using (for example `SCALINGO_POSTGRESQL_URL` or `SCALINGO_MYSQL_URL`).

Each database engine can have specific tunnel prerequisites or client-side
details. For engine-specific instructions, see:

- [Scalingo for PostgreSQL®]({% post_url databases/postgresql/getting-started/2000-01-01-accessing %}#using-our-command-line-tool)
- [Scalingo for MySQL®]({% post_url databases/mysql/getting-started/2000-01-01-accessing %}#using-our-command-line-tool)
- [Scalingo for OpenSearch]({% post_url databases/opensearch/getting-started/2000-01-01-accessing %}#using-our-command-line-tool)
- [Scalingo for MongoDB®]({% post_url databases/mongodb/2000-01-01-dump-restore %}#setup-the-tunnel)
- [Scalingo for Caching]({% post_url databases/redis/2000-01-01-dump-restore %}#setup-the-tunnel)


## Use Any Client to Read, Import, or Export Data

Once the tunnel has been built, you can use any tool by connecting it to
`127.0.0.1:<localport>`.

{% note %}
Credentials to connect to the database are still the same, so read them from
`scalingo --app my-app env`.
{% endnote %}

### Example

```bash
$ scalingo --app my-app db-tunnel MONGO_URL
Building tunnel to <dbhost>:<dbport>
You can access your database on '127.0.0.1:10000'

# In another terminal
$ scalingo --app my-app env | grep MONGO_URL
MONGO_URL=mongo://user:secret@<dbhost>:<dbport>/database?options

$ mongo "mongo://user:secret@<dbhost>:<dbport>/database?options"
$ mongodump -u user -p secret -h localhost:10000 -d database
```

If you connect using SSL/TLS, add both options `--ssl` and
`--sslAllowInvalidCertificates` to the `mongo` command.

## Build the Tunnel with the OpenSSH Client

Our command line tool handles this in a single command, but you can also build
the tunnel with the standard OpenSSH client:

```bash
ssh -L <local port>:<database host>:<database port> git@<SSH hostname> -p <SSH port> -N
```

The SSH hostname and port depend on the region of your application:

{% include ssh_endpoints.md %}

The database host and database port can be found in the connection string
environment variable of your database instance:

- `SCALINGO_<TYPE>_URL`

{% warning %}
Since this value may change, use the variable directly in your application
rather than hard-coding or duplicating it in your code.
{% endwarning %}

The value of this variable is a URL which represents:

```
scheme://user:password@host:port/database_name
```

You need to get `host` and `port` from this URL.

Example with an app in region `osc-fr1`:

```
SCALINGO_POSTGRESQL_URL=postgresql://user:secret@my-db.postgresql.a.osc-fr1.scalingo-dbs.com:30000/my-db
```

Command:

```bash
ssh -L 10000:my-db.postgresql.a.osc-fr1.scalingo-dbs.com:30000 git@ssh.osc-fr1.scalingo.com -N
```

Then connect on `localhost:10000` to reach your database. You still need to
authenticate with the credentials from the connection string.

[access-your-database]: {% post_url platform/databases/2000-01-01-access %}
