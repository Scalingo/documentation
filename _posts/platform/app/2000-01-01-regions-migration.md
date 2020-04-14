---
title: Application Migration Between Regions
nav: App Migrations
modified_at: 2020-03-27 00:00:00
tags: app migration region
index: 17
---

{% include info_command_line_tool.md %}

## Introduction

Migrating an application from one region to another consists in 4 steps. The CLI will guide you through each of them, so it  important to carefully read the output of each executed commands as it provides useful information.

**Each step is reversible, so if the migration process is not going smoothly, you can cancel it at any time.**

Once started, your application is "frozen" : you cannot modify its settings, add or remove any addon, and so on; if you wish or need to do so, abort the migration, perform your changes, and restart the process.

The four steps matches the four commands to be run using the CLI, which are the following :

- **migration-create**, where we check that the migration is doable; this step returns a migration ID that will be necessary to run the next steps or to abort the migration.
- **migration-run --prepare**, where we copy the skeleton (the app, the collaborators, its configuration).
- **migration-run --data**, where we copy the addons data. This step is **optionnal**. 
- **migration-run --finalize**, where we start the new app and redirect the traffic from the old app.

The data migration step is optionnal in case you need to fully control this step, eg. if you have large volumes to migrate or if you want to change an addon version.

The source application will be stopped before `migration-run --data` is performed, or if you skipped this step, during `migration-run --finalize`.

At the end of each step, the Scalingo CLI tells you which command you need to run next.

The following documentation on this page assumes you migrate an application named `my-app` hosted
on the region `agora-fr1` to the region `osc-fr1`.

### migration-create

This step executes a few pre-migration checks to make sure you can migrate the
application to the new region. The migration can be prevented if your application is using region-specific addons, or some addon versions that are too old.

You can optionally specify the `--new-name` flag if you want a different name
for your application on the destination region.

The command will output a migration ID that will be required to run any of the next steps, including aborting the migration. 

Example output:

```
$ scalingo --region agora-fr1 --app my-app migration-create --to osc-fr1
Migration ID: 8e624121-2ce3-4b01-9bf4-d5e2b32df7e9
Migrating app: my-app
Destination: osc-fr1
New app ID: N/A
Status: preflight-success
✔ Check addon versions Done!
✔ Check certificate validity Done!
✔ Check addons compatibility Done!
✔ Preflight checks Done!

Your app can be migrated to the osc-fr1 zone.
To start the migration launch:

scalingo --app my-app migration-run --prepare 8e624121-2ce3-4b01-9bf4-d5e2b32df7e9
```

In this case, there is nothing preventing the migration, and it is referenced under the ID `8e624121-2ce3-4b01-9bf4-d5e2b32df7e9`.

### migration-run --prepare

This step: 

- creates the application on the new region
- replicates the container formation
- copies the settings (canonical domain, force HTTPS, sticky session)
- the application soft limits (such as the image max size)
- imports the build that is currently running on the source application (the latest succesful deployment)
- imports the environment variables
- imports the collaborators that have accepted the invitation (pending collaborators are **not** imported)
- imports the SCM integration (GitHub, GitLab, etc.)
- imports the domains and their certificates (both from Let's Encrypt and manually added ones)
- imports the notifiers and the configured alerts
- imports the log drains
- imports the autoscalers

It also sets your application into `migrating` state, which then becomes **read-only** on
the source region; this is done to ensure that there will be no difference between the source and the target application.

The output will contain one line per sub-step and contains it status (ongoing or finished). This step is usually quite quick to perform.

```
$ scalingo --region agora-fr1 --app my-app migration-run --prepare 8e624121-2ce3-4b01-9bf4-d5e2b32df7e9

[...]

Application on region 'osc-fr1' has been prepared, you can now:
- Let us migrate your data to 'osc-fr1' newly created databases with:
scalingo --app my-app migration-run --data 8e624121-2ce3-4b01-9bf4-d5e2b32df7e9
- Handle data migration manually, then finalizing the migration with:
scalingo --app my-app migration-run --finalize 8e624121-2ce3-4b01-9bf4-d5e2b32df7e9
```

The next step depends on whether you need to migrate databases or not. If you
want to migrate a database using this tool, read the next section. Otherwise, please skip it and
directly head to the "Finalize the Migration" section.

### migration-run --data

At this step of the migration, we will need to stop the application on the source region. We do this in order to prevent modifications to the database(s), so that the target ends up with the same data as the source.

The following steps are performed for each database concurrently:

- provision a database with the same plan and the same version
- trigger a backup on the source database
- once those two operations are done, we restore the backup on the target database
- once the restoration is done, that's it!

For non-database addons, it simply provisions the addon since there is no further step.

Once this is done, the application is not yet started; this happens in the next step.

The output will contain the result of each step for each addon.

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

### migration-run --finalize

The last step consists in starting the application in the new region and
redirecting all traffic from the old region to the new one.

This is automatically done by Scalingo to minimize the impact on your application
availability.

If a custom domain is configured on your application, you need to update the DNS
record to match the new application domain name. For 30 days, our front servers
on the old region will handle the redirection to the new region to give you some
time to update the DNS record. But don't forget to update it or your application
will become **unavailable after these 30 days**.

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

### migration-abort

At any time during the migration process, you can abort the migration by issuing
the `scalingo migration-abort` command.

This:

- deletes the app on the new region, including its addons, the data that was migrated if any, etc.
- un-freeze the source application and is restarted if it was stopped.

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
