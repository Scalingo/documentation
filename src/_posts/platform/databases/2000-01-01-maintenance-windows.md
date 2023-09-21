---
title: Database Maintenance Windows
nav: Maintenance Windows
modified_at: 2023-09-21 00:00:00
tags: databases maintenance
index: 0
---

Database Maintenance Windows is the Scalingo system scheduling the maintenance needed on your databases. It allows us to keep them secure and up-to-date, while letting you aware of the time period where they could be temporarily unavailable without impacting too much your application.

Each database has a default maintenance window set by Scalingo, that you can check in your database info. But you can now provide a eight hours time window where Scalingo can proceed to the maintenance of your database.

Moreover, it's also possible to schedule the maintenance when your app is less prone to high traffic (e.g. the night between Sunday and Monday). With those features, we have in mind the prevention of any undesired downtime of your app.

Planned Maintenance Windows are excluded from the SLA calculation.

### Configure Your Desired Database Maintenance Window

With the Scalingo CLI, the desired beginning period of your eight hours time window can be configured with the `addons-config` command:

```bash
# You are setting the window day to "monday", starting at 1AM
scalingo --app my-app addons-config --maintenance-window-day monday --maintenance-window-hour 1 addon-uuid
```

Setting this up allows Scalingo to proceed to their maintenance between 1AM and 9AM in your timezone. If you do configure your Database Maintenance Window to begin at 1AM, and your CLI is located at UTC-5, it will begin at 6AM UTC. You can check the time window you configured with the command `addons-info`:

```bash
scalingo --app my-app addons-info addon-uuid
```

### Check Past and Future Maintenance

To use the following commands in order to list planned and past maintenance on your database, specify the related application, and your database addon UUID:

```bash
scalingo --app my-app --addon addon-uuid database_maintenance_list
```

This command displays the list of the planned maintenance windows for your database.

You can, as well, get more details about a specific maintenance :

```bash
scalingo --app my-app --addon addon-uuid database_maintenance_info maintenance_uuid
```
