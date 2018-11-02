---
title: Application Lifecycle Management
nav: Lifecycle Management
index: 10
tags: management
---

Three methods are co-existing to manage your applications on the Scalingo:

* [Web Dashboard](https://my.scalingo.com): The simplest way to manage your applications,
use any browser create/scale/transfer/delete applications.

* [CLI]({% post_url platform/cli/2000-01-01-start %}): More comfortable with
terminals or you want to build scripts to control applications, the command
line interface, available for all major operating system, is able to achieve
any operation the web dashboard can do.

* [HTTP API](https://developers.scalingo.com): The web dashboard and the CLI
are both consuming this API, if you need to automate behaviors by managing
applications in a programmatic way, you can directly target our API.

## Create an Application

Creating an application is the first thing done on the platform. Once an app is
created, the possibility to deploy your code, provision databases, invite
collaborators are available.

### Web Dashboard

**Where**:
* Dashboard homepage, button `+ CREATE NEW APP`
* Any page of the dashboard, bottom-left button `+`

**Actions**: Give a name, choose addons and validate

### Command Line

The subcommand `create` is dedicated to creating applications:

```bash
$ scalingo create <appname>

# Create a new app with a custom Git remote
$ scalingo create my-app --remote staging

# Create a new app with a custom buildpack
$ scalingo create my-app --buildpack https://github.com/Scalingo/multi-buildpack
```

## Rename an Application

### Web Dashboard

**Where**: `Settings` tab of the application, button `RENAME THIS APP`

**Condition**: Logged in user should be the application owner

**Actions**: Fill confirmation form, choose a new name and click on `RENAME`

## Transfer Ownership of an Application

You may want to transfer an application to someone else. In this case you have to
invite this person as a collaborator of the application. Then you will be able to
transfer them the application.

This operation will not affect the application, nothing regarding the configuration
or the runtime of the app will be modified.

This operation is only achievable from the [Scalingo
dashboard](https://my.scalingo.com).

{% note %}
  The billing is done the last day of the month to the owner of the application at that date. Hence,
  transfering the ownership of an application the 4th of the month or the 30th at 11:59PM will not
  change anything. The owner at the date of billing is taken into account.
{% endnote %}

### Invite the future owner

1. Go in the collaborators tab
2. Invite the person you want to transfer the application to

### Accept the collaboration

*this step should be done by the user which has been invited*

1. Click on the validation link you've received by email, you'll have to login if you were unauthenticated.

The account is now collaborator of the application.

### Transfer to the new owner

1. Go in the 'Settings' tag
2. In the '*Transfer the application*' part, choose the collaborator which should receive the app
3. Validate the transfer

{% note %}
  *Note*: if you're handling both accounts, don't forget to log out between each step, otherwise the
  collaboration invitation won't be considered valid.
{% endnote %}

## Delete an Application

### Web Dashboard

**Where**: `Settings` tab of the application, button `DELETE THIS APP`

**Condition**: Logged in user should be the application owner

**Actions**: Fill confirmation form and validate operation

### Command Line

Subcommand `destroy`:

```bash
$ scalingo destroy <appname>

# Example
$ scalingo destroy my-app
/!\ You're going to delete my-app, this operation is irreversible.
To confirm type the name of the application: my-app
-----> App my-app has been deleted
```
