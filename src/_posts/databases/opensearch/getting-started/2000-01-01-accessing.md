---
title: Accessing Your Scalingo for OpenSearch® database
nav: Accessing
modified_at: 2025-09-05 12:00:00
tags: databases opensearch addon
index: 3
---


Remotely accessing your Scalingo for OpenSearch® database can sometimes be
useful, for example, to conduct investigations, to check or compute data
locally, to dump the database content, etc.

We provide several ways to access your database remotely. Chosing one mostly
depends on your needs and preferences.

{% note %}
**OpenSearch® is a RESTful service**, which means it exposes a REST API over
HTTP. Consequently, OpenSearch® does not require a specific driver or SDK to
work with.\
Instead, any tool speaking HTTP can be used to interact with the database:
- [`curl`](https://curl.se/) is usually a very good candidate to work with from
  the command line,
- [Postman](https://www.postman.com/) can be useful for debugging or building
  API calls,
- any programming language that can make HTTP requests (Go, Java, Javascript,
  PHP, Python, Ruby, etc.) are able to connect to an OpenSearch® database. Most
  of them provide libraries to ease things.
{% endnote %}


## Using a One-Off

1. [Start a one-off container][one-off]
2. From the command line, use `curl` (or any other tool able to communicate
   through HTTP) to query the database. For example:
   ```bash
   curl $SCALINGO_OPENSEARCH_URL
   ```
   The output should look like this:
   ```text
   {
     "name" : "3ed4f8a8-a7b8-4bd6-a2a5-e139befaf20d.my-app-4553.opensearch.a.osc-fr1.scalingo-dbs.com",
     "cluster_name" : "my-app-4553",
     "cluster_uuid" : "F22ZsuhSTp6boW-HlMWuqB",
     "version" : {
       "distribution" : "opensearch",
       "number" : "2.19.3",
       "build_type" : "tar",
       "build_hash" : "a90f864b8524bc75570a8461ccb569d2a4bfed42",
       "build_date" : "2025-07-21T22:34:18.003652598Z",
       "build_snapshot" : false,
       "lucene_version" : "9.12.2",
       "minimum_wire_compatibility_version" : "7.10.0",
       "minimum_index_compatibility_version" : "7.0.0"
     },
     "tagline" : "The OpenSearch Project: https://opensearch.org/"
   }
   ```


## Using Third Party Tools

By default, and for security reasons, your OpenSearch® database is not directly
accessible from the Internet and therefore not directly usable with your
third-party tool of choice.

To access your database remotely you first need to [make it reachable over the
Internet](#making-the-database-reachable-over-internet):
- either locally, on your computer, via an [encrypted tunnel](#using-our-command-line-tool)
- or from any location, by [enabling direct Internet access](#enabling-direct-access-over-internet).

Once a secured connection has been established, you should be able to connect
to your database with your preferred tool. If you don't have one yet, we
suggest you to [take a look at Postman][postman] or [curl][curl].

###  Making the Database Reachable Over Internet

#### Using Our Command Line Tool

Our command line tool provides a `db-tunnel` command that creates an SSH
encrypted tunnel between the computer running the command and our platform,
allowing remote secured access to your OpenSearch® addon.

1. Make sure you have correctly [setup the Scalingo command line tool][cli]
2. Make sure you have correctly [setup SSH authentication][ssh] on your
   Scalingo account
3. From the command line, open the tunnel using this command:
   ```bash
   scalingo --app my-app db-tunnel SCALINGO_OPENSEARCH_URL
   ```
   The output should look like this:
   ```text
   Building tunnel to my-app-4553.opensearch.a.osc-fr1.scalingo-dbs.com:33712
   You can access your database on:
   127.0.0.1:10000
   ```
4. The database is now reachable from `127.0.0.1` on port `10000`
5. To specify the port number to bind to (default is `10000`), use the `--port`
   option:
   ```bash
   scalingo --app my-app db-tunnel --port 12345 SCALINGO_OPENSEARCH_URL
   ```
6. To close the tunnel, use the keyboard shortcut `CTRL`+`C`:
   ```text
   ^Cinterrupt catched, aborting…
   ```

#### Using OpenSSH

Our command line tool [handles it in a single command](#using-our-command-line-tool),
but you might want to create a tunnel without it. With the standard OpenSSH
client, the way to build the tunnel is:

1. Identify the [connection URI][connecting-uri1] for your database
2. Make sure to [understand how the connection URI is built][connecting-uri2]
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

1. Make sure [you have TLS enforced][connecting-tls]
2. From your web browser, [open your database dashboard][db-dashboard]
3. Select the **Settings** tab
4. In the **Settings** submenu, select **Internet Access**
5. Locate the **Internet Accessibility** block
6. Click the **Enable** button
7. The database is now available using the corresponding [connection URI][connecting]


[postman]: https://www.postman.com/
[curl]: https://curl.se/

[cli]: {% post_url tools/cli/2000-01-01-start %}
[ssh]: {% post_url platform/getting-started/2000-01-01-first-steps %}
[one-off]: {% post_url platform/app/2000-01-01-tasks %}
[db-dashboard]: {% post_url databases/opensearch/getting-started/2000-01-01-connecting %}#accessing-the-opensearch-dashboard
[connecting]:      {% post_url databases/opensearch/getting-started/2000-01-01-connecting %}
[connecting-uri1]: {% post_url databases/opensearch/getting-started/2000-01-01-connecting %}#getting-the-connection-uri
[connecting-uri2]: {% post_url databases/opensearch/getting-started/2000-01-01-connecting %}#understanding-the-connection-uri
[connecting-tls]:  {% post_url databases/opensearch/getting-started/2000-01-01-connecting %}#enforcing-tls-connection
