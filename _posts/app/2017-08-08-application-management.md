---
title: Application Management
modified_at: 2017-08-08 00:00:00
category: platform
order: 5
tags: management
---


To manage your application on Scalingo, you can use [the Dashboard](https://my.scalingo.com), [the CLI]({% post_url cli/2015-09-18-command-line-tool %}#features) or [the API](https://developers.scalingo.com/apps.html#create-an-application).
For all request with our API, you will need your `auth-token` which is specific for Scalingo. You can find it on your [dashboard](https://my.scalingo.com/profile) or from our [API](https://developers.scalingo.com/index.html#authentication).

## Create an Application

### [Use the Dashboard](https://my.scalingo.com)

On your dashboard homepage you will find a button `+ CREATE NEW APP`. You have to choose a name for your application, you can select some addons and initialize your first deployment. 

<img src="/assets/images/dashboard.png" width="100%">

### [Use the CLI]({% post_url cli/2015-09-18-command-line-tool %}#features)

The command will be `scalingo create`:

```bash
scalingo create my-new-app

# Create a new app with a custom GIT remote
scalingo create my-new-app --remote staging
scalingo create my-new-app --remote production
scalingo create my-new-app --remote custom
```

### [Use the API](https://developers.scalingo.com/apps.html#create-an-application)

You need to make a POST request on `https://api.scalingo.com/v1/apps`:

```bash
curl -H "Accept: application/json" -H "Content-Type: application/json" -u :$AUTH_TOKEN \
    -X POST 'https://api.scalingo.com/v1/apps' -d \
    '{
        "app": {
            "name": "example-app"
        }
    }'
```

## Rename an Application

### [Use the Dashboard](https://my.scalingo.com/apps)

You have to select your application on the menu and go on `Settings`. There you will see a link called `RENAME THIS APP`.

### [Use the API](https://developers.scalingo.com/apps.html#rename-an-application)

You need to make a POST request on `https://api.scalingo.com/v1/apps/[:app]/rename`:

```bash
curl -H "Accept: application/json" -H "Content-Type: application/json" -u :$AUTH_TOKEN \
    -X POST 'https://api.scalingo.com/v1/apps/example-app' -d \
    '{
        "current_name": "example-app",
        "new_name": "renamed-example-app"
    }'
```

## Transfer ownership of an Application

### [Use the Dashboard](https://my.scalingo.com)

You have to select your application on the menu and go on `Settings`. There you will see a section called 'Transfer ownership of this app'.

You have a list where you will find all collaborator on this app. After having choose a collaborator, you can click on `TRANSFER THIS APP`.

If you have no collaborator yet, there is a link `Add one!` to add one.

See [Transfer the Ownership of an App]({% post_url app/2000-01-01-transfer-ownership %}) for more informations.

### [Use the API](https://developers.scalingo.com/apps.html#transfer-ownership-of-an-application)

You need to make a PATCH request on `https://api.scalingo.com/v1/apps/[:app]`:

```bash
curl -H "Accept: application/json" -H "Content-Type: application/json" -u :$AUTH_TOKEN \
    -X POST 'https://api.scalingo.com/v1/apps/example-app' -d \
    '{
        "app": {
            "owner": {
                "email": "user2@example.com"
            }
        }
    }'
```

## Delete an Application

### [Use the Dashboard](https://my.scalingo.com)

You have to select your application on the menu and go on `Settings`. There you will see a link called 'DELETE THIS APP'.

### Use the CLI

The command will be `scalingo destroy`:

```bash
scalingo destroy my-app
```

### [Use the API](https://developers.scalingo.com/apps.html#delete-an-application)

You need to make a DELETE request on `https://api.scalingo.com/v1/apps/[:app]`:

```bash
curl -H "Accept: application/json" -H "Content-Type: application/json" -u :$AUTH_TOKEN \
    -X DELETE 'https://api.scalingo.com/v1/apps/example-app?current_name=example-app'
```
