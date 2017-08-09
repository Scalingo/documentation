---
title: Application Management
modified_at: 2017-08-08 00:00:00
category: platform
order: 5
tags: management
---


To manage your application on Scalingo, you can use [the Dashboard](https://my.scalingo.com) or [the CLI]({% post_url cli/2015-09-18-command-line-tool %}#features), our Command Line Tool .
Every request are also posibles with our API, please see our [documentation](https://developers.scalingo.com).

## Create an Application

### Use the Dashboard

On your [dashboard homepage](https://my.scalingo.com) you will find a button `+ CREATE NEW APP`. You have to choose a name for your application, you can select some addons and initialize your first deployment. 

<img src="/assets/images/dashboard.png" width="100%">

### Use the CLI

The command will be `scalingo create`:

```bash
scalingo create my-new-app

# Create a new app with a custom GIT remote
scalingo create my-new-app --remote staging
scalingo create my-new-app --remote production
scalingo create my-new-app --remote custom
```

## Rename an Application

### Use the Dashboard

You have to select your application on the menu and go on `Settings`. There you will see a link called `RENAME THIS APP`.

## Transfer ownership of an Application

### Use the Dashboard

You have to select your application on the menu and go on `Settings`. There you will see a section called 'Transfer ownership of this app'.

You have a list where you will find all collaborator on this app. After having choose a collaborator, you can click on `TRANSFER THIS APP`.

If you have no collaborator yet, there is a link `Add one!` to add one.

See [Transfer the Ownership of an App]({% post_url app/2000-01-01-transfer-ownership %}) for more informations.

## Delete an Application

### Use the Dashboard

You have to select your application on the menu and go on `Settings`. There you will see a link called 'DELETE THIS APP'.

### Use the CLI

The command will be `scalingo destroy`:

```bash
scalingo destroy my-app
```
