---
title: Managing Collaborators of Your Scalingo for PostgreSQL® Dedicated Resources Database
nav: Managing Collaborators
modified_at: 2026-11-13 00:00:00
tags: databases postgresql dedicated collaborator
index: 1
---

Add collaborators to give other Scalingo accounts access to a Dedicated
Resources database. Each database has its own collaborators.


## Listing Collaborators of a Database

### Using the Dashboard

1. From your web browser, open your [dashboard][database-dashboard]
2. Once on the database dashboard, click the **Settings** tab, then select
   **Collaborators**

### Using the Command Line

1. Make sure you have correctly [setup the Scalingo command line tool][cli]
2. From the command line, list the collaborators:
   ```shell
   scalingo --database my-dedicated-db collaborators
   ```
   The output should look like this:
   ```text
   ┌──────────────────────────────┬──────────┬──────────┬──────────────┐
   │            EMAIL             │ USERNAME │ STATUS   │     ROLE     │
   ├──────────────────────────────┼──────────┼──────────┼──────────────┤
   │ user1@example.com            │ user1    │ owner    │ owner        │
   │ user2@example.com            │ user2    │ accepted │ collaborator │
   │ user3@example.com            │ n/a      │ pending  │ collaborator │
   └──────────────────────────────┴──────────┴──────────┴──────────────┘
   ```


## Adding a Collaborator

{% include collaborator_invitation_context.md %}

### Using the Dashboard

1. Open the [database dashboard][database-dashboard]
2. Go to **Settings** > **Collaborators**
3. Click **Add**
4. Enter the collaborator's email address. If they already have a Scalingo account,
   use the email address associated with that account
5. Confirm the addition

{% note %}
Dedicated Resources databases support only the **Collaborator** role.
{% endnote %}

### Using the Command Line

1. Make sure you have correctly [setup the Scalingo command line tool][cli]
2. From the command line, add a collaborator:
   ```shell
   scalingo --database my-dedicated-db-id collaborators-add user@example.com
   ```
   The output should look like this:
   ```text
   -----> user@example.com has been invited to collaborate to my-dedicated-db
   ```

### Using the Terraform Provider

Add a `scalingo_collaborator` resource for each collaborator. This example uses
an existing database declared as `scalingo_database.my_db`:

```tf
locals {
  team = ["user1@example.com", "user2@example.com"]
}

resource "scalingo_collaborator" "database_collaborators" {
  for_each = toset(local.team)

  app   = scalingo_database.my_db.id
  email = each.key
}
```

Run `terraform plan` to review the changes, then `terraform apply` to add the
collaborators.


## Revoking a Collaborator's Access to the Database

Revoking collaborator access immediately removes access to this database. It does
not remove organization membership or change access to other resources. To revoke access
across an organization, [remove the member from the organization][remove-member].

{% include collaborator_credentials_revocation.md %}

Follow the instructions to [update or reset database user passwords][user-passwords]
for credentials the collaborator may already know.

### Using the Dashboard

1. From your web browser, open your [dashboard][database-dashboard]
2. Once on the database dashboard, click the **Settings** tab, then select
   **Collaborators**
3. Locate the collaborator for whom you want to revoke access
4. Open the contextual menu by clicking the corresponding **...** button
5. Select **Revoke access**
6. Review the collaborator and database in the confirmation window, then confirm

{% note %}
As a collaborator, you can revoke your own access to the database. Follow the
steps above and select your own account in the list.
{% endnote %}

### Using the Command Line

1. Make sure you have correctly [setup the Scalingo command line tool][cli]
2. From the command line, revoke the access:
   ```shell
   scalingo --database my-dedicated-db-id collaborators-remove user@example.com
   ```
   The output should look like this:
   ```text
   -----> user@example.com has been removed from the collaborators of my-dedicated-db
   ```

### Using the Terraform Provider

Remove the collaborator's email address from `local.team`. If you manage a single
collaborator without `for_each`, remove their `scalingo_collaborator` block.

Run `terraform plan` and check that only the intended collaborator access will be
removed, then run `terraform apply`.


[database-dashboard]: {% post_url databases/postgresql/dedicated-resources/getting-started/2000-01-01-provisioning %}#accessing-the-scalingo-for-postgresql-dashboard
[cli]: {% post_url tools/cli/2000-01-01-start %}
[user-passwords]: {% post_url databases/postgresql/dedicated-resources/guides/2000-01-01-managing-users %}#updating-or-resetting-a-user-password
[remove-member]: {% post_url platform/user-management/organizations/2000-01-01-managing-members %}#removing-a-member
