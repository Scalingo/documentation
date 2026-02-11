---
title: Backing Up Your Scalingo for PostgreSQL® Shared Resources Database
nav: Backing Up
modified_at: 2025-10-20 12:00:00
tags: databases postgresql addon how-to
index: 5
---


Starter and Business plans of Scalingo for PostgreSQL® include automated and
managed backups so you don't have to worry about them.

With Scalingo for PostgreSQL®, we use two main mechanisms to create these
automated backups:
- [Point-in-Time Recovery][backup-policies-pitr] backups, and
- [Scheduled][backup-policies-scheduled] backups.

[Manual backups][backup-policies-manual] are also available for these plans.

{% note %}
**Please carefully read our [backup policies][backup-policies] for details
about backups retention and important considerations regarding backups.**
{% endnote %}


## Point-in-Time Recovery Backups

### Creating a Point-in-Time Recovery Backup

Point-in-Time Recovery backups are automatically created by the platform.

### Configuring Point-in-Time Recovery Backups

You have nothing to do to be able to use the Point-in-Time Recovery mechanism.


## Scheduled Backups

### Creating a Scheduled Backup

Scheduled backups are automatically created by the platform.

### Configuring Scheduled Backups

By default, Scheduled backups are done around 1:00 AM Central European Time
(CET or UTC+0100). This time can be modified.

{% note %}
The scheduled time is not strongly enforced: it might get delayed depending on
the workload on our infrastructure.
{% endnote %}

#### Using the Database Dashboard

1. From your web browser, open your [database dashboard][database-dashboard]
2. Click the **Backups** tab
3. Locate the **Backup schedule** block
4. Click the **Schedule** button
5. Make sure to check the **I want to enable scheduled backups** checkbox
6. Pick an hour (**timezone is UTC**)
7. Validate by clicking the **Update** button

#### Using the Command Line

1. Make sure you have correctly [setup the Scalingo command line tool][cli]
2. From the command line, configure the time of backup:
   - By setting an hour:
     ```bash
     scalingo --app my-app --addon postgresql backups-config --schedule-at 3
     ```
     In this example, we ask the platform to create the backups at ~03:00.
   
     _Note: The timezone used is the local timezone of the machine running the command._
   - By setting an hour and a timezone:
     ```bash
     scalingo --app my-app --addon postgresql backups-config --schedule-at "4:00 UTC"
     ```
     In this example, we ask the platform to create the backup at ~04:00 UTC.

   The output should look like this:
   ```text
   -----> Periodic backups will be done daily at 6:00 CET
   ```

### Downloading a Scheduled Backup

#### Using the Database Dashboard

1. From your web browser, open your [database dashboard][database-dashboard]
2. Click the **Backups** tab
3. Locate the **Backups** block
4. Locate the Scheduled backup you are interested in
5. Click the corresponding **Download** button

#### Using the Command Line

1. From the command line, run the following command(s):
   - To download the latest backup available:
     ```bash
     scalingo --app my-app --addon postgresql backups-download
     ```
     The output should look like this:
     ```text
     -----> Selected the most recent successful backup
     139.37 KiB / 139.37 KiB [----------------------------------] 100.00% ? p/s
     ===> 20231207000608_my_app_4553.tar.gz
     ```
     The backup is downloaded in your current working directory.
   - To download a specific backup:
     1. List the backups available for this database addon:
        ```bash
        scalingo --app my-app --addon postgresql backups
        ```
        The output should look like this:
        ```text
        +--------------------------+--------------------------------+--------+--------+
        |            ID            |           CREATED AT           |  SIZE  | STATUS |
        +--------------------------+--------------------------------+--------+--------+
        | 65710b0a99c3cd23d455edee | Thu, 07 Dec 2023 01:00:10 CET  | 143 kB | done   |
        | 656fb98b99c3cd23d455d4e7 | Wed, 06 Dec 2023 01:00:11 CET  | 143 kB | done   |
        | 656e680a99c3cd23d455c1f0 | Tue, 05 Dec 2023 01:00:10 CET  | 143 kB | done   |
        ...
        ```
     2. Locate the `ID` of the backup you want to download
     3. Download the backup:
        ```bash
        scalingo --app my-app --addon postgresql backups-download --backup <backup_ID>
        ```
        The output should look like this:
        ```text
        79.10 KiB / 79.10 KiB [---------------------------------] 100.00% ? p/s
        ===> 20230305000044_my_app_4553.tar.gz
        ```
        The backup is downloaded in your current working directory.


## Manual Backups

### Creating a Manual Backup

#### Using the Database Dashboard

1. From your web browser, open your [database dashboard][database-dashboard]
2. Click the **Backups** tab
3. Locate the **Backups** block
4. Click the **Trigger manual backup** button

#### Using the Command Line

1. Make sure you have correctly [setup the Scalingo command line tool][cli]
2. Ask the platform to backup the database:
   ```bash
   scalingo --app my-app --addon postgresql backups-create
   ```
   After a while, the output should look like this:
   ```text
   -----> Backup successfully finished
   ```

### Downloading a Manual Backup

Please refer to [Downloading a Scheduled Backup](#downloading-a-scheduled-backup)
section, as the process is exactly the same.


## Dumping the Database

There are different ways to dump (and restore) a PostgreSQL® database. We
generally advise to either:
- Process from a [one-off container](#from-a-one-off-container)
- Or conduct the operations [from your workstation](#from-your-workstation), by
  accessing the database in a secured manner

### From a One-Off Container

This method has two main advantages:
- It doesn't require to make your database reachable over Internet
- You won't have to tweak your connection URI

1. Follow the procedure to [access your PostgreSQL® database from a one-off
   container][accessing-one-off]
2. Make sure to [understand the connection URI][connecting-uri]
3. Dump the database:
   ```bash
   pg_dump --clean --if-exists --format c --dbname "${SCALINGO_POSTGRESQL_URL}" --no-owner --no-privileges --no-comments --exclude-schema 'information_schema' --exclude-schema '^pg_*' --file dump.pgsql
   ```

{% note %}
The dump is lost as soon as you exit the one-off container. Consequently, you
have to do something with it in the one-off (for example, you could upload it
somewhere).
{% endnote %}

### From Your Workstation

1. [Open a DB tunnel][accessing-cli]
   so you can access your database from your workstation
2. Create a local variable to store the [connection URI][connecting-uri]:
   ```bash
   export SCALINGO_DB_URL="postgresql://<user>:<password>@127.0.0.1:<port>/<dbname>"
   ```
   With `user`, `password` and `dbname` from your original connection URI and
   `port` depending on what you did (default is `10000`)
3. Dump the database using the `pg_dump` command (you may have to install it):
   ```bash
   pg_dump --clean --if-exists --format c --dbname "${SCALINGO_DB_URL}" --no-owner --no-privileges --no-comments --exclude-schema 'information_schema' --exclude-schema '^pg_*' --file dump.pgsql
   ```


[cli]: {% post_url tools/cli/2000-01-01-start %}

[backup-policies]: {% post_url databases/about/2000-01-01-backup-policies %}
[backup-policies-manual]: {% post_url databases/about/2000-01-01-backup-policies %}#manual-backups
[backup-policies-pitr]: {% post_url databases/about/2000-01-01-backup-policies %}#point-in-time-recovery-backups
[backup-policies-scheduled]: {% post_url databases/about/2000-01-01-backup-policies %}#scheduled-backups

[database-dashboard]: {% post_url databases/postgresql/shared-resources/getting-started/2000-01-01-provisioning %}#accessing-the-scalingo-for-postgresql-dashboard
[accessing-one-off]: {% post_url databases/postgresql/shared-resources/getting-started/2000-01-01-accessing %}#using-a-one-off
[accessing-cli]: {% post_url databases/postgresql/shared-resources/getting-started/2000-01-01-accessing %}#using-our-command-line-tool
[connecting-uri]: {% post_url databases/postgresql/shared-resources/getting-started/2000-01-01-connecting %}#understanding-the-connection-uri
