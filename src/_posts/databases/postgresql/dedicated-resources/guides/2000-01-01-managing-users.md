---
title: Managing Users of Your Scalingo for PostgreSQL® Dedicated Resources Database
nav: Managing Users
modified_at: 2026-10-15 00:00:00
tags: databases postgresql dedicated
index: 1
---

Each Scalingo for PostgreSQL® Dedicated Resources database comes with
a [default database user](#understanding-protected-user).
You can [create](#creating-a-new-user) as many additional users as needed,
grant them with the appropriate permissions, [update/reset their password](#updating-or-resetting-a-user-password),
and [delete](#deleting-a-user) them once they are not required anymore.

{% note %}
This guide covers **database users** only.
If you need to grant access to collaborators on a Dedicated Resources database,
add them as collaborators by following [this guide][dr-managing-collaborators].
{% endnote %}


## Listing Existing Users

### Understanding Protected User

When provisioning a new Scalingo for PostgreSQL® Dedicated Resources Database
instance, the platform creates a default user with a random name and password.
It also grants this default user read and write permissions on the database,
using the following queries:

```sql
GRANT CREATE ON SCHEMA public TO <username>
GRANT ALL PRIVILEGES ON DATABASE <database> TO <username>
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO <username>
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO <username>
ALTER DEFAULT PRIVILEGES FOR USER <database> IN SCHEMA public GRANT ALL ON TABLES TO <username>
ALTER DEFAULT PRIVILEGES FOR USER <database> IN SCHEMA public GRANT ALL ON SEQUENCES TO <username>
```

{% note %}
This default user is ***protected*** and thus:
- can't be renamed, nor removed,
- its password can't be updated
{% endnote %}

### Using the Database Dashboard

{% include database_users_list_dashboard.md %}

### Using the Command Line

1. Make sure you have correctly [set up the Scalingo command line tool][cli]
2. From the command line, list your databases:
   ```bash
   scalingo databases
   ```
3. Locate the `ID` of the database for which you want to list users
4. From the command line, run the following command to list the users:
   ```bash
   scalingo --database <database_ID> database-users-list
   ```
   The output should look like this:
   ```text
   +----------------+-----------+-----------+---------------------+
   |    USERNAME    | READ-ONLY | PROTECTED | PASSWORD ENCRYPTION |
   +----------------+-----------+-----------+---------------------+
   | my_app_4553    | false     | true      | SCRAM-SHA-256       |
   | my_app_4553_rw | false     | false     | SCRAM-SHA-256       |
   | my_app_4553_ro | true      | false     | SCRAM-SHA-256       |
   +----------------+-----------+-----------+---------------------+
   ```
   In this example, we can see that the database has 3 users available. The
   first one is protected, which means it's been created along with the database.
   It can't be removed. Among the two others, one can only read data from the
   database. We can also see the password encryption algorithm.


## Creating a New User

The following restrictions apply when creating a new user, regardless of the
method used:

- Username:
  - Must be between 6 and 32 characters long
  - Can only contain alphanumerical characters and underscores (`_`)
  - Must start with a letter
- Password:
  - Must be between 24 and 64 characters long.
  - Must not contain the character `"` or `'`

### Using the Database Dashboard

{% include database_users_create_dashboard.md %}

### Using the Command Line

1. Make sure you have correctly [set up the Scalingo command line tool][cli]
2. From the command line, list your databases:
   ```bash
   scalingo databases
   ```
3. Locate the `ID` of the database for which you want to create a user
4. From the command line, run the following command to create a new user:
   ```bash
   scalingo --database <database_ID> database-users-create <username>
   ```
   Optionally, if you want to restrict this user to read only abilities, use
   the `--read-only` flag:
   ```bash
   scalingo --database <database_ID> database-users-create --read-only <username>
   ```
5. Set the user password:
   - Either choose a password and confirm it
   - Or let the platform generate a password by leaving the field empty

   The output should look like this:
   - If you set a password:
   ```text
   User "my_user" created.
   ```
   - If you let the platform generate a password:
   ```text
   User "my_user" created with password "YANs3y07m5_KJC2MSDGebh8tx1lliFWh2Yb239zVqGQvbElWDjIN7QWspVH92Ul8".
   ```


## Updating or Resetting a User Password

{% include database_users_password_methods.md %}

### Using the Database Dashboard (Reset Only)

{% include database_users_reset_password_dashboard.md %}

### Using the Command Line

1. Make sure you have correctly [set up the Scalingo command line tool][cli]
2. Update the user password with the following command:
   ```bash
   scalingo --database <database_ID> database-users-update-password <username>
   ```
   Example:
   ```bash
   scalingo --database 699d6312565f770d0a6cdab3 database-users-update-password my_user
   ```
3. An interactive prompt asks you for a password you want to attribute to your user:
   - Either choose a password and confirm it
   - Or let the platform generate a password by leaving the field empty
   The output should look like this:
   - If you set a password:
   ```text
   User "my_user" updated.
   ```
   - If you let the platform generate a password:
   ```text
   User "my_user" updated with password "YANs3y07m5_KJC2MSDGebh8tx1lliFWh2Yb239zVqGQvbElWDjIN7QWspVH92Ul8".
   ```


## Deleting a User

### Using the Database Dashboard

{% include database_users_delete_dashboard.md %}

### Using the Command Line

1. Make sure you have correctly [set up the Scalingo command line tool][cli]
2. Remove the user with the following command:
   ```bash
   scalingo --database <database_ID> database-users-delete <username>
   ```


[cli]: {% post_url tools/cli/2000-01-01-start %}
[database-dashboard]: {% post_url databases/postgresql/dedicated-resources/getting-started/2000-01-01-provisioning %}#accessing-the-scalingo-for-postgresql-dashboard
[dr-managing-collaborators]: {% post_url databases/postgresql/dedicated-resources/guides/2000-01-01-managing-collaborators %}
