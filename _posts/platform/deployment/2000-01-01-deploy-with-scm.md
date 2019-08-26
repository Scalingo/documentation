---
title: Deploy with SCM
nav: SCM
modified_at: 2019-08-26 00:00:00
tags: github gitlab deployment
index: 3
---

To deploy your Scalingo application with a code hosted on one of our compatible SCM tool, you'll have to link it to the SCM repository and branch. The compatible SCM tools are:

- GitHub
- GitLab
- GitHub Enterprise
- GitLab self-hosted

## Link Your App to the SCM Tool

### Using the Web Dashboard

{% warning %}
The web dashboard is only compatible with GitHub. To integrate your application with another SCM tool, please refer to the section "Using the CLI" below.
{% endwarning %}

In the "Code" section in your dashboard, you'll find a category *Deploy with
GitHub*. Please click on `Link this app to GitHub` and check you are in the
right account, choose your GitHub user, and find your GitHub repository in the
list or with the search bar.

In order to link your Scalingo app to a GitHub repository, GitHub will prompt
for your authorization. You must accept for our GitHub integration to work.

Once your repository is linked, you'll be able to choose select the branch that
you want to deploy and if you want to deploy automatically (*Auto deploy*) or
manually (*Manual deploy*).

{% include github_permission.md %}

{% note %}
If your organization is not listed in the list of users when linking your app to
GitHub, you might need to give Scalingo access to this organization
repositories. Head to [this GitHub
page](https://github.com/settings/connections/applications/dce5163f63352f1a4d45){:target="_blank"}.
{% endnote %}

### Using the CLI

You can also use the CLI to link your application to an SCM-hosted repository.
You first need to link your Scalingo account with your account on the SCM tool:

```
$ scalingo integrations-add github-enterprise --url https://github.example.org --token <token>
```

Then, add and configure a link to the SCM-hosted repository with:

```
$ scalingo --app my-app integration-link-create https://github.example.org/my-company/my-app --auto-deploy --branch master
```

A comprehensive list of available configuration flags is available with:

```
$ scalingo help integration-link-create
```

## Auto Deploy

With Auto deploy enabled, your application will be deployed every time you push
on your repository.

## Manual Deploy

You can trigger a manual deployment by going to the "Manual deploy" section and
choose the branch to deploy.

{% assign img_url = "https://cdn.scalingo.com/documentation/screenshot_dashboard_github.png" %}
{% include mdl_img.html %}

This action is also available via the CLI with:

```
$ scalingo --app my-app integration-link-manual-deploy --branch master
```

## Review Apps

Review apps are special [child apps]({% post_url
platform/app/2000-01-01-child-apps %}) linked to a pull/merge request.

Review apps can be created automatically every time a pull request is opened or
they can be created manually by selecting the pull request to deploy among the
currently opened ones (our pull request viewer will help you with this).

By default, review apps are automatically destroyed when the pull request is
closed. But you can specify a duration after which the review app is destroyed.

For more information, you can read the more specific documentation pages [GitHub
integration, Auto Deploy and Review Apps]({% post_url
platform/app/2000-01-01-scm-integration %}) and [Review apps]({% post_url
platform/app/2000-01-01-review-apps %}).

## Some suggestions

You can also create a [child app]({% post_url platform/app/2000-01-01-child-apps
%}) which is not a review app.
