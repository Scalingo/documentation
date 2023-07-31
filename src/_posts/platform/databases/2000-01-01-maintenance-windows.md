---
title: Database Maintenance Windows
nav: Maintenance Windows
modified_at: 2023-08-31 00:00:00
tags: databases maintenance
index: 0
---

Database Maintenance Windows is our system tailored to schedule the maintenances needed on your databases. It allows you to keep them secure and up-to-date, while being aware of the time period where your database could be temporarily unavailable.

Each database has a default maintenance window set by Scalingo. But you can now provide a eight hours time window where Scalingo can proceed to the maintenance of your database.

Moreover, it's also possible to schedule the maintenance when your app is less prone to high traffic (i.e : the night between Sunday and Monday). With those features, we have in mind the prevention of any undesired downtime of your app.

Planned Maintenance Windows are excluded from the SLA calculation.

### Configure your desired Database Maintenance Window

With the Scalingo CLI, the desired beginning period of your eight hours time window can be configured with the `addons-config` command:

```bash
# You are setting the window day to "monday", starting at 1AM
scalingo --app my-app addons-config --maintenance-window-day monday --maintenance-window-hour 1 ADDON_ID
```

Setting this up will allow Scalingo to proceed to their maintenance between 1AM and 9AM on your timezone. You can check the time window you configured with the command `addons-info`:

```bash
scalingo --app my-app addons-info ADDON_ID
```

### Check past and future maintenances

To use the following commands in order to list planned and past maintenances on your database, specify the related application, and your database addon UUID:

```bash
scalingo --app my-app --addon addon_uuid database_maintenance_list
```

This will give you the list of the planned maintenance windows for your databases.

You can, as well, get more details about a specific maintenance :

```bash
scalingo --app my-app --addon addon_uuid database_maintenance_info maintenance_uuid
```
