---
title: Managing Collaborators of Your Scalingo for PostgreSQL® Dedicated Resources Database
nav: Managing Collaborators
modified_at: 2026-02-13 12:00:00
tags: databases postgresql dedicated collaborator
index: 1
---

Inviting collaborators allows you to share access to a dedicated database while
keeping full control over who can manage it.

Unlike Shared Resources databases, a Dedicated Resources database has its own
collaborators.

{% note %}
For now, Dedicated Resources databases still use application CLI commands.
This will change in a future release.
{% endnote %}


## Listing Collaborators of a Database

### Using the Dashboard

1. From your web browser, open your [dashboard][dashboard]
2. Browse your projects and select the database you want to manage
3. Once on the database dashboard, click the **Settings** tab, then select
   **Collaborators**

### Using the Command Line

1. Make sure you have correctly [setup the Scalingo command line tool][cli]
2. From the command line, list the collaborators:
   ```shell
   scalingo --app my-dedicated-db collaborators
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


## Inviting a Collaborator

### Using the Dashboard

1. From your web browser, open your [dashboard][dashboard]
2. Browse your projects and select the database you want to manage
3. Once on the database dashboard, click the **Settings** tab, then select
   **Collaborators**
4. Click the **Add** button
5. Fill the input field with the e-mail address of the collaborator
6. Confirm
7. The collaborator is added and appears dimmed in the list
8. An invite is sent by e-mail to the collaborator
9. Once the invite is accepted, the collaborator appears normally in the list

{% note %}
For Dedicated Resources databases, only the **Collaborator** role is available.
The **Limited Collaborator** role is not available because it is designed to
prevent access to database data.
{% endnote %}

### Using the Command Line

1. Make sure you have correctly [setup the Scalingo command line tool][cli]
2. From the command line, invite someone:
   ```shell
   scalingo --app my-dedicated-db collaborators-add user@example.com
   ```
   The output should look like this:
   ```text
   -----> user@example.com has been invited to collaborate to my-dedicated-db
   ```


## Removing a Collaborator

### Using the Dashboard

1. From your web browser, open your [dashboard][dashboard]
2. Browse your projects and select the database you want to manage
3. Once on the database dashboard, click the **Settings** tab, then select
   **Collaborators**
4. Locate the collaborator for whom you want to revoke access
5. Open the contextual menu by clicking the corresponding **...** button
6. Select **Revoke access**
7. Confirm by clicking the **Delete user@example.com** button in the popup
   window

### Using the Command Line

1. Make sure you have correctly [setup the Scalingo command line tool][cli]
2. From the command line, revoke the access:
   ```shell
   scalingo --app my-dedicated-db collaborators-remove user@example.com
   ```
   The output should look like this:
   ```text
   -----> user@example.com has been removed from the collaborators of my-dedicated-db
   ```


## Stopping Collaborating

If you are currently working collaboratively on a dedicated database and have no
more interest in participating, you can stop collaborating on your own.

### Using the Dashboard

1. From your web browser, open your [dashboard][dashboard]
2. Browse your projects and select the database you want to manage
3. Once on the database dashboard, click the **Settings** tab, then select
   **Collaborators**
4. Locate yourself in the list of collaborators
5. Open the contextual menu by clicking the corresponding **...** button
6. Select **Revoke access**
7. Confirm by clicking the **Delete user@example.com** button in the popup
   window


[dashboard]: https://dashboard.scalingo.com/
[cli]: {% post_url tools/cli/2000-01-01-start %}
