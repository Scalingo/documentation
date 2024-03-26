---
title: Backing Up Your Scalingo for PostgreSQL® Addon
nav: Backing Up
modified_at: 2024-03-26 12:00:00
tags: databases postgresql addon
index: 8
---


Starter and Business plans of Scalingo for PostgreSQL® include automated and
managed backups so you don't have to worry about them.

We use two kinds of mechanisms to create these automated backups:
[Point-in-Time Recovery](#understanding-point-in-time-recovery) backups and
[Periodic](#understanding-periodic-backups) backups. [Manual backups](#understanding-manual-backups)
are also available for these plans.


## Understanding Point-in-Time Recovery Backups

Point-in-time recovery (PiTR) allows you to ask for the restoration of your
data at a specific date. We achieve this by making a full PiTR backup of the
database weekly. Between two full PiTR backups, we keep track of the
write-ahead logs (WAL). The WAL contains all the modification instructions. By
replaying the WAL from a full PiTR backup to a specific date, we are able to
rebuild the state of the database at that particular date.

You have nothing to do to be able to use the PiTR mechanism. Be aware that you
can only use the PiTR on the period between now and now minus seven days.

### Retention Policy for PiTR Backups

| Plan     | PiTR Backup Retained |
| -------- + -------------------- |
| Sandbox  | N/A                  |
| Starter  | 1                    |
| Business | 1                    |


## Understanding Periodic Backups

Periodic backups are done on a daily basis. They consist in dumping your
database in an archive that we keep during a certain amount of time.

For Business plans, the backup is done on the secondary node to avoid any
impact on your primary node.

### Retention Policy for Periodic Backups

We keep a limited amount of backups depending on your database plan:
- A daily backup is retained for the last 7 days, which means that we will keep
  a maximum of 7 daily backups (one for each of the last 7 days).
- A weekly backup means that only one backup is saved over a 7 days period.
- A monthly backup means that only one backup is saved over the course of a
  month.

<div class="overflow-horizontal-content" markdown="1">
| Plan     | Weekly Backups Retained | Monthly Backups Retained |
| -------- + ----------------------- + ------------------------ |
| Sandbox  | N/A                     | N/A                      |
| Starter  | 4 weeks                 | 0 month                  |
| Business | 8 weeks                 | 12 months                |
 {: .table }
 </div>

### Configuring Periodic Backups

By default, Periodic backups are done around 1:00 AM Central European Time
(CET or UTC+0100). This time can be modified.

{% note %}
The scheduled time is not strongly enforced: it might get delayed depending on
the workload on our infrastructure.
{% endnote %}

#### Using the Database Dashboard

1. From your web browser, open your [database dashboard]({% post_url databases/postgresql/2000-01-01-getting-started %}#accessing-the-scalingo-for-postgresql-dashboard)
2. Click the **Backups** tab
3. Locate the **Backup Settings** block
4. Make sure the **Periodic backups** toggle is set to `enabled`
5. Chose the time and select the timezone
6. Click the **Set** button to validate

#### Using the Command Line

1. Make sure you have correctly [setup the Scalingo command line tool]({% post_url platform/cli/2000-01-01-start %})
2. From the command line, configure the time of backup:
   - By setting an hour:
     ```bash
     scalingo --app my-app --addon postgresql backups-config --schedule-at 3
     ```
     In this example, we ask the platform to create the backups at ~03:00 CET.
   - By setting an hour and a timezone:
     ```bash
     scalingo --app my-app --addon postgresql backups-config --schedule-at "4:00 UTC"
     ```
     In this example, we ask the platform to create the backup at ~04:00 UTC.

   The output should look like this:
   ```text
   -----> Periodic backups will be done daily at 6:00 CET
   ```

### Downloading a Periodic Backup

#### Using the Database Dashboard

1. From your web browser, open your [database dashboard]({% post_url databases/postgresql/2000-01-01-getting-started %}#accessing-the-scalingo-for-postgresql-dashboard)
2. Click the **Backups** tab
3. Locate the **Backups** block
4. Locate the Periodic backup you are interested in
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


## Understanding Manual Backups

Manual backups use the exact same mechanism as Periodic backups, except that
they are not automated. As the name suggests, Manual backups are triggered
manually, whenever you want.

### Retention Policy for Manual Backups

We keep a limited amount of Manual backups depending on your database plan:

<div class="overflow-horizontal-content" markdown="1">
| Plan         | Backups Retained |
| ------------ + ---------------- |
| Sandbox      | N/A              |
| Starter      | 10               |
| Business     | 50               |
{: .table }
</div>

When a database is removed from an application, the retention policy remains
untouched: backups are **not** instantly deleted.

### Creating a Manual Backup

#### Using the Database Dashboard

1. From your web browser, open your [database dashboard]({% post_url databases/postgresql/2000-01-01-getting-started %}#accessing-the-scalingo-for-postgresql-dashboard)
2. Click the **Backups** tab
3. Locate the **Backup Settings** block
4. Click the **Make Manual Backup** button

#### Using the Command Line

1. Make sure you have correctly [setup the Scalingo command line tool]({% post_url platform/cli/2000-01-01-start %})
2. Ask the platform to backup the database:
   ```bash
   scalingo --app my-app --addon postgresql backups-create
   ```
   After a while, the output should look like this:
   ```text
   -----> Backup successfully finished
   ```

### Downloading a Manual Backup

Please refer to [Downloading a Periodic Backup](#downloading-a-periodic-backup)
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
   container]({% post_url databases/postgresql/2000-01-01-accessing %}#using-a-one-off)
2. Make sure to [understand the connection URI]({% post_url databases/postgresql/2000-01-01-connecting %}#understanding-the-connection-uri)
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

1. [Open a DB tunnel]({% post_url databases/postgresql/2000-01-01-accessing %}#using-our-command-line-tool)
   so you can access your database from your workstation
2. Adjust the [connection URI]({% post_url databases/postgresql/2000-01-01-connecting %}#understanding-the-connection-uri):
   ```bash
   export SCALINGO_DATABASE_URL="postgresql://<user>:<password>@127.0.0.1:<port>/<dbname>"
   ```
   With `user`, `password` and `dbname` from your original connection URI and
   `port` depending on what you did (default is `10000`)
3. Dump the database using the `pg_dump` command (you may have to install it):
   ```bash
   pg_dump --clean --if-exists --format c --dbname "${SCALINGO_POSTGRESQL_URL}" --no-owner --no-privileges --no-comments --exclude-schema 'information_schema' --exclude-schema '^pg_*' --file dump.pgsql
   ```
