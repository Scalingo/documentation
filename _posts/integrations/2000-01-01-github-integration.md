---
layout:      page
title:       "GitHub integration, Auto Deploy and Review Apps"
modified_at: 2017-03-13 10:00:00
category: integration
tags: integration github
---

Scalingo provides a deep **GitHub integration** with new capabilities of autodeployment when the code is hosted in a GitHub repository, deploying directly from a GitHub branch, automatic building and deployment of *Pull Requests*, and much more. GitHub has particularly good interoperability capabilities that we've used to deliver a powerful and well integrated GitHub based workflow.

## The GitHub Flow

Like most team of developers on GitHub, we follow the [GitHub flow](https://guides.github.com/introduction/flow) to integrate new lines of code in our codebase. This worflow follows these rules:

* Anything in the **master** branch is always deployable
* Create a new branch **based on master** for each new feature or fix
* Commit your changes on this new branch and push the to the GitHub remote
* When you need feedback or help or you think the branch is ready for merging, open a pull request
* After someone else has reviewed and signed off the patch, you can merge it into master
* Once it is merged and pushed to ‘master' on the origin, you can and should deploy immediately

Our **deep GitHub integration** aims at automating this workflow.

## The GitHub Integration

The GitHub Integration is available in the ‘Code' section of your dashboard. It is composed of two mains parts: **Auto deploy** and **Review apps**.

To enable GitHub relative features on your Scalingo app, you have to link it to a GitHub repository. You can only link your app to a repository that you owned or which is owned by one of your organizations. *Note: If it is an organization repository make sure that you have admin access on it*.

Under the hood, we will add a webhook on your repository that will notify the Scalingo platform for each event generated in your repository life cycle: like ‘Push', ‘New pull request', etc.

## Auto Deploy

Once your app is linked, you can enable ‘Auto deploy' from a given branch of your repository. It means that your app will be **strongly** linked to the selected branch, a new deployment of the application will be started each time the code of this branch is updated on GitHub.

You may have continuous integration tools associated to your repository like [CodeShip](https://codeship.com/) or [TravisCI](https://travis-ci.com/) which run tasks, tests or whatever. We will always **wait that all GitHub statuses succeeds** before deploying your app.

## Manual Deploy

The manual deploy feature lets you instantly deploy a branch from the GitHub repository linked to your Scalingo app. It can be useful to quickly deploy your app or in the case of you're not having access to a computer having a proper git installation and you edited code directly on GitHub.

{% assign img_url = "https://cdn.scalingo.com/blog/20161020-github-integration/auto_deploy.png" %}
{% include mdl_img.html %}

## Review Apps

Review apps are a **powerful collaboration tool** to discuss about a new features between members of your organization.

This feature is related to Pull Requests and has a [dedicated documentation page]({% post_url integrations/2017-03-10-review-apps %}).
