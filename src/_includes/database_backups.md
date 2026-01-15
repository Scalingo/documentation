We automatically make periodic backups of your database on a daily basis, at around 1:00 AM Central European Time (CET or UTC+0100). The time of your daily backup is configurable via the web dashboard of your database or using the CLI. The scheduled date is not strongly enforced: it might get delayed depending on the load on our infrastructure.

#### Using the Database Dashboard

1. From your web browser, open your database dashboard
2. Click the **Backups** tab
3. Locate the **Backup schedule** block
4. Click the **Schedule** button
5. Make sure to check the **I want to enable scheduled backups** checkbox
6. Pick an hour (**timezone is UTC**)
7. Validate by clicking the **Update** button

#### Using the Command Line

1. Make sure you have correctly [setup the Scalingo command line tool]({% post_url tools/cli/2000-01-01-start %})
2. Configure the time of backup:
   - By setting an hour:
     ```bash
     scalingo --app my-app --addon [YOUR ADDON KIND] backups-config --schedule-at 3
     ```
     In this example, we ask the platform to create the backups at ~03:00.
     _Note: The timezone used is the local timezone of the machine running the command._
   - By setting an hour and a timezone:
     ```bash
     scalingo --app my-app --addon [YOUR ADDON KIND] backups-config --schedule-at "4:00 UTC"
     ```
     In this example, we ask the platform to create the backup at ~04:00 UTC.
     The output should look like this:
     ```text
     -----> Periodic backups will be done daily at 6:00 CET
     ```

### Retention Policy for Daily Backups

We keep a limited amount of backups depending on your database plan. A daily backup is retained for the last 7 days. That means that 7 backups will exist, one for each of the last 7 days. A weekly backup means that only one backup is saved over a 7 days period. A monthly backup means that only 1 backup is saved over the course of a month.

<div class="overflow-horizontal-content" markdown="1">
| Plan         | Weekly Backups Retained | Monthly Backup Retained |
| -------------| ----------------------- | ----------------------- |
| Starter      | 4 weeks                 | 0 months                |
| Business     | 8 weeks                 | 12 months               |
 {: .table }
</div>

### Retention Policy for Manual Backups

You can also manually trigger a backup for your database at any time you want.
The number of manual backups that you can retain is limited by your plan:

<div class="overflow-horizontal-content" markdown="1">
| Plan         | Backups Retained |
| -------------| ---------------- |
| Starter      | 10               |
| Business     | 50               |
 {: .table }
 </div>

In case a database is removed from an application, the retention policy remains untouched: backups are **not** instantly deleted.

#### Creating a Manual Backup

##### Using the Database Dashboard

1. From your web browser, open your database dashboard
2. Click the **Backups** tab
3. Locate the **Backup Settings** block
4. Click the **Make Manual Backup** button
3. Locate the **Backups** block
4. Click the **Trigger manual backup** button

##### Using the Command Line

1. Make sure you have correctly [setup the Scalingo command line tool]({% post_url tools/cli/2000-01-01-start %})
2. Ask the platform to backup the database:
   ```bash
   scalingo --app my-app --addon [YOUR ADDON KIND] backups-create
   ```
   After a while, the output should look like this:
   ```text
   -----> Backup successfully finished
   ```
