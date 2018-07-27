---
title: Restore your database backup
modified_at: 2018-07-27 00:00:00
tags: databases backups
---

If your database is in a paid plan (i.e. it's not "free plan"), Scalingo makes automated backups of
your database on a daily basis. During your application lifetime, you might feel the need to restore
your database at a previous state. We will guide you through the different steps to download a
specific backups and restore the database with its content.

As an example we use a MongoDB database but these instructions do not differ a lot for different
databases.

### Download Automated Backups

Automated backups are listed in the database specific dashboard.

1. Go to your app on [Scalingo Dashboard](https://my.scalingo.com/apps)
2. Click on **Addons** tab
3. Click **Dashboard <i class="material-icons">open_in_new</i>** which will take you to the **MongoDB dashboard**
4. Click on **Backups** tab
5. Download the backup you want

{% assign img_url = "https://cdn.scalingo.com/documentation/screenshot_database_mongo_backups.png" %}
{% include mdl_img.html %}

### Restore the Backup

{% include info_command_line_tool.md %}

We now start a [one-off container]({% post_url platform/app/2000-01-01-tasks%}) and upload the
downloaded backup into it:

```
$ scalingo -a my-app run --file 20180727110302_my-app-3519.tar.gz bash
```

The file is uploaded to the `/tmp/uploads` directory. Extract the content of the archive in
the one-off:

```
[one-off] $ tar xvfz /tmp/uploads/20180727110302_my-app-3519.tar.gz
```

Then restore the backup:

```
[one-off] $ mongorestore -u <username> -p <password> -h <host>:<port> -d <db> ./my-app-3519
```

{% note%}
You might need a different version of the database CLI tool, depending on the version of your
database. You can download a specific version of the database CLI tool with:

```
$ dbclient-fetcher mongo 3.6
```
{% endnote %}
