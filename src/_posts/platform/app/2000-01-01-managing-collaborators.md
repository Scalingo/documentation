---
title: Managing Application Collaborators
nav: Managing Collaborators
modified_at: 2026-11-13 00:00:00
tags: app collaborator
index: 17
---

Add collaborators to an application and assign each one a role that defines what
they can do. Collaborators can deploy code, change settings or access data,
depending on their role.

Choose a [role][roles] based on the access each person needs.


## Collaborator Access to Add-ons

Collaborators on an application also have access to its add-ons. Their role
determines what they can do on those add-ons.


## Listing Collaborators of an Application

### Using the Dashboard

1. Open your [Dashboard][dashboard]
2. Open **Projects** and select the project containing the application
3. Open **Resources** and select the application
4. Click the **Settings** tab
5. In the **Settings** submenu, make sure to select **Collaborators**

### Using the Command Line

1. Make sure you have correctly [setup the Scalingo command line tool][cli]
2. From the command line, list the collaborators:
   ```shell
   scalingo --app my-app collaborators
   ```
   The output should look like this:
   ```text
   ┌──────────────────────────────┬──────────┬──────────┬──────────────────────┐
   │            EMAIL             │ USERNAME │ STATUS   │         ROLE         │
   ├──────────────────────────────┼──────────┼──────────┼──────────────────────┤
   │ user1@example.com            │ user1    │ owner    │ owner                │
   │ user2@example.com            │ user2    │ accepted │ collaborator         │
   │ user3@example.com            │ n/a      │ pending  │ limited collaborator │
   └──────────────────────────────┴──────────┴──────────┴──────────────────────┘
   ```


## Adding a Collaborator

Add a collaborator by entering their email address and choosing a role.
The result depends on where the application is located:

{% include collaborator_invitation_context.md %}

### Using the Dashboard

1. Open your [Dashboard][dashboard]
2. Open **Projects** and select the project containing the application
3. Open **Resources** and select the application
4. Go to **Settings** > **Collaborators**
5. Click **Add**
6. Enter the collaborator's email address. If they already have a Scalingo account,
   use the email address associated with that account
7. Select a [role][roles] based on the permissions the collaborator needs
8. Confirm the addition

### Using the Command Line

1. Make sure you have correctly [setup the Scalingo command line tool][cli]
2. From the command line, add a collaborator:
   ```shell
   scalingo --app my-app collaborators-add user@example.com
   ```
   Example output in a personal account:
   ```text
   -----> user@example.com has been invited to collaborate to my-app
   ```

### Using the Terraform Provider

1. Place the following `resource` block in your Terraform file:
   ```tf
   locals {
     team = ["user1@example.com", "user2@example.com"]
   }

   resource "scalingo_collaborator" "collaborators" {
     for_each = toset(local.team)

     app   = "${scalingo_app.my-app.id}"
     email = each.key
   }
   ```
   This example adds user1@example.com and user2@example.com as collaborators on
   an existing application named `my-app`.


## Updating a Collaborator's Role

### Using the Dashboard

1. Open your [Dashboard][dashboard]
2. Open **Projects** and select the project containing the application
3. Open **Resources** and select the application
4. Click the **Settings** tab
5. In the **Settings** submenu, make sure to select **Collaborators**
6. Locate the collaborator for whom you want to update the role
7. Open the contextual menu by clicking the corresponding **…** button
8. Select **Change role**
9. In the popup window, select the new role
10. Confirm by clicking the **Change role** button

### Using the Command Line

1. Make sure you have correctly [setup the Scalingo command line tool][cli]
2. From the command line, update a collaborator:
   ```shell
   scalingo --app my-app collaborators-update --limited=true user@example.com
   ```
   The output should look like this:
   ```text
   -----> user@example.com role has been updated for my-app
   ```

### Using the Terraform Provider

There is only one step required to update a collaborator using Terraform. You need to
update the collaborator and add the `limited` flag.
```tf
resource "scalingo_collaborator" "collaborators" {
  app     = "${scalingo_app.my-app.id}"
  email   = "user1@example.com"
  limited = true
}
```


## Revoking a Collaborator's Access to an Application

Revoking collaborator access immediately removes access to the selected
application and its attached add-ons. It does not remove organization membership
or change access to other resources. To revoke access across an organization,
[remove the member from the organization][organization-remove-member].

{% include collaborator_credentials_revocation.md %}

For an application's database add-on, changing the default database user's
password requires help from Support. After changing it, update the associated
environment variable and restart the application.

### Using the Dashboard

1. Open your [Dashboard][dashboard]
2. Open **Projects** and select the project containing the application
3. Open **Resources** and select the application
4. Click the **Settings** tab
5. In the **Settings** submenu, make sure to select **Collaborators**
6. Locate the collaborator for whom you want to revoke access
7. Open the contextual menu by clicking the corresponding **…** button
8. Select **Revoke access**
9. Confirm by clicking the **Delete user@example.com** button in the popup
   window

{% note %}
As a collaborator, you can revoke your own access to the application. Follow the
steps above and select your own account in the list.
{% endnote %}

### Using the Command Line

1. Make sure you have correctly [setup the Scalingo command line tool][cli]
2. From the command line, revoke the access:
   ```shell
   scalingo --app my-app collaborators-remove user@example.com
   ```
   The output should look like this:
   ```text
   -----> user@example.com has been removed from the collaborators of my-app
   ```

### Using the Terraform Provider

1. Remove the collaborator e-mail address from the list of collaborators.
   The following example removes user1@example.com from the list of
   collaborators.\
   Before:
   ```tf
   locals {
     team = ["user1@example.com", "user2@example.com"]
   }
   ```
   After:
   ```tf
   locals {
     team = ["user2@example.com"]
   }
   ```


## Monitoring Collaborators

Use the following event types in an app notifier to stay informed about changes
to an application's collaborators:

| Event                       | Description                               |
| --------------------------- | ----------------------------------------- |
| `collaborator_accepted`     | A collaborator invitation was accepted    |
| `collaborator_invited`      | A collaborator was invited                |
| `collaborator_removed`      | A collaborator was removed                |
| `collaborator_role_changed` | A collaborator role was changed           |

Configure an [app notifier][notifications] to choose where these notifications
are sent.


[dashboard]: https://dashboard.scalingo.com/

[cli]: {% post_url tools/cli/2000-01-01-start %}
[notifications]: {% post_url platform/app/2000-01-01-notifiers %}
[roles]: {% post_url platform/user-management/teamwork/2000-01-01-roles %}
[organization-invitation]: {% post_url platform/user-management/organizations/2000-01-01-managing-members %}#inviting-a-member
[organization-remove-member]: {% post_url platform/user-management/organizations/2000-01-01-managing-members %}#removing-a-member
