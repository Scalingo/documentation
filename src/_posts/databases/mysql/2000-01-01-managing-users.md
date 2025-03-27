---
title: Managing Users of Your Scalingo for MySQL® Addon
nav: Managing Users
modified_at: 2025-03-13 12:00:00
tags: databases mysql addon
index: 5
---

Each Scalingo for MySQL addon comes with a [default database user](#understanding-protected-users).
You can [create](#creating-a-new-user) as many additional users as needed,
grant them with the appropriate permissions, and you can [delete](#deleting-a-user)
them once they are not required anymore.


## Listing Existing Users

### Understanding Protected User

When provisioning a new Scalingo for MySQL addon, the platform creates a
default user with a random name and password. It also grants this default user
read and write permissions on the database, using the following queries:

```sql
GRANT ALL PRIVILEGES ON <database>.* TO '<username>'@'%%'
```

{% note %}
This default user is ***protected*** and thus:
- can't be renamed, nor removed,
- its password can't be updated
{% endnote %}

### Using the Database Dashboard

1. From your web browser, open your [database dashboard]({% post_url databases/mysql/2000-01-01-getting-started %}#accessing-the-scalingo-for-mysql-dashboard)
2. Click the **Settings** tab
3. In the **Settings** submenu, select **Users**
4. The list of available users is displayed under the **User Management**
   section

### Using the Command Line

1. Make sure you have correctly [setup the Scalingo command line tool]({% post_url platform/cli/2000-01-01-start %})
2. From the command line, run the following command to list the users:
   ```bash
   scalingo --app my-app --addon mysql database-users-list
   ```
   The output should look like this:
   ```text
   +----------------+-----------+-----------+
   |    USERNAME    | READ-ONLY | PROTECTED |
   +----------------+-----------+-----------+
   | my_app_4553    | false     | true      |
   | my_app_4553_rw | false     | false     |
   | my_app_4553_ro | true      | false     |
   +----------------+-----------+-----------+
   ```
   In this example, we can see that the database has 3 users available. One has
   been created along with the addon and is protected, which means it can't be
   removed. Among the two others, one can only read data from the database.


## Creating a New User

The following restrictions apply when creating a new user, regardless of the
method you use:

- Username:
  - Must start with a letter
  - Must be between 6 and 32 characters long
  - Can only contain alphanumerical characters and underscores (`_`)
- Password:
  - Must be between 24 and 64 characters long.
  - Must not contain the character `"` or `'`

### Using the Database Dashboard

1. From your web browser, open your [database dashboard]({% post_url databases/mysql/2000-01-01-getting-started %}#accessing-the-mysql-dashboard)
2. Click the **Settings** tab
3. In the **Settings** submenu, select **Users**
4. Click the **Add a user** button
5. Fill the **Add a new user** form:
   - Fill a username
   - To grant write abilities to this user, make sure to check the **Write
     (optional)** checkbox
6. Validate by clicking the **Add this user** button
7. A secure password is generated automatically and shown in a popup window
   after the user creation. **You will be able to view and copy it only once**.

### Using the Command Line

1. Make sure you have correctly [setup the Scalingo command line tool]({% post_url platform/cli/2000-01-01-start %})
2. From the command line, run the following command to create a new user:
   ```bash
   scalingo --app my-app --addon mysql database-users-create <username>
   ```
   Optionally, if you want to restrict this user to read only abilities, use
   the `--read-only` flag:
   ```bash
   scalingo --app my-app --addon mysql database-users-create --read-only <username>
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
- Setting a user password to a **specific value** can only be done via the
  command line.
- Please get in touch with our Support Team to update a
  [protected user](#understanding-protected-user) password.
{% endnote %}

### Using the Database Dashboard

1. From your web browser, [open your database dashboard]({% post_url databases/mysql/2000-01-01-getting-started %}#accessing-the-scalingo-for-mysql-dashboard)
2. Click the **Settings** tab
3. In the **Settings** submenu, select **Users**
4. Locate the user you want the password to be updated
5. Click the **"&#8230;"** button next to the user
6. From the popup menu, select **Reset password**
7. In the popup window, confirm the reset by typing the name of the user
8. Validate by clicking the **Confirm** button
9. A secure password is generated automatically and shown in a popup window
   after the password reset. **You will be able to view and copy it only
   once**.

### Using the Command Line

1. Make sure you have correctly [setup the Scalingo command line tool]({% post_url platform/cli/2000-01-01-start %})
2. Update the user password with the following command:
   ```bash
   scalingo --app my-app --addon mysql database-users-update-password <username>
   ```
3. An interactive prompt asks you for a password you want to attribute to your user:
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


## Deleting a User

### Using the Database Dashboard

1. From your web browser, [open your database dashboard]({% post_url databases/mysql/2000-01-01-getting-started %}#accessing-the-scalingo-for-mysql-dashboard)
2. Click the **Settings** tab
3. In the **Settings** submenu, select **Users**
4. Locate the user you want to remove
5. Click the **"&#8230;"** button next to the user
6. From the popup menu, select **Delete user**
7. In the popup window, confirm the deletion by typing the name of the user
8. Validate by clicking the **Confirm** button

### Using the Command Line

1. Make sure you have correctly [setup the Scalingo command line tool]({% post_url platform/cli/2000-01-01-start %})
2. Remove the user with the following command:
   ```bash
   scalingo --app my-app --addon mysql database-users-delete <username>
   ```
