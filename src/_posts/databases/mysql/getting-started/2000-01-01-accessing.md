---
title: Accessing Your Scalingo for MySQL® database
nav: Accessing
modified_at: 2025-09-24 12:00:00
tags: databases mysql addon
index: 3
---


Remotely accessing your Scalingo for MSQL® database can sometimes be useful,
for example, to conduct investigations, to check or compute data locally, to
dump the database content,...

We provide several ways to access your database remotely. Chosing one mostly
depends on your needs and preferences.

## Using the Interactive Remote Console

1. Make sure you have correctly [setup the Scalingo command line tool][cli]
2. From the command line, open a console for your MySQL® addon:
   ```bash
   scalingo --app my-app mysql-console
   ```
   The output should look like this:
   ```bash
   -----> Starting container one-off-7872  Done in 0.479 seconds
   -----> Connecting to container [one-off-7872]...
   -----> Process 'mysql-console my_app_4553' is starting...

   ---> Download and extract the database CLI
   ---> Database CLI installed:
   mysql  Ver 8.0.33 for Linux on x86_64 (Source distribution)
   mysql: [Warning] Using a password on the command line interface can be insecure.
   Welcome to the MySQL monitor.  Commands end with ; or \g.
   Your MySQL connection id is 496
   Server version: 8.0.35 MySQL Community Server - GPL

   Copyright (c) 2000, 2023, Oracle and/or its affiliates.

   Oracle is a registered trademark of Oracle Corporation and/or its
   affiliates. Other names may be trademarks of their respective
   owners.

   Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

   mysql>
   ```
3. To exit, type the following command from the MySQL® console, or use the
   keyboard shortcut `CTRL`+`D`:
   ```bash
   \q
   ```


## Using a One-Off

1. [Start a one-off container][one-off]
2. From the command line, use our `dbclient-fetcher` helper to download and
   install a bunch of MySQL® tools:
   ```bash
   dbclient-fetcher mysql
   ```
   The output should look like this:
   ```text
   ---> Download and extract the database CLI
   ---> Database CLI installed:
   mysql  Ver 8.0.33 for Linux on x86_64 (Source distribution)
   ```
   If you ever need a specific version, just add it as a second parameter:
   ```bash
   dbclient-fetcher mysql 8
   ```
   The output should look like this:
   ```text
   ---> Download and extract the database CLI
   ---> Database CLI installed:
   mysql  Ver 8.0.35 for Linux on x86_64 (Source distribution)
   ```

   The `dbclient-fetcher` helper installs the following tools:
   - `mysql`
   - `mysqldump`
3. Connect to the database with the following command:
   ```bash
   mysql --user=$USER --password=$PASSWORD --host=$HOSTNAME --port=$PORT $DATABASE_NAME --ssl-mode=REQUIRED
   ```


## Using Third Party Tools

While using `mysql` to query and administer a MySQL® database is probably the
ubiquitous choice for a lot of users, it's not limited to that. The MySQL®
ecosystem indeed offers a very large panel of tools made and provided by
third-parties. For example, some might feel more intuitive because of their
Graphical User Interface. Some are better integrated with others tools, when
some others are more data-visualization centric.

By default, and for security reasons, your MySQL® database is not directly
accessible from the Internet and therefore not directly usable with your
third-party tool.

To access your database remotely you first need to [make it reachable over the
Internet](#making-the-database-reachable-over-internet):
- either locally, on your computer, via an [encrypted tunnel](#setting-up-an-encrypted-tunnel)
- or from any location, by [enforcing TLS connection][connecting-tls]
  and [enabling direct Internet access](#enabling-direct-access-over-internet).

Once a secured connection has been established, you should be able to connect
to your database with your tool of choice. If you don't have one yet, we
suggest you to take a look at [DBeaver](#using-dbeaver) or
[MySQL Workbench](#using-mysql-workbench).

###  Making the Database Reachable Over Internet

#### Using Our Command Line Tool

Our command line tool provides a `db-tunnel` command that creates an SSH
encrypted tunnel between the computer running the command and our platform,
allowing remote secured access to your MySQL® addon.

1. Make sure you have correctly [setup the Scalingo command line tool][cli]
2. Make sure you have correctly [setup SSH authentication][ssh]
   on your Scalingo account
3. From the command line, open the tunnel using this command:
   ```bash
   scalingo --app my-app db-tunnel SCALINGO_MYSQL_URL
   ```
   The output should look like this:
   ```text
   Building tunnel to my-app-4553.mysql.a.osc-fr1.scalingo-dbs.com:35581
   You can access your database on:
   127.0.0.1:10000
   ```
4. The database is now reachable from `127.0.0.1` on port `10000`
5. To specify the port number to bind to (default is `10000`), use the `--port`
   option:
   ```bash
   scalingo --app my-app db-tunnel --port 12345 SCALINGO_MYSQL_URL
   ```
6. To close the tunnel, use the keyboard shortcut `CTRL`+`C`:
   ```text
   ^Cinterrupt catched, aborting…
   ```

#### Using OpenSSH

Our command line tool [handles it in a single command](#using-our-command-line-tool),
but you might want to use the tunnel without it. With the standard OpenSSH
client, the way to build the tunnel is:

1. Identify the [connection URI][connecting-uri] for your database
2. Make sure to [understand how the connection URI is built][connecting-uri-understand]
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
2. From your web browser, [open your database dashboard][database-dashboard]
3. Select the **Settings** tab
4. In the **Settings** submenu, select **Internet Access**
5. Locate the **Internet Accessibility** block
6. Click the **Enable** button
7. The database is now available using the corresponding [connection URI][connecting]

### Using DBeaver

[DBeaver] is a free and open-source database tool allowing to manage multiple
database kinds, including MySQL®. It includes a carefully designed and
implemented User Interface, as well as a lot of features such as the ability to
execute SQL queries with autocompletion and syntax highlighting, the ability to
browse and edit database structure, data import/export, etc.

#### Accessing Through a DB Tunnel

1. [Create a DB tunnel](#using-our-command-line-tool) to make the database
   reachable from the computer running DBeaver
2. Once the connection established, open DBeaver
3. From the main menu, click the **New Connexion** button and select **MySQL**
   from the dropdown
4. In the new window, select the **Main** tab and fill the required
   information:
   - Server Host is now `127.0.0.1` or `localhost`
   - Port is most probably `10000`, unless you set it to something else
   - Database must be gathered from the [connection
     URI][connecting-uri-understand]
   - Username and Password must also be gathered from the [connection
     URI][connecting-uri-understand]
{% assign img_url = "https://cdn.scalingo.com/documentation/screenshot_documentation_dbeaver_01.png" %}
{% include mdl_img.html %}
{:start="5"}
5. Click the **Test Connection...** button at the bottom left to test that
   everything works as expected
6. Click the **Finish** button to save the connection configuration

#### Accessing Through SSH

DBeaver also allows to connect to the database through an SSH tunnel, like
described [above](#using-openssh).

1. Open DBeaver
2. From the main menu, click the **New Connexion** button and select **MySQL**
   from the dropdown
3. In the new window, select the **Main** tab and fill the required
   information:
     - Server Host, Port, Database, Username and Password must be gathered
       from the [connection URI][connecting-uri-understand]
{% assign img_url = "https://cdn.scalingo.com/documentation/screenshot_documentation_dbeaver_02.png" %}
{% include mdl_img.html %}
{:start="4"}
4. Select the **SSH** tab and toggle the **Use SSH Tunneling** option
5. Fill in the required information:
   - Tunnel host depends on your region:
     - For osc-fr1: `ssh.osc-fr1.scalingo.com`
     - For osc-secnum-fr1: `ssh.osc-secnum-fr1.scalingo.com`
   - Tunnel port must be set to `22`
   - Username is always `git`
   - Authentication Method: chose `Public Key`
   - Select the SSH private key linked to your Scalingo account
   - Set your SSH key passphrase, if any
{% assign img_url = "https://cdn.scalingo.com/documentation/screenshot_documentation_dbeaver_03.png" %}
{% include mdl_img.html %}
{:start="6"}
6. Click the **Test tunnel configuration** button to test the SSH connection
7. Click the **Test Connection...** button at the bottom left to test that
   the database is indeed reachable through the SSH tunnel
8. Click the **Finish** button to save the connection configuration

### Using MySQL Workbench

[MySQL Workbench] is a unified visual piece of software for database
architects, administrators and developers. Apart from the basic features such
as browsing and editing the database structure, importing and exporting data or
executing SQL queries with autocompletion and syntax highlighting, MySQL
Workbench also comes with functionalities that help identify and fix
performance issues.

#### Accessing Through a DB Tunnel

1. [Create a DB tunnel](#using-our-command-line-tool) to make the database
   reachable from the computer running MySQL Workbench
2. Once the connection established, open MySQL Workbench
3. From the welcome screen, click the little **+** button to create a new
   connection
4. In the new window, give a name to the connection
5. Fill in the required information:
   - Connection Method must be set to `Standard (TCP/IP)`
   - Hostname is `127.0.0.1` or `localhost`
   - Port is most probably `10000`, unless you set it to something else
   - Username and Password must be gathered from the [connection URI][connection-uri-understand]
   - Default Schema is the name of your database, which must also be gathered
     from the [connection URI][connecting-uri-understand]
{% assign img_url = "https://cdn.scalingo.com/documentation/screenshot_documentation_workbench_01.png" %}
{% include mdl_img.html %}
{:start="6"}
6. Click the **Test Connection** button at the bottom to test that everything
   works as expected
7. Click the **OK** button to save the connection configuration

#### Accessing Through SSH

MySQL Workbench also allows to connect to the database through an SSH tunnel,
like described [above](#using-openssh).

1. Open MySQL Workbench
2. From the welcome screen, click the little **+** button to create a new
   connection
3. In the new window, give a name to the connection
4. Fill in the required information:
   - SSH Hostname depends on your region:
     - For osc-fr1: `ssh.osc-fr1.scalingo.com:22`
     - For osc-secnum-fr1: `ssh.osc-secnum-fr1.scalingo.com:22`
   - SSH Username is always `git`
   - Chose the SSH Key File linked to your Scalingo account
   - MySQL Hostname, MySQL Server Port, Username and Password must be gathered
     from the [connection URI][connecting-uri-understand]
{% assign img_url = "https://cdn.scalingo.com/documentation/screenshot_documentation_workbench_02.png" %}
{% include mdl_img.html %}
{:start="5"}
5. Click the **Test Connection** button at the bottom to test that everything
   works as expected
6. Click the **OK** button to save the connection configuration


[DBeaver]: https://dbeaver.io/
[MySQL Workbench]: https://www.mysql.com/products/workbench/

[cli]: {% post_url tools/cli/2000-01-01-start %}
[ssh]: {% post_url platform/getting-started/2000-01-01-first-steps %}
[one-off]: {% post_url platform/app/2000-01-01-tasks %}

[connecting]: {% post_url databases/mysql/getting-started/2000-01-01-connecting %}
[connecting-uri-get]: {% post_url databases/mysql/getting-started/2000-01-01-connecting %}#getting-the-connection-uri
[connecting-uri-understand]: {% post_url databases/mysql/getting-started/2000-01-01-connecting %}#understanding-the-connection-uri
[connecting-tls]: {% post_url databases/mysql/getting-started/2000-01-01-connecting %}#enforcing-tls-connection
