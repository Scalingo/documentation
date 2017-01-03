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

You can first start a one-off container of your application:

```bash
$ scalingo --app sample-influxdb run bash
-----> Connecting to container [one-off-7647]...  
-----> Process 'bash' is starting...  

[00:00] Scalingo ~ $ 
```

Then, in order to get the backup files in this container, you need to copy the link of the backup from the database dashboard. Download it and extract it:

```bash
[00:00] Scalingo ~ $ mkdir /tmp/influxdb-backup
[00:00] Scalingo ~ $ wget https://db.scalingo.io/api/databases/XXXXXXX/backups/XXXXXXX/archive -P /tmp/influxdb-backup -O backup.tar.gz
[00:00] Scalingo ~ $ tar xvfz /tmp/influxdb-backup/backup.tar.gz -C /tmp/influxdb-backup
```

Now, you need to restore both the database and the metastore:

```bash
[00:00] Scalingo ~ $ influxd restore -metadir /var/lib/influxdb/meta -datadir /var/lib/influxdb/data -database <db-name> /tmp/influxdb-backup

Using metastore snapshot: meta.00
Restoring from backup <db-name>.*
unpacking /var/lib/influxdb/data/<db-name>/default/2/000000081-000000003.tsm
[...]
unpacking /var/lib/influxdb/data/<db-name>/default/1/000000081-000000001.tsm
```
