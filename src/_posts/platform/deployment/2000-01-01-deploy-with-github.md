---
title: Deploy with GitHub and GitHub Enterprise
nav: Deploy with GitHub
modified_at: 2021-09-28 00:00:00
tags: scm github github-enterprise deployment
index: 5
---

You can deploy your Scalingo application with a code hosted on GitHub or GitHub
Enterprise. You will have to link it to a GitHub repository and branch.

## Link Your App to GitHub

### Using the Web Dashboard

In the "Code" section in your dashboard, you'll find a category *Deploy with
GitHub*. Please click on `Link this app to GitHub` and check you are in the
right account. Choose your GitHub user, and find your GitHub repository in the
list or with the search bar.

{% note %}
If your organization is not listed in the list of users when linking your app to
GitHub, you might need to give Scalingo access to this organization
repositories. Head to [this GitHub
page](https://github.com/settings/connections/applications/dce5163f63352f1a4d45){:target="_blank"}.
{% endnote %}

In order to link your Scalingo app to a GitHub repository, GitHub will prompt
for your authorization. You must accept for our GitHub integration to work.

Once your repository is linked, you'll be able to choose the branch you want to
deploy and if you want to deploy it automatically (*Auto deploy*) or manually
(*Manual deploy*).

{% include github_permission.md %}

### Using the CLI

You can also use the CLI to link your application to an SCM-hosted repository.
You first need to link your Scalingo account with your account on the SCM tool:

* For GitHub:

```
$ scalingo integrations-add github
```

* For GitHub Enterprise:

```
$ scalingo integrations-add --url https://github.example.org --token <token> github-enterprise
```

The token you need is a personal access token. Here is the [GitHub
documentation](https://help.github.com/articles/creating-a-personal-access-token-for-the-command-line)
on how to create one. The only scope you need on Scalingo is `repo`.

Then, add and configure a link to the SCM-hosted repository with:

```
$ scalingo --app my-app integration-link-create --auto-deploy --branch master https://github.example.org/my-company/my-app
```

A comprehensive list of available configuration flags is available with:

```
$ scalingo help integration-link-create
```

## Deployments

When your application is linked to the GitHub repository some deployments
options are available:

{% assign img_url = "https://cdn.scalingo.com/documentation/screenshot_dashboard_github.png" %}
{% include mdl_img.html %}

With "Auto deploy" enabled, your application will be deployed every time you
push to a selected branch of your repository.

You can trigger a manual deployment by going to the "Manual deploy" section and
choose the branch to deploy.

These actions are also available via the CLI with:

```
$ scalingo --app my-app integration-link-update --auto-deploy --branch master
$ scalingo --app my-app integration-link-manual-deploy --branch master
```

## Review Apps

Review apps are special type of applications linked to a pull request.  They can
be created automatically every time a pull request is opened or they can be
created manually by selecting the pull request to deploy among the currently
opened ones (our pull request viewer will help you with this).

By default, review apps are automatically destroyed when the pull request is
closed. But you can specify a duration after which the review app is destroyed.

{% assign img_url = "https://cdn.scalingo.com/documentation/screenshot_dashboard_github_review_apps.png" %}
{% include mdl_img.html %}

For more information, you can read the more specific documentation pages [SCM
integration, Auto Deploy and Review Apps]({% post_url
platform/app/2000-01-01-scm-integration %}) and [Review Apps]({% post_url
platform/app/2000-01-01-review-apps %}).

These actions are also available via the CLI with:

```
$ scalingo --app my-app integration-link-update --deploy-review-apps --destroy-on-close
$ scalingo --app my-app integration-link-manual-review-app 4
```

## Some suggestions

You can also create a [child app]({% post_url platform/app/2000-01-01-child-apps
%}) which is not a review app.
