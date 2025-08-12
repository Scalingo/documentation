---
title: Accessing Your Scalingo for PostgreSQL® Addon
nav: Accessing
modified_at: 2023-12-01 00:00:00
tags: databases postgresql addon
index: 6
---


Remotely accessing your Scalingo for PostgreSQL® database can sometimes be
useful, for example, to conduct investigations, to check or compute data
locally, to dump the database content,...

We provide several ways to access your database remotely. Chosing one mostly
depends on your needs and preferences.

## Using the Interactive Remote Console

1. Make sure you have correctly [setup the Scalingo Command Line tool]({% post_url platform/cli/2000-01-01-start %})
2. From the command line, open a console for your Scalingo for PostgreSQL®
   addon:
   ```bash
   scalingo --app my-app pgsql-console
   ```
   The output should look like this:
   ```bash
   -----> Starting container one-off-7872  Done in 0.479 seconds
   -----> Connecting to container [one-off-7872]...  
   -----> Process 'pgsql-console my_app_4553' is starting...  

   ---> Download and extract the database CLI
   ---> Database CLI installed:
   psql (PostgreSQL) 14.6
   psql (14.6, server 14.8 (Debian 14.8-1.pgdg110+1))
   SSL connection (protocol: TLSv1.3, cipher: TLS_AES_256_GCM_SHA384, bits: 256, compression: off)
   Type "help" for help.

   my_app_4553=>
   ```
3. To exit, type the following command from the PostgreSQL® console, or use the
   keyboard shortcut `CTRL`+`D`:
   ```bash
   \q
   ```


## Using a One-Off

1. [Start a one-off container]({% post_url platform/app/2000-01-01-tasks %})
2. From the command line, use our `dbclient-fetcher` helper to download and
   install a bunch of PostgreSQL® tools:
   ```bash
   dbclient-fetcher pgsql
   ```
   The output should look like this:
   ```bash
   ---> Download and extract the database CLI
   ---> Database CLI installed:
   psql (PostgreSQL) 14.6
   ```
3. If you ever need a specific version, just add it as a second parameter:
   ```bash
   dbclient-fetcher pgsql 13
   ```
   The output should look like this:
   ```bash
   ---> Download and extract the database CLI
   ---> Database CLI installed:
   psql (PostgreSQL) 13.11
   ```

The helper installs the following tools:
- `psql`
- `pg_basebackup`
- `pg_controldata`
- `pg_dump`
- `pg_isready`
- `pg_recvlogical`
- `pg_restore`
- `pg_test_fsync`
- `pg_upgrade`
- `pg_archivecleanup`
- `pg_config`
- `pg_ctl`
- `pg_dumpall`
- `pg_receivewal`
- `pg_resetwal`
- `pg_rewind`
- `pg_test_timing`
- `pg_waldump`


## Using Third Party Tools

By default, and for security reasons, your Scalingo for PostgreSQL® database is
not directly accessible from the Internet.

To access your database remotely you first need to [make it reachable over the
Internet](#making-the-database-reachable-over-internet):
- either locally, on your computer, via an [encrypted tunnel](#setting-up-an-encrypted-tunnel)
- or from any location, by [enforcing TLS connection]({% post_url databases/postgresql/2000-01-01-connecting %}#enforcing-tls-connection)
  and [enabling direct Internet access](#enabling-direct-access-over-internet).

Once a secured connection has been established, you should be able to connect
to your database with your tool of choice. If you don't have one yet, we
suggest you to [take a look at pgAdmin](#using-pgadmin).

###  Making the Database Reachable Over Internet

#### Using Our Command Line Tool

Our Command Line tool provides a `db-tunnel` command that creates an SSH
encrypted tunnel, allowing remote access to your Scalingo for PostgreSQL®
addon.

This tunnel does not provide any additional security layer. We only verify that
your public key is registered on our platform. It acts as an encrypted bridge
between the computer running the command and our infrastructure.

1. Make sure you have correctly [setup the Scalingo Command Line tool]({% post_url platform/cli/2000-01-01-start %})
2. Make sure you have correctly [setup SSH authentication]({% post_url platform/getting-started/2000-01-01-first-steps %})
   on your Scalingo account
3. From the command line, open the tunnel using this command:
   ```bash
   scalingo --app my-app db-tunnel SCALINGO_POSTGRESQL_URL
   ```
   The output should look like this:
   ```bash
   Building tunnel to my-app-4553.postgresql.a.osc-fr1.scalingo-dbs.com:33712
   You can access your database on:
   127.0.0.1:10000
   ```
4. As stated, the database is now reachable from `127.0.0.1` on port `10000`
5. To specify the port number to bind to (default is `10000`), use the `--port`
   option:
   ```bash
   scalingo --app my-app db-tunnel SCALINGO_POSTGRESQL_URL --port 12345
   ```
6. To close the tunnel, use the keyboard shortcut `CTRL`+`C`:
   ```bash
   ^Cinterrupt catched, aborting…
   ```

#### Using OpenSSH

Our Command Line Tool [handles it in a single command](#using-our-command-line-tool),
but you might want to use the tunnel without it. With the standard OpenSSH
client, the way to build the tunnel is:

1. Identify the [connection URI]({% post_url databases/postgresql/2000-01-01-connecting %}#getting-the-connection-uri)
   for your database
2. Make sure to [understand how the connection URI is built]({% post_url databases/postgresql/2000-01-01-connecting %}#understanding-the-connection-uri)
3. From the command line, run the following command to create the tunnel:
   ```bash
   ssh -L <local_port>:<db_url>:<db_port> git@<ssh_hostname> -p 22 -N
   ```
   With:
   - `local_port`: local port number you want to bind to
   - `db_url`: URL of your database, from the environment variable
   - `db_port`: port
   - `ssh_hostname`: depends on your region:
     - For `osc-fr1`: `ssh.osc-fr1.scalingo.com`
     - For `osc-secnum-fr1`: `ssh.osc-secnum-fr1.scalingo.com`
   - (the SSH user is always `git` and the SSH port is always `22`)

   The output should stay blank
4. The database is now reachable from `127.0.0.1` on `local_port`

#### Enabling Direct Access Over Internet

{% warning %}
For various security reasons, we strongly discourage exposing databases on the
Internet. This is often considered a bad practice. Consequently, we do not
recommend activating Internet Accessibility.
{% endwarning %}

1. Make sure [you have TLS enforced]({% post_url databases/postgresql/2000-01-01-connecting %}#enforcing-tls-connection)
2. From your web browser, [open your database dashboard]({% post_url databases/postgresql/2000-01-01-getting-started %}#accessing-the-scalingo-for-postgresql-dashboard)
3. Select the **Overview** tab
4. Locate the **TLS/Internet Access** block
5. Enable the **Internet Accessibility** option
6. The database is now available using the corresponding [connection URI]({% post_url databases/postgresql/2000-01-01-connecting %})

### Using pgAdmin

pgAdmin is probably the most popular and feature rich administration and
development platform for PostgreSQL®. It's open-source, it supports many
platforms and comes with a Graphical User Interface, making it a reference tool
for PostgreSQL®.

#### Accessing Through a DB Tunnel

1. [Create a DB tunnel](#using-our-command-line-tool) to make the database
   reachable from the computer running pgAdmin
2. Once the connection established, open pgAdmin
3. Select the **Dashboard** tab
4. Click the **Add New Server** shortcut
5. In the new window, select the **General** tab and give a name to the server:
   {% assign img_url = "https://cdn.scalingo.com/documentation/screenshot_database_postgresql_pgadmin1.png" %}
   {% include mdl_img.html %}
6. Select the **Connection** tab and fill the required information:
   - Host name/address is now `127.0.0.1`
   - Port is most probably `10000`, unless you set it to something else
   - Username and Password must be gathered from the connection URI
   {% assign img_url = "https://cdn.scalingo.com/documentation/screenshot_database_postgresql_pgadmin2.png" %}
   {% include mdl_img.html %}
7. Click the **Save** button

#### Accessing Through SSH

pgAdmin also allows to connect to the database through an SSH tunnel, like
described [above](#using-openssh).

1. Open pgAdmin
2. Select the **Dashboard** tab
3. Click the **Add New Server** shortcut
4. In the new window, select the **General** tab and give a name to the server:
   {% assign img_url = "https://cdn.scalingo.com/documentation/screenshot_database_mongo_force_tls.png" %}
   {% include mdl_img.html %}
5. Select the **Connection** tab and fill in the required information from the
   connection URI:
   {% assign img_url = "https://cdn.scalingo.com/documentation/screenshot_database_mongo_force_tls.png" %}
   {% include mdl_img.html %}
6. Select the **SSH Tunnel** tab and toggle the **Use SSH tunneling** option
7. Fill in the required information:
   - Tunnel host depends on your region:
     - For osc-fr1: `ssh.osc-fr1.scalingo.com`
     - For osc-secnum-fr1: `ssh.osc-secnum-fr1.scalingo.com`
   - Tunnel port must be set to `22`
   - Username is always `git`
   - Authentication: chose `Identity file` and select the SSH key linked to your
     Scalingo account in the Identity file field
   - Password: your SSH key password, if any
   {% assign img_url = "https://cdn.scalingo.com/documentation/screenshot_database_mongo_force_tls.png" %}
   {% include mdl_img.html %}
7. Click the **Save** button

