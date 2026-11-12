---
title: Manage your Projects
modified_at: 2026-11-12 00:00:00
tags: project management
index: 2
---


Projects are the way to organize your applications and resources on Scalingo.

[Learn more about Projects][projects-overview].


## Creating a new project

To create a project in an organization, you must be its administrator.

### Using the Dashboard {#create-using-the-dashboard}

1. Open your [Dashboard][dashboard]
1. Click the **Projects** tab
2. Click **Create a project** at the top of the list
3. Enter the project name (1–64 characters, using only a-z, 0-9, -, or _)
4. Choose the region where you want to create the project
5. Check the target context, then click **Create new project**

The Dashboard opens the new project. Click **Deploy an app** to create its first
application.

### Using the Command Line {#create-using-the-cli}

Make sure you have [set up the Scalingo command line tool][cli].

To create a project in your personal account:

```shell
scalingo projects-add test-project
```

To create a project in an organization, first find its slug:

```shell
scalingo orgs
```

The output shows each organization's **ID**, **SLUG** and your **ROLE**.

Pass the organization's slug with `--org` when creating the project:

```shell
scalingo projects-add --org my-org my-project
```

Without `--org`, you create the project in your personal account.

To create a new default project in your personal account, add `--default`:

```shell
scalingo projects-add --default test-project
```

### Using the Terraform Provider {#create-using-the-terraform-provider}

To create a project in your personal account:

```tf
resource "scalingo_project" "test-project" {
  name    = "test-project"
  default = true
}
```

The `default` attribute makes this the default project in your personal account.

To create a project in an organization, set `org` to the organization's slug:

```tf
resource "scalingo_project" "my_project" {
  name = "my-project"
  org  = "my-org-1"
}
```

Omit `org` to create the project in your personal account.


## Listing the projects

### Using the Dashboard {#list-using-the-dashboard}

1. Open your [Dashboard][dashboard]
2. Click the **Projects** tab

The Dashboard only lists projects in the selected context:

- Projects you created
- Projects containing a resource you collaborate on

Within each project, you only see resources you can access.

#### Finding a Project's ID

1. Select the project from the list
2. Go to **Settings** > **General**
3. Copy the **Project ID** from the **Project details** section

### Using the Command Line {#list-using-the-cli}

The CLI lists the projects you can access in your personal account and in
organizations you are a member of. The **ORGANIZATION** column identifies each
project's organization and is empty for projects in your personal account.

1. Make sure you have correctly [setup the Scalingo command line tool][cli]
2. From the command line, list the projects:
   ```shell
   scalingo projects
   ```
   The output should look like this:
   ```shell
     /!\  This command only displays projects where you are the owner
   ┌──────────────┬──────────────┬─────────┬──────────────────────────────────────────┐
   │     NAME     │ ORGANIZATION │ DEFAULT │                    ID                    │
   ├──────────────┼──────────────┼─────────┼──────────────────────────────────────────┤
   │ test-project │ my-org-1     │ false   │ prj-6731a609-02b6-4614-b28d-5abe43654333 │
   │ default      │              │ true    │ prj-20f1b7e4-cf4d-46e9-aff1-e47ae149c444 │
   └──────────────┴──────────────┴─────────┴──────────────────────────────────────────┘
   ```


Learn how to [choose an application's destination project][app-project].
{: #setting-the-project-at-app-creation}


## Updating a project

### Using the Dashboard {#update-using-the-dashboard}

If you want to update the `name` of your project, the steps are the following:

1. From your web browser, open your [dashboard][dashboard]
2. Click the **Projects** tab
3. (optional) You can filter the list of projects by clicking on `My projects` or `Other projects` and or type its name or a part of it in the search text box
4. On the row of the project you want to edit, click the `name` of the project
5. On the Dashboard of the project you want to edit, click **Settings** tab
6. In the **Settings** submenu, make sure to select **General**
7. In the **Project details**, click **Rename** button
8. Put the name of your choice (1-64 characters, using only a-z, 0-9, -, or _)
9. Click **Rename**

### Using the Command Line {#update-using-the-cli}

1. Make sure you have correctly [setup the Scalingo command line tool][cli]
2. From the command line, update a project name:
   ```shell
   scalingo projects-update --name=updated-test-project prj-6731a609-02b6-4614-b28d-5abe43654333
   ```
   The output should look like this:
   ```shell
   -----> test-project has been updated
   ```

### Using the Terraform Provider {#update-using-the-terraform-provider}

There is only one step required to update a project using Terraform. You need to
update the project with the desired attributes. For example:
   ```tf
   resource "scalingo_project" "test-project" {
     name = "updated-test-project"
   }
   ```


## Setting Your Default Project

When you create a resource without specifying a project, Scalingo uses your
default project. To change it, set another project as the default.

{% note %}
This preference applies only to your user account. It does not change the
default project for other collaborators or organization members.
{% endnote %}

### Using the Dashboard {#set-default-using-the-dashboard}

1. Open your [Dashboard][dashboard] and select **Projects**
2. Open the project you want to use as your default
3. Go to **Settings** > **General**
4. In **Project details**, click **Set [project name] as your default project**

### Using the Command Line {#set-default-using-the-cli}

Use `scalingo projects-update --default` with the project's ID:

```shell
scalingo projects-update --default prj-6731a609-02b6-4614-b28d-5abe43654333
```


## Transferring Projects

When you transfer a project, the new owner takes over ownership, administration
and billing for the project and all its resources.

{% note %}
Applications cannot be transferred individually. To change ownership, transfer
the entire project.
{% endnote %}

The transfer also affects billing for the current month. See
[how transfers affect consumption billing][transfer-billing].

### Transfer Ownership to a Collaborator {#transfer-project-ownership}

You can transfer a project to a collaborator only if the project is in your
personal account.

To transfer a project to a collaborator, the new owner must:

- Be a collaborator on all project resources, including applications and Dedicated
  Resources databases, and have accepted the invitations.
- Have an active [billing profile][billing].
- Have a valid payment method.
- Have left the free trial.
- Provide the required health professional contact details if the project contains
  HDS resources.

Once the new owner accepts the transfer:

- The previous owner is downgraded from **owner** to **collaborator** and keeps access to the project.
- The previous owner no longer has administrative rights on the project.

#### Using the Dashboard {#transfer-using-the-dashboard}

1. From your web browser, open your [dashboard][dashboard]
2. Click the **Projects** tab, then select the project you want to transfer
3. Click the **Settings** tab
4. In the **Transfer project ownership** section, click the **Transfer project** button
5. From the list, choose the collaborator who will become the new owner
6. Confirm the project name
7. Click **Transfer** to send the transfer request

### Transfer Ownership to an Organization {#transferring-a-personal-project-to-an-organization}

Resources keep running during the transfer, with the same configuration and
collaborators.

To transfer a project to an organization:

- You must own the personal project and have the **Admin** role in the destination
  organization.
- The organization must have a complete [billing profile][billing] and a valid,
  active payment method.
- Every existing collaborator on the project's resources must have accepted an
  invitation to that organization. Existing collaborator assignments are retained.
  Other members do not automatically receive resource access.

#### Using the Dashboard {#transfer-to-organization-using-the-dashboard}

1. Select **Personal account** and open the project.
2. Go to **Settings** > **General**.
3. In **Transfer project ownership**, under **Transfer ownership to an organization**,
   click **Transfer to an organization**.
4. Select the **Destination organization**.
5. Review any blocking conditions displayed by the Dashboard, then click **Transfer**.

If a check fails, the project remains in your personal account. After a successful
transfer, select the organization to access the project.


## Removing a project

A project can be removed only if this is not the default one, and no application is linked to it.

### Using the Dashboard {#remove-using-the-dashboard}

1. From your web browser, open your [dashboard][dashboard]
2. Click the **Projects** tab
3. (optional) You can filter the list of projects by clicking on `My projects` or `Other projects` and or type its name or a part of it in the search text box
4. On the row of the project you want to edit, click the `name` of the project
5. On the Dashboard of the project you want to edit, click **Settings** tab
6. In the **Settings** submenu, make sure to select **General**
7. Click **Delete project** button
8. In the popup, confirm the name of the project you want to delete
9. Click **Delete project [project name]**

### Using the Command Line {#remove-using-the-cli}

1. Make sure you have correctly [setup the Scalingo command line tool][cli]
2. From the command line, update a project:
   ```shell
   scalingo projects-remove prj-6731a609-02b6-4614-b28d-5abe43654333
   ```
   The output should look like this:
   ```shell
   -----> prj-6731a609-02b6-4614-b28d-5abe43654333 has been removed
   ```

### Using the Terraform Provider {#remove-using-the-terraform-provider}

There is only one step required to remove a project using Terraform. You just need to
remove the associated resource from the Terraform file.

[dashboard]: https://dashboard.scalingo.com/

[cli]: {% post_url tools/cli/2000-01-01-start %}
[projects-overview]: {% post_url platform/projects/2000-01-01-overview %}
[billing]: {% post_url platform/billing/2000-01-01-profile %}
[transfer-billing]: {% post_url platform/billing/2000-01-01-consumption-reports %}#current-consumption
[app-project]: {% post_url platform/app/2000-01-01-lifecycle-management %}#create-an-application
