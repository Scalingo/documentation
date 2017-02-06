---
title: Restore locally an InfluxDB backups
modified_at: 2016-12-28 00:00:00
category: databases
tags: databases influxdb backups
---

## Download the backup file

Go to your database dashboard, in the *Backups* tab and download the last dump
you want to restore locally.

The archive is a **.tar.gz** containing a dump of your database which has been
done following the instructions from the [InfluxDB documentation](https://docs.influxdata.com/influxdb/v1.2/administration/backup_and_restore/).

## Restoring backup

You can restore your database locally following the instructions in the
[InfluxDB documentation](https://docs.influxdata.com/influxdb/v1.2/administration/backup_and_restore/#restore).

If you need to restore your database at a previous state on Scalingo, contact our support team at support@scalingo.com.
Unfortunately, you cannot do it by yourself as the `influxd restore` command does not allow yet to
[specify a remote host](https://docs.influxdata.com/influxdb/v1.2/administration/backup_and_restore/#restore).
