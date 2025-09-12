---
title: Manage your Projects
modified_at: 2025-09-09 07:00:00
tags: project management
index: 2
---

Projects are the way to organize your applications and resources on Scalingo.

[Learn more about Projects][projects-overview].

{% warning %}
We strongly recommend grouping your applications into projects before **March 1, 2026**. After this date, applications can no longer be regrouped between projects except by recreating them in the target project.
{% endwarning %}

## Setting the project at App creation

### Using the Dashboard

Within the App creation wizard, the section **Project** enables you to set a project different from **default**.

If the project you'd like to set against the new App, doesn't exist, proceed as follows:

1. Click **+ New project**
2. Enter the project name of your choice (1–64 characters, using only a-z, 0-9, -, or _)
3. Click **Add**

If the project is in the list
1. Select the project you want
2. Proceed with the next steps of your app creation

### Using the Command Line

1. Make sure you have correctly [setup the Scalingo command line tool][cli]
2. From the command line, list the projects:
   ```shell
   scalingo projects
   ```
   The output should look like this:
    ```shell
    /!\  This command only displays projects where you are the owner
   ┌──────────────┬─────────┬──────────────────────────────────────────┐
   │     NAME     │ DEFAULT │                    ID                    │
   ├──────────────┼─────────┼──────────────────────────────────────────┤
   │ test-project │ false   │ prj-6731a609-02b6-4614-b28d-5abe43654333 │
   │ default      │ true    │ prj-20f1b7e4-cf4d-46e9-aff1-e47ae149c444 │
   └──────────────┴─────────┴──────────────────────────────────────────┘
   ```

3. From the command line, set the project at the app creation step:

   ```shell
   scalingo create --project-id=prj-6731a609-02b6-4614-b28d-5abe43654333 test-app
   ```
   The output should look like this:
   ```shell
   App 'test-app' has been created
   To deploy your application, run these commands in your GIT repository:
   ...
   ```
Here you've created the app named `test-app` and set the project ID to `prj-6731a609-02b6-4614-b28d-5abe43654333`.

### Using the Terraform Provider

1. Place the following `project_id` in the app `resource` block in your Terraform file:
   ```tf
   resource "scalingo_app" "test_app" {
     name = "terraform-testapp"
     project_id = "prj-6731a609-02b6-4614-b28d-5abe43654333"
   }
   ```

## Updating the project of an existing App

### Using the Dashboard

1. From your web browser, open your [dashboard][dashboard]
2. Click the **Apps** tab
3. Click on the application for which you want to manage the project
4. Click the **Settings** tab
5. In the **Settings** submenu, make sure to select **General**
6. In the section **Parent project**, click **Move app to another project**


If the project isn't already existing, proceed as follows:

1. Click **+ New project**
2. Enter the project name of your choice (1-64 characters, using only a-z, 0-9, -, or _)
3. Click **Add**


If the project is in the list

1. Select the project you want
2. Click **Move app to project**

### Using the Command Line

This feature is not yet available in the CLI.

### Using the Terraform Provider

This feature is not yet available in the Terraform Provider.

## Listing the projects

{% warning %}
For the moment, listing projects will only return those where you are the owner.
{% endwarning %}

### Using the Dashboard

Right now it is only possible to list the projects when creating a new application.

### Using the Command Line

1. Make sure you have correctly [setup the Scalingo command line tool][cli]
2. From the command line, list the projects:
   ```shell
   scalingo projects
   ```
   The output should look like this:
   ```shell
     /!\  This command only displays projects where you are the owner
   ┌──────────────┬─────────┬──────────────────────────────────────────┐
   │     NAME     │ DEFAULT │                    ID                    │
   ├──────────────┼─────────┼──────────────────────────────────────────┤
   │ test-project │ false   │ prj-6731a609-02b6-4614-b28d-5abe43654333 │
   │ default      │ true    │ prj-20f1b7e4-cf4d-46e9-aff1-e47ae149c444 │
   └──────────────┴─────────┴──────────────────────────────────────────┘
   ```

## Creating a new project

### Using the Dashboard

Right now it is only possible to create a new project when creating a new application or when moving an existing application to another project.

### Using the Command Line

1. Make sure you have correctly [setup the Scalingo command line tool][cli]
2. From the command line, create a project:
   ```shell
   scalingo projects-add test-project
   ```
   The output should look like this:
   ```shell
   -----> test-project has been created
   ```
   You can also create a new project that will be default directly:
   ```shell
   scalingo projects-add --default test-project
   ```

### Using the Terraform Provider

1. Place the following `resource` block in your Terraform file:
   ```tf
   resource "scalingo_project" "test-project" {
     name = "test-project"
     default = true
   }
   ```

## Updating a project

Two attributes can be updated: `name` and `default`.

{% note %}
   `default` cannot be changed from true to false. To change the default project, update an existing project to be the new default one, or create a new default project.
{% endnote %}

### Using the Dashboard

1. From your web browser, open your [dashboard][dashboard]
2. Click the **Apps** tab
3. Click on the application for which you want to edit the project
4. Click the **Settings** tab, make sure to select **General**
5. Click **`your-project` settings** (where `your-project` is the current name of the project you want to edit)
6. Edit either the `name` of the project or tick the checkbox to make it the `default` project or update both
7. Click **Edit**

### Using the Command Line

1. Make sure you have correctly [setup the Scalingo command line tool][cli]
2. From the command line, update a project name:
   ```shell
   scalingo projects-update --name=updated-test-project prj-6731a609-02b6-4614-b28d-5abe43654333
   ```
   The output should look like this:
   ```shell
   -----> test-project has been updated
   ```
   You can also update a project to become the new default:
   ```shell
   scalingo projects-update --default prj-6731a609-02b6-4614-b28d-5abe43654333
   ```

### Using the Terraform Provider

There is only one step required to update a project using Terraform. You need to
update the project with the desired attributes. For example:
   ```tf
   resource "scalingo_project" "test-project" {
     name = "updated-test-project"
   }
   ```

## Removing a project

A project can be removed only if this is not the default one, and no application is linked to it.

### Using the Dashboard

This feature is not yet available in the dashboard.

### Using the Command Line

1. Make sure you have correctly [setup the Scalingo command line tool][cli]
2. From the command line, update a project:
   ```shell
   scalingo projects-remove prj-6731a609-02b6-4614-b28d-5abe43654333
   ```
   The output should look like this:
   ```shell
   -----> prj-6731a609-02b6-4614-b28d-5abe43654333 has been removed
   ```

### Using the Terraform Provider

There is only one step required to remove a project using Terraform. You just need to
remove the associated resource from the Terraform file.

[dashboard]: https://dashboard.scalingo.com/

[cli]: {% post_url tools/cli/2000-01-01-start %}
[projects-overview]: {% post_url platform/projects/2000-01-01-overview %}
