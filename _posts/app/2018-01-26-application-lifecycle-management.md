---
title: Application Lifecycle Management
modified_at: 2018-02-09 00:00:00
category: platform
order: 5
tags: management
---

Three methods are co-existing to manage your applications on the Scalingo:

* [Web Dashboard](https://my.scalingo.com): The simplest way to manage your applications,
use any browser create/scale/transfer/delete applications.

* [CLI]({% post_url cli/2015-09-18-command-line-tool %}): More confortable with
terminals or you want to build scripts to control applications, the command
line interface, available for all major operating system, is able to achieve
any operation the web dashboard can do.

* [HTTP API](https://developers.scalingo.com): The web dashboard and the CLI
are both consuming this API, if you need to automate behaviors by managing
applications in a programmative way, you can directly target our API.

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

### Web Dashboard

**Where**: `Settings` tab of the application, button `TRANSFER THIS APP`

**Conditions**:

* Logged in user should be the application owner
* The receiver account should be collaborator of the application

**Actions**: Choose the collaborator and validate operation

See [Transfer the Ownership of an App]({% post_url app/2000-01-01-transfer-ownership %}) for more information.

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
