---
title: Collaborators
modified_at: 2024-02-07 00:00:00
tags: app collaborators
---

## Context

Collaborators allow you to add other accounts to help you manage your application. Collaborators basically have all the features of an owner account. It is also useful if you want to [transfer ownership of an application](https://doc.scalingo.com/platform/app/lifecycle-management#transfer-ownership-of-an-application).

## Collaborators rights

### Collaborator can do

- Deploy
- Manage containers and addons
- View logs
- Access the review applications
- View metrics
- View activity
- Access the DB Dashboard
- Almost all user actions except those under

### Collaborator can't do

- Delete application
- Rename application
- Transfer application

## How to manage collaborators

### From the dashboard

You will the how to manage collaborators from the CLI there: [manage collaborators of the application](https://doc.scalingo.com/platform/cli/features#manage-collaborators-of-the-application)

- Go to your application that needs a new collaborator
- Go to the Settings tab
- You will automatically be taken to the Collaborators menu
- Click on the Add button
- Add the required collaborator email
- You will now see the collaborator in light grey in the table.
- The collaborator will receive an email to join the collaboration (and subscribe to Scalingo if required).
- Once done, you will see the collaborator in black.

{% note %}
To delete a collaborator, in the collaborator table, simply click on the trash can corresponding to the collaborator's mail and validate in the pop-up.
{% endnote %}

### From the CLI

There you will learn how to manage collaborators from the CLI: [manage collaborators of the application](https://doc.scalingo.com/platform/cli/features#manage-collaborators-of-the-application)

{% note %}
Delegating rights to collaborators is something that should be taken seriously. Even if they can't destroy your application, they have enough rights to disrupt your work.
{% endnote %}
