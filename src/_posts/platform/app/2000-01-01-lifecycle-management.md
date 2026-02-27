---
title: Application Lifecycle Management
nav: Lifecycle Management
modified_at: 2026-02-27 07:00:00
index: 10
tags: management
---


On Scalingo, an application is the resource that packages and runs your code on 
the platform. It combines a codebase, its environment configuration, and one or 
more processes executed in containers. From this entity, you deploy new versions, 
manage its scaling, and manage add-ons and collaborators.


## Create an Application

Three methods are co-existing to manage your applications on the Scalingo:

- [Dashboard][dashboard]: The simplest way to manage your applications, use
  any browser to create, scale or delete applications.

- [CLI][cli]: More comfortable with terminals or you want to build scripts to
  control applications, the command line interface, available for all major
  operating system, is able to achieve any operation the dashboard can do.

- [HTTP API][api]: The dashboard and the CLI are both consuming this API,
  if you need to automate behaviors by managing applications in a programmatic
  way, you can directly target [our API][api] via [our SDK][sdk].

### Using the Dashboard

1. From your web browser, open your [dashboard][dashboard]
2. Click the **Create an application +** button
3. In the **Basic information** section:
   - Enter the application name
   - Select the target region
   - Select the target project
4. (optional) If your workload is subject to French HDS requirements, check
   **Health data hosting (compliant with the French HDS standard)**. See
   [Create an HDS Application](#create-an-hds-application)
5. Click **Create app**
6. In the **Deployment method** section, select your Git provider and choose
   the repository you want to deploy
7. Confirm the repository selection to create the application

### Command Line

The subcommand `create` is dedicated to creating applications:

```bash
$ scalingo create <appname>

# Create a new app with a custom Git remote
$ scalingo create my-app --remote staging

# Create a new app with a custom buildpack
$ scalingo create my-app --buildpack https://github.com/Scalingo/multi-buildpack

# Create a new app in the chosen project
$ scalingo create --project-id=prj-6731a609-02b6-4614-b28d-5abe43654333 my-app
```

## Create an HDS Application

If your workload hosts personal health data in a context subject to 
[French HDS requirements][hds-page], create an HDS application from the 
beginning.

1. [Create a new application](#create-an-application)
2. During creation, enable HDS:
   - Dashboard: check `Health data hosting (compliant with the French HDS standard)`
   - CLI: use the `--hds-resource` flag
   - Terraform: set `hds_resource = true`
3. Accept the latest version of the HDS contract appendix
4. Create or update your [Health Professional Point of Contact][hds-poc]

{% note %}
HDS must be enabled when the application is created. It is not possible to
convert an existing non-HDS application to HDS afterward.
{% endnote %}


## Rename an Application

### Using the Dashboard

1. From your web browser, open your [dashboard][dashboard]
2. Click on the application you want to rename
3. Click the **Settings** tab
4. In **Application details**, click the **Rename** button
5. Enter the new application name in the confirmation form
6. Confirm by clicking **Rename**

{% note %}
Only the application owner can rename the application.
{% endnote %}

{% note %}
The [SCM link][scm] is not updated when renaming an application. You should
recreate it by yourself.
{% endnote %}


## Transfer Ownership of an Application

{% warning %}
This application transfer ownership feature is deprecated in favour of complete 
project transfer.
{% endwarning %}

Our platform is evolving to improve performance and resilience. As part of this evolution,
our internal network has been re-architected and is now segmented into multiple subnets.

Because of this new architecture, it is no longer possible to move an application to
another project or transfer it to another owner:

- To change project, recreate and redeploy the application in the target project.
- To change owner, transfer the entire project or redeploy the application in the
  new context.

{% note %}
If you need assistance, contact Support.
{% endnote %}


## Delete an Application

### Using the Dashboard

1. From your web browser, open your [dashboard][dashboard]
2. Click on the application you want to delete
3. Click the **Settings** tab
4. Click the **Delete app** button
5. Fill the confirmation form
6. Confirm the deletion

{% note %}
Only the application owner can delete the application.
{% endnote %}

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


[dashboard]: https://dashboard.scalingo.com
[dashboard-billing]: https://dashboard.scalingo.com/billing
[api]: https://developers.scalingo.com

[sdk]: {% post_url tools/2000-01-01-software-development-kit %}
[cli]: {% post_url tools/cli/2000-01-01-start %}
[scm]: {% post_url platform/app/2000-01-01-scm-integration %}
[hds-page]: {% post_url platform/2000-01-01-hds %}
[hds-poc]: {% post_url compliance/2000-01-01-hds %}#en-hds-health-professional-point-of-contact
