---
title: How to dump and restore my InfluxDB database on Scalingo
modified_at: 2017-02-06 18:04:00
category: influxdb
tags: restore sump-restore influxdb databases addons
---

{% include info_command_line_tool.md %}

Scalingo handles daily backup for any paying plan. Unfortunately it is not possible for you to
dump your data remotely from your local workstation. Refer to the "Why you cannot manage the 
backups for InfluxDB on Scalingo" section for more details about the technical reasons.

## Restore on your local workstation

Daily backups done by Scalingo are listed in the database specific dashboard:

1. Go to your app on [Scalingo Dashboard](https://my.scalingo.com/apps)
2. Click on **Addons** tab
3. Click **Link to dashboard** which will take you to the **Scalingo InfluxDB dashboard**
4. Click on **Backups** tab
5. Download the backup you want

{% assign img_url = "/assets/images/database/influxdb-backups.png" %}
{% include mdl_img.html %}

### Restore

You can restore your data on your local environment if needed. Download a backup on your database
dashboard. It is a **.tar.gz** containing a dump of your database which has been
done following the instructions from the [InfluxDB 
documentation](https://docs.influxdata.com/influxdb/v1.2/administration/backup_and_restore/).
Before starting the restore process, you need to stop the InfluxDB daemon. Then just type 
the following commands:

```bash
$ tar xfz /path/to/backup.tar.gz
$ influxd restore -metadir /var/lib/influxdb/meta/ ./
$ influxd restore -database my-db -datadir /var/lib/influxdb/data/ ./
```

Note that `/var/lib/influxdb` is the default folder for a Linux installation. You need to modify it
depending on your configuration.

If you need to restore a backup on your Scalingo server, please contact our support at support@scalingo.com.

## Why you cannot manage the backups for InfluxDB on Scalingo

Unfortunately, backing up and restoring your data from the InfluxDB on Scalingo is not possible
remotely. The problem is that the port used to make backup is different than the port used for the
InfluxDB console. The remote backup port is not authenticated with a username and a password. Hence
we do not want it to be exposed over Internet. 

Moreover, to restore your data on InfluxDB, the InfluxDB daemon must be stopped. This action is not
possible on Scalingo.
