---
layout: page
title: Source Code Management Integration, Auto Deploy and Review Apps
nav: SCM Integration
modified_at: 2025-01-27 00:00:00
tags: integration scm github github-enterprise gitlab
index: 30
---

Scalingo provides a deep **integration with Source Code Management (SCM)
tools** such as GitHub and
GitLab. It includes features like auto-deployment when the code is modified on
the SCM repository, deploying directly from a branch, automatic building and
deployment of *Pull Requests*, and much more.

More info about supported SCM tool:

* [Deploy with GitHub]({%
post_url platform/deployment/2000-01-01-deploy-with-github %})
* [Deploy with GitLab]({%
post_url platform/deployment/2000-01-01-deploy-with-gitlab %})

## The GitHub Flow

Like most team of developers, we follow the [GitHub
flow](https://guides.github.com/introduction/flow) to integrate new lines of
code in our code base. This workflow follows these rules:

* Anything in the **master** branch is always deployable.
* Create a new branch **based on master** for each new feature or fix.
* Commit your changes on this new branch and push them to `origin` remote.
* When you need feedback, help or you think the branch is ready for merging,
  open a **pull request**.
* After someone else has reviewed and signed off the patch, you can merge it
  into `master`.
* Once it is merged and pushed to `master` on the `origin`, you can and should
  deploy immediately.

{% note %}
Despite its name, the GitHub flow is perfectly suitable if your code is hosted
on a different SCM platform such as GitLab. Read again the GitHub flow
explanation, just replace "pull request" with "merge request", and you're all
aware of how it works on GitLab-hosted code!
{% endnote %}

Our **deep SCM integration** aims at automating this workflow.

## The SCM Integration

The SCM Integration is available in the "Code" section of your dashboard.

To enable the SCM integration features on your Scalingo app, you first need to
link it to a repository hosted on one of our compatible SCM integrations. You
can only link your app to a repository that you owned or which is owned by one
of your organizations.

Under the hood, we will add a webhook on your repository that will notify the
Scalingo platform for each event generated in your repository life cycle: like
"Push", "New pull/merge request", etc.

After having linked your application to an SCM-hosted repository, the "Code"
section of your dashboard is composed of two mains parts: **Auto Deploy** and
**Review Apps**.

## Deployments

You can configure your Scalingo application to be automatically deployed
whenever a commit occurs on a given branch. This is especially useful, for
instance, if you want the application to always be in sync with the `production`
branch of your repository.

You may have Continuous Integration (CI) tools associated with your repository
like [CodeShip](https://codeship.com/), [Travis CI](https://travis-ci.com/) or [Github Actions](https://github.com/features/actions)
which run tasks, tests or whatever. We will always wait that all these tools
**succeed** before deploying your app.

You can also manually trigger a deployment of your application from any branch.

## Review Apps

Review apps are an awesome tool to discuss about new features with your
teammates. Whenever you create a new Pull Request (or Merge Request in the
GitLab world), you can create a new application, called a *Review App*, with the
code of the new feature. It is then easy to share the result of your work! If
you push a modification to the Pull/Merge Request, it will automatically be
deployed in your Review App.

When the Pull/Merge Request is closed, Scalingo automatically deletes the
Review App.

You can either automatically create a new Review App for each Pull/Merge
Request opened on your repository or manually deploy a Review App.

You can find more information about Review Apps on our [documentation
page]({% post_url platform/app/2000-01-01-review-apps %}).

This feature is related to pull/merge requests and has a [dedicated
documentation page]({% post_url platform/app/2000-01-01-review-apps %}).
