---
title: How to dump and restore my Scalingo for InfluxDB® database on Scalingo
nav: Dump and Restore
modified_at: 2017-02-06 18:04:00
index: 2
---

{% include info_command_line_tool.md %}

Scalingo handles daily backup for any paying plan. Unfortunately it is not
possible for you to dump your data remotely from your local workstation. Refer
to the
<a href="#why-you-cannot-manage-the-backups-for-influxdb-on-scalingo">Why you
cannot manage the backups on Scalingo for InfluxDB®</a> section for more details
about the technical reasons.

## Restore on your local workstation

Daily backups done by Scalingo are listed in the database specific dashboard:

1. Go to your app on [Scalingo Dashboard](https://dashboard.scalingo.com/apps)
2. Click on **Addons** tab
3. Click **Link to dashboard** which will take you to the **Scalingo for InfluxDB® dashboard**
4. Click on **Backups** tab
5. Download the backup you want

### Restore

Note: if you need to restore a backup on your Scalingo for InfluxDB®, please contact our
support at [support@scalingo.com](mailto:support@scalingo.com).

You can restore your data on your local environment if needed. Download a backup on your database
dashboard. It is a **.tar.gz** containing a dump of your database which has been
done following the instructions from the [InfluxDB®
documentation](https://docs.influxdata.com/influxdb/v1.2/administration/backup_and_restore/).

#### With InfluxDB® 1.6 and lower

Before starting the restore process, you need to stop the InfluxDB® daemon. Then type
the following commands:

```bash
$ tar xfz /path/to/backup.tar.gz
$ influxd restore -metadir /var/lib/influxdb/meta/ ./
$ influxd restore -database my-db -datadir /var/lib/influxdb/data/ ./
```

Note that `/var/lib/influxdb` is the default folder for a Linux installation. You need to modify it
depending on your configuration.

#### With InfluxDB® 1.7 and later

Note InfluxDB® daemon needs to be up and running

```bash
$ tar xfz /path/to/backup.tar.gz --strip-components 1
$ influxd restore -portable -db my-db-name -new-db new-db-name ./
```


## Why you cannot manage the backups on Scalingo for InfluxDB®

Unfortunately, backing up and restoring your data on Scalingo for InfluxDB® is not possible
remotely. The problem is that the port used to make backup is different than the port used for the
InfluxDB® console. The remote backup port is not authenticated with a username and a password. Hence
we do not want it to be exposed over the Internet.

Moreover, to restore your data on Scalingo for InfluxDB®, the InfluxDB® daemon must be stopped. This action is not
possible on Scalingo.
