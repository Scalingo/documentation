---
title: Application Lifecycle Management
nav: Lifecycle Management
modified_at: 2025-07-10 12:00:00
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
  any browser to create, scale, transfer, or delete applications.

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

You may want to transfer an application to someone else. In this case you have to
invite this person as a collaborator of the application. Then you will be able to
transfer them the application.

{% note %}
The new owner will need a [Billing Profile][billing] and will have left the free trial. To leave free trial period with billing profile go to [Billing][dashboard-billing] and click on Stop free trial button.
If it's an HDS application, the new owner will need to configure a health professional contact, just like the previous owner.
{% endnote %}

This operation will not affect the application, nothing regarding the configuration
or the runtime of the app will be modified.

This operation is only achievable from the [Scalingo dashboard][dashboard].

{% note %}
  The billing is done the last day of the month to the owner of the application at that date. Hence,
  transfering the ownership of an application the 4th of the month or the 30th at 11:59PM will not
  change anything. The owner at the date of billing is taken into account.
{% endnote %}

### Using the Dashboard

1. From your web browser, open your [dashboard][dashboard]
2. Click on the application you want to transfer
3. Click the **Settings** tab
4. In the **Collaborators** section, invite the future owner if they are not
   already a collaborator
5. Ask the invited user to accept the invitation from the confirmation e-mail
6. In the **Transfer the application** section, select the collaborator who
   should receive ownership
7. Confirm the transfer

After the transfer, the previous owner becomes a collaborator of the application.

{% note %}
If you're handling both accounts, don't forget to log out between each step, 
otherwise the collaboration invitation won't be considered valid.
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
[billing]: {% post_url platform/billing/2000-01-01-profile %}
[hds-page]: {% post_url platform/2000-01-01-hds %}
[hds-poc]: {% post_url compliance/2000-01-01-hds %}#en-hds-health-professional-point-of-contact
