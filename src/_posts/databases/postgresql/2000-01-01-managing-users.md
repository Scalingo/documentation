---
title: Managing Users of Your Scalingo for PostgreSQL® Addon
nav: Managing Users
modified_at: 2024-11-05 12:00:00
tags: databases postgresql addon
index: 6
---

Each Scalingo for PostgreSQL® addon comes with a [default database user](#understanding-protected-user).
You can [create](#creating-a-new-user) as many additional users as needed,
grant them with the appropriate permissions, and you can [delete](#deleting-a-user)
them once they are not required anymore.


## Listing Existing Users

### Understanding Protected User

When provisioning a new Scalingo for PostgreSQL® addon, the platform creates a
default user with a random name and password. It also grants this default user
read and write permissions on the database, using the following queries:

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

1. From your web browser, open your [database dashboard]({% post_url databases/postgresql/2000-01-01-getting-started %}#accessing-the-postgresql-dashboard)
2. Click the **Users** tab
3. The list of available users is displayed under the **User Management**
   section

### Using the Command Line

1. Make sure you have correctly [setup the Scalingo command line tool]({% post_url platform/cli/2000-01-01-start %})
2. From the command line, run the following command to list the users:
   ```bash
   scalingo --app my-app --addon postgresql database-users-list
   ```
   The output should look like this:
   ```text
   +----------------+-----------+-----------+---------------------+
   |    USERNAME    | READ-ONLY | PROTECTED | PASSWORD ENCRYPTION |
   +----------------+-----------+-----------+---------------------+
   | my_app_4553    | false     | true      | SCRAM-SHA-256       |
   | my_app_4553_rw | false     | false     | MD5                 |
   | my_app_4553_ro | true      | false     | MD5                 |
   +----------------+-----------+-----------+---------------------+
   ```
   In this example, we can see that the database has 3 users available. The
   first one is protected, which means it's been created along with the addon.
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

1. From your web browser, open your [database dashboard]({% post_url databases/postgresql/2000-01-01-getting-started %}#accessing-the-scalingo-for-postgresql-dashboard)
2. Click the **Users** tab
3. Fill the **Add a new user** form:
   - Fill a username
   - Fill the corresponding password twice
4. (optional) If you want to restrict this user to read only abilities, make
   sure to check the **Read only** checkbox
5. Validate by clicking the **Add User** button

### Using the Command Line

1. Make sure you have correctly [setup the Scalingo command line tool]({% post_url platform/cli/2000-01-01-start %})
2. From the command line, run the following command to create a new user:
   ```bash
   scalingo --app my-app --addon postgresql database-users-create <username>
   ```
   Optionally, if you want to restrict this user to read only abilities, use
   the `--read-only` flag:
   ```bash
   scalingo --app my-app --addon postgresql database-users-create --read-only <username>
   ```
3. Set the user password:
   - Either chose a password and confirm it
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


## Updating a User Password

{% note %}
Updating a User Password is only available from the command line.
{% endnote %}

### Using the Command Line

1. Make sure you have correctly [setup the Scalingo command line tool]({% post_url platform/cli/2000-01-01-start %})
2. Update the user password with the following command:
   ```bash
   scalingo --app my-app --addon postgresql database-users-update-password <username>
   ```
3. An interactive prompt asks you for a password you want to attribute to your user:
   - Either chose a password and confirm it
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


## Deleting a User

### Using the Database Dashboard

1. From your web browser, open your [database dashboard]({% post_url databases/postgresql/2000-01-01-getting-started %}#accessing-the-scalingo-for-postgresql-dashboard)
2. Click the **Users** tab
3. Locate the user you want to remove
4. Click the **Delete** button next to the user
5. Confirm the removal

### Using the Command Line

1. Make sure you have correctly [setup the Scalingo command line tool]({% post_url platform/cli/2000-01-01-start %})
2. Remove the user with the following command:
   ```bash
   scalingo --app my-app --addon postgresql database-users-delete <username>
   ```
