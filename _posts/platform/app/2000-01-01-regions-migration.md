---
title: Application Migration Between Regions
nav: App Migrations
modified_at: 2020-03-27 00:00:00
tags: app migration region
index: 17
---

{% include info_command_line_tool.md %}

## Introduction

Migrating an application from one region to another consists in 4 steps:

- Creating the migration
- Preparing the migration
- Migrating the data
- Finalizing the migration

It is important to carefully read the output of each executed commands as it
provides useful information.

This documentation page assumes you migrate an application named `my-app` hosted
on the region `agora-fr1` to the region `osc-fr1`.

### Create the Migration

The first step is to create a migration:

```
$ scalingo --region agora-fr1 --app my-app migration-create --to osc-fr1
Migration ID: 8e624121-2ce3-4b01-9bf4-d5e2b32df7e9
Migrating app: my-app
Destination: osc-fr1

[...]

Your app can be migrated to the osc-fr1 zone.
To start the migration launch:

scalingo --app my-app migration-run --prepare 8e624121-2ce3-4b01-9bf4-d5e2b32df7e9
```

This step executes a few pre-migration checks to make sure you can migrate the
application to the new region. At the end of each step, the Scalingo CLI tells
you which command you need to run next.

You can optionally specify the `--new-name` flag if you want a different name
for your application on the destination region.

### Prepare the Migration

You can now safely run the migration:

```
$ scalingo --region agora-fr1 --app my-app migration-run --prepare 8e624121-2ce3-4b01-9bf4-d5e2b32df7e9

[...]

Application on region 'osc-fr1' has been prepared, you can now:
- Let us migrate your data to 'osc-fr1' newly created databases with:
scalingo --app my-app migration-run --data 8e624121-2ce3-4b01-9bf4-d5e2b32df7e9
- Handle data migration manually, then finalizing the migration with:
scalingo --app my-app migration-run --finalize 8e624121-2ce3-4b01-9bf4-d5e2b32df7e9
```

This step sets your application into `migrating` state. It becomes read-only on
the source region and duplicates all its configuration on the destination region
(e.g. environment variables, collaborators, domains, etc).

The next step depends on whether you need to migrate databases or not. If you
want to migrate a database, read the next section. Otherwise, please skip it and
directly head to the "Finalize the Migration" section.

### Migrate Databases

At this step of the migration, we will need to stop the application on the
source region. Run the following command to stop the application and migrate the
data:

```
$ scalingo --region agora-fr1 --app my-app migration-run --data 8e624121-2ce3-4b01-9bf4-d5e2b32df7e9
The following operations will be achieved:
 - Stop your old app
 - Create addons on the 'osc-fr1' region
 - Import addons data

[...]

Data has been migrated to the 'osc-fr1' region
You can finalize the migration with:
scalingo --app my-app migration-run --finalize 8e624121-2ce3-4b01-9bf4-d5e2b32df7e9
```

This step stops the application on the source region, and triggers a new backup
of your database data. This backup is used for the database on the destination
region. The application on the destination region will be started at the next
step.

### Finalize the Migration

The last step consists of starting the application on the new region and
redirecting all traffic from the old region to the new one. This is
automatically done by Scalingo to minimize the impact on your application
availability:

```
$ scalingo --region agora-fr1 --app my-app migration-run --finalize 8e624121-2ce3-4b01-9bf4-d5e2b32df7e9
The following operations will be achieved:
 - Start the new app
 - Redirect the traffic coming to 'my-app' on the old region to 'my-app' on 'osc-fr1'

[...]


Your application is now available at: https://my-app.osc-fr1.scalingo.io

-----> You need to make the following changes to your DNS records:

       - CNAME record of my-app.example.com should be changed to my-app.osc-fr1.scalingo.io
```

If a custom domain is configured on your application, you need to update the DNS
record to match the new application domain name. For 30 days, our front servers
on the old region will handle the redirection to the new region to give you some
time to update the DNS record. But don't forget to update it or your application
will become unavailable after these 30 days.

### Abort a Migration

At any time during the migration process, you can abort the migration by issuing
the `scalingo migration-abort` command:

```
$ scalingo --region agora-fr1 --app my-app-abort migration-abort bbe1e4be-c978-472f-898f-e79e8db6c394
Migration ID: bbe1e4be-c978-472f-898f-e79e8db6c394
Migrating app: my-app-abort
Destination: osc-fr1

[...]

The migration 'bbe1e4be-c978-472f-898f-e79e8db6c394' has been aborted
You can retry it with:
scalingo --app my-app-abort migration-create --to osc-fr1
```

Aborting a migration reverts all the executed actions.
