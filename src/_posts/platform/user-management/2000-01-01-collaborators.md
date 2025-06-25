---
title: Collaborators
modified_at: 2025-06-25 00:00:00
tags: app collaborators
order: 7
---




A SUPPRIMER


Collaborators is a feature allowing the owner of an app to invite other Scalingo accounts to team up and work jointly on the app. An app can have as many collaborators as needed.

An owner of an app can also [transfer the ownership of the app]({% post_url platform/app/2000-01-01-lifecycle-management %}#transfer-ownership-of-an-app) to a collaborator.

{% note %}
Delegating rights to collaborators should be done with caution. While collaborators can't delete the application, they still have sufficient rights to potentially disrupt the activities or businesses that depend on it.
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

