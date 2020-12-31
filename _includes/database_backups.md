If your database is in a paid plan (i.e. it's not "free plan"), we'll
automatically make periodic backups of your database on a daily basis, at around
1:00 AM Central European Time (CET or UTC+0100). The time of your daily backup
is configurable via the web dashboard of your database or using the CLI.

We keep a limited amount of backups depending on your database plan. A daily
backup is retained for the last 7 days. That means that 7 backups will exist,
one for each of the last 7 days. A weekly backup means that only one backup is
saved over a 7 days period. A monthly backup means that only 1 backup is saved
over the course of a month.

| Plan         | Weekly Backups Retained | Monthly Backup Retained |
| -------------| ----------------------- | ----------------------- |
| Sandbox/Free | N/A                     | N/A                     |
| Starter      | 4 weeks                 | 0 months                |
| Business     | 8 weeks                 | 12 months               |
 {: .table }

You can also manually trigger a backup for your database at any time you want.
The number of manual backups that you can retain is limited by your plan:

| Plan         | Backups Retained |
| -------------| ---------------- |
| Sandbox/Free | N/A              |
| Starter      | 10               |
| Business     | 50               |
 {: .table }

In case a database is removed from an application, the retention policy remains untouched: backups are **not** instantly deleted.
