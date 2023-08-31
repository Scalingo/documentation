---
title: Copying your Database
modified_at: 2023-08-28 16:00:00
tags: databases backups
---

Sometimes, it can be useful to create a copy of your database. Some use-cases
for such a copy are (but not limited to):

- Conduct some testings.
- Prepare a data migration.
- Validate changes through a review app.
- Build statistics or insights.
- ...

At Scalingo, we highly recommend using a dedicated database to achieve these
tasks in the best conditions. Doing so not only drastically lowers the risks of
data loss, but it also preserves your production database performances and
ensures all the connection slots are actually used for production purposes.

## Planning the Solution

{% warning %}
For technical reasons, the following strategy will only work with our
PostgreSQL, MySQL, Redis and MongoDB addons. For other addons, please get in
touch with our support.
{% endwarning %}

We usually suggest the following strategy:

1. Create a new application with a database addon of the same kind as the one
   used in production. This new app is only required to get another database
   running and to feed it on a regular basis, so **don't forget to make it
   [web-less]({% post_url platform/app/2000-01-01-web-less-app %})**.
2. From this new app, download the latest production database backup available.
   This can be done using the [Scalingo CLI tool]({% post_url platform/cli/2000-01-01-start %}),
   an API token and a bit of Bash (see hereafter).
3. Once downloaded, [restore the backup]({% post_url platform/databases/2000-01-01-restore-backup %})
   to the new app's database.
4. If needed, run these tasks on a regular basis using the
   [Scalingo Scheduler]({% post_url platform/app/task-scheduling/2000-01-01-scalingo-scheduler %}).

## Scripting the Solution

Almost all the steps described above can be automated, thanks to the Scalingo
CLI tool (and some Bash glue). Here is a simple example of what can be done:

```bash
#!/usr/bin/env bash

archive_name="backup.tar.gz"

# Install the Scalingo CLI tool in the container:
install-scalingo-cli

# Install additional tools to interact with the database:
dbclient-fetcher "${DUPLICATE_ADDON_KIND}"

# Login to Scalingo, using the token stored in `SCALINGO_CLI_TOKEN`:
scalingo login --api-token "${SCALINGO_CLI_TOKEN}"

# Retrieve the addon id:
addon_id="$( scalingo --app "${DUPLICATE_SOURCE_APP}" addons \
             | grep "${addon_kind}" \
             | cut -d '|' -f 3 \
             | tr -d ' '" )"

# Download the latest backup available for the specified addon:
scalingo --app "${DUPLICATE_SOURCE_APP}" --addon "${addon_id}" \
    backups-download --output "${archive_name}"

# Extract the archive containing the downloaded backup:
tar --extract --verbose --strip-components=1 --file="${archive_name}" \
    --directory="/app/restore"

# Restore the data:
#  Example with PostgreSQL:
#    pg_restore --clean --if-exists --no-owner --no-privileges --no-comments --dbname $DATABASE_URL /app/restore
#  Example with MySQL:
#    mysql 
```

As you can see, this script would require 3 environment variables to be set:

- `SCALINGO_CLI_TOKEN`: an API token granting access to your account.
- `DUPLICATE_SOURCE_APP`: the name of the source application.
- `DUPLICATE_ADDON_KIND`: the database kind (see the [`dbclient-fetcher` documentation]({% post_url platform/databases/2000-01-01-access %}#manually-install-the-databases-cli-in-one-off)
  for further help).

The last step of the script depends on the database you're using. Please refer
to [our documentation]({% post_url platform/databases/2000-01-01-restore-backup %})
for precise instructions and examples.
