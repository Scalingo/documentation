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
done following the instructions from [InfluxDB documentation](https://docs.influxdata.com/influxdb/v1.1/administration/backup_and_restore/).

## Restoring backup

It is not yet possible for you to restore a backup of your database as the `influxd restore` command
does not allow to [specify a remote host](https://docs.influxdata.com/influxdb/v1.1/administration/backup_and_restore/#restore).
If you need to restore a backup, contact our support at support@scalingo.com.
