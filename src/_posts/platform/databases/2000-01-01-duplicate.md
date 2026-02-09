---
title: Copying your Database
modified_at: 2023-08-31 16:00:00
tags: databases backups
index: 3
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
Scalingo for PostgreSQL®, Scalingo for MySQL®, Scalingo for Caching and Scalingo for MongoDB® addons. For other addons, please get in
touch with our support.
{% endwarning %}

We usually suggest the following strategy:

1. Create a new application with a database addon of the same kind as the one
   used in production. This new app is only required to get another database
   running and to feed it on a regular basis, so **don't forget to make it
   [web-less]({% post_url platform/app/2000-01-01-web-less-app %})**.
2. From this new app, download the latest production database backup available.
   This can be done using the [Scalingo CLI tool]({% post_url tools/cli/2000-01-01-start %}),
   an API token and a bit of Bash (see hereafter).
3. Once downloaded, [restore the backup]({% post_url databases/about/2000-01-01-backup-policies %}#restoring-a-backup)
   to the new app's database.
4. If needed, run these tasks on a regular basis using the
   [Scalingo Scheduler]({% post_url platform/app/task-scheduling/2000-01-01-scalingo-scheduler %}).

## Scripting the Solution

Almost all the steps described above can be automated, thanks to the Scalingo
CLI tool (and some Bash glue). Here is a basic example of what can be done:

```bash
#!/usr/bin/env bash

archive_name="backup.tar.gz"

# Install the Scalingo CLI tool in the container:
install-scalingo-cli

# Install additional tools to interact with the database:
dbclient-fetcher "${DUPLICATE_ADDON_KIND}"

# Login to Scalingo, using the token stored in `DUPLICATE_API_TOKEN`:
scalingo login --api-token "${DUPLICATE_API_TOKEN}"

# Retrieve the addon id:
addon_id="$( scalingo --app "${DUPLICATE_SOURCE_APP}" addons \
             | grep "${DUPLICATE_ADDON_KIND}" \
             | cut -d "|" -f 3 \
             | tr -d " " )"

# Download the latest backup available for the specified addon:
scalingo --app "${DUPLICATE_SOURCE_APP}" --addon "${addon_id}" \
    backups-download --output "${archive_name}"

# Get the name of the backup file:
backup_file_name="$( tar --list --file="${archive_name}" \
                     | tail -n 1 \
                     | cut -d "/" -f 2 )"

# Extract the archive containing the downloaded backup:
tar --extract --verbose --file="${archive_name}" --directory="/app/"

# Restore the data:
#  Example with PostgreSQL:
#    pg_restore --clean --if-exists --no-owner --no-privileges --no-comments \
#        --dbname "${DATABASE_URL}" "/app/${backup_file_name}"
```

As you can see, this script would require 3 environment variables to be set:

- `DUPLICATE_API_TOKEN`: an API token granting access to your account. It can
  be generated from [your dashboard](https://dashboard.scalingo.com/account/tokens).
- `DUPLICATE_SOURCE_APP`: the name of the source application, from where the
  backup will be retrieved.
- `DUPLICATE_ADDON_KIND`: the database kind (see the [`dbclient-fetcher`
  documentation]({% post_url platform/databases/2000-01-01-remote-console %}#manually-install-the-databases-cli-in-a-one-off)
  for further help).

The last step of the script depends on the database you're using. Please refer
to [our documentation]({% post_url databases/about/2000-01-01-backup-policies %}#restoring-a-backup)
for precise instructions and examples.

You will most probably need an empty file called `index.php` to trick the
platform and make it believe you are deploying a PHP app. Without it, the
platform won't deploy your app.

In the end, you should have at least 3 files in your project directory:
- An empty `index.php`.
- A `.sh` file, containing your duplication script.
- A `cron.json` file to schedule your duplication task.
