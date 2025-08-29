---
title: Manage your projects
modified_at: 2025-08-29 07:00:00
tags: project management
index: 2
---

## Introduction

Projects help to structure your resources by gathering them. They're the first milestone of features that will come later like network isolation for instance.

The project named **⭐ default** is present by default and is set as a default project on existing Apps.

{% note %}
You're encouraged to assign your apps to projects now.
By doing this, you prepare the arrival of some of the future features, that in the end will make the gathering of resources per projects necessary.
{% endnote %}

## Setting the project at App creation

### Using the Dashboard

Within the App creation wizard, the section **Project** enables you to set a project different from **⭐ default**.

If the project you'd like to set against the new App, doesn't exist, proceed as follows:

1. Click **+ New project**
2. Enter the project name of your choice (only characters a-Z 0-9 - _ are allowed)
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
   ┌─────────────────────────────┬──────────┬─────────────────────────────────┐
   │            NAME             │ DEFAULT  │               ID                │
   ├─────────────────────────────┼──────────┼─────────────────────────────────┤
   │ project_boo                 │ false    │ prj-0c1ab18c-6ac8-4f85-b55e-b14 │
   │ projectBar                  │ false    │ prj-0c1ab74c-6ac8-7k125-b5e-b7  │
   | default                     │ true     │ prj-0c1adc1c-1ad8-4f85-b55e-z9  │
   └─────────────────────────────┴──────────┴─────────────────────────────────┘
   ```

3. From the command line, set the project at the app creation step:

   ```shell
   scalingo create --project-id=prj-6731a609-02b6-4614-b28d test-app
   ```
   The output should look like this:
   ```shell
   App 'test-app' has been created
   To deploy your application, run these commands in your GIT repository:
   ...
   ```
Here you've created the App named `test-app` and set the project, which id is `prj-6731a609-02b6-4614-b28d`, on it

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
5. In the **Settings** submenu, make sure to select **App management**
6. In the section **Parent project**, click **Move app to another project**


If the project isn't already existing, proceed as follows:

1. Click **+ New project** 
2. Enter the project name of your choice (only characters a-Z 0-9 - _ are allowed)
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
For the moment, listing the projects will return only projects where you are the owner.
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

This feature is not yet available in the dashboard.

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

[cli]: {% post_url platform/cli/2000-01-01-start %}