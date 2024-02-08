---
title: Collaborators
modified_at: 2024-02-07 00:00:00
tags: app collaborators
---

Collaborators is a feature allowing the owner of an app to invite other Scalingo accounts to team up and work jointly on the app. An app can have as many collaborators as needed.

An owner of an app can also [transfer the ownership of the app]({% post_url platform/app/2000-01-01-lifecycle-management %}#transfer-ownership-of-an-app) to a collaborator.

{% note %}
Delegating rights to collaborators should be taken seriously. Even if collaborators can't delete the application, they have enough rights to disrupt the activities or businesses depending on it.
{% endnote %}

## Understanding Collaborators Rights

Collaborators can:

- Trigger deployments
- Manage containers (scale up and down, both horizontally and vertically)
- Manage addons (create, delete, change plan)
- View logs
- Access [Review Apps]({% post_url platform/app/2000-01-01-review-apps %})
- View metrics
- View activity
- Access the DB Dashboard(s)
- Manage other collaborators (invite, remove)

Collaborators can't:

- Delete the application
- Rename the application
- Transfer the ownership of the application to another user

## Managing Collaborators

### Listing Collaborators

Using the Dashboard

- Go to your application that needs a new collaborator
- Go to the Settings tab
- You will automatically be taken to the Collaborators menu

Using the Command Line

```shell
scalingo --app my-app collaborators
```

### Adding a Collaborator

Using the Dashboard

- Go to your application that needs a new collaborator
- Go to the Settings tab
- You will automatically be taken to the Collaborators menu
- Click on the Add button
- Add the required collaborator email
- You will now see the collaborator in light grey in the table.
- The collaborator will receive an email to join the collaboration (and subscribe to Scalingo if required).
- Once done, you will see the collaborator in black.

Using the Command Line

```shell
scalingo --app my-app collaborators-add user@example.com
```

### Removing a Collaborator

Using the Dashboard

- Go to your application that needs a new collaborator
- Go to the Settings tab
- You will automatically be taken to the Collaborators menu
- Click on the trash can corresponding to the collaborator's mail
- Validate in the pop-up

Using the Command Line

```shell
scalingo --app my-app collaborators-remove user@example.com
```
