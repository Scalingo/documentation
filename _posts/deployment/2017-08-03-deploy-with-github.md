---
title: Deploy with GitHub
modified_at: 2017-08-03 00:00:00
category: deployment
tags: git deployment
order: 1
---

To deploy with GitHub you'll have to create a new application on Scalingo and link it to a GitHub repository and branch.

## Link your app to GitHub

In the section Code in your Dashboard, you'll find a category *Deploy with GitHub*. Please click on `Link this app to GitHub` and check you are in the right account, choose your GitHub user, and find your GitHub repository in the list or with the search bar.

In order to link your Scalingo app to a GitHub repository, GitHub will prompt for your authorization. You must accept for our GitHub integration to work.

Once your repository is linked, you'll be able to choose select the branch that you want to deploy and if you want to deploy automatically (*Auto deploy*) or manually (*Manual deploy*).

## Auto deploy

With Auto deploy enabled, your application will be deployed every time you push on your GitHub repository.

## Manual deploy

You can trigger a manual deployment by going to the "Manual deploy" section and choose the branch to deploy.

{% assign img_url = "https://cdn.scalingo.com/documentation/screenshot_dashboard_github.png" %}
{% include mdl_img.html %}

## Review apps

Review apps are special [child apps]({% post_url app/2017-03-10-child-apps %}) linked to a GitHub pull request.

Review apps can be created automatically every time a pull request is opened or they can be created manually by selecting the Pull Request to deploy among the currently opened ones (our Pull Request viewer will help you with this).

By default Review apps are automatically destroyed when the pull request is closed. But you can specify a duration after which the Review App is destroyed.

For more information, you can read the more specific documentation pages [GitHub integration, Auto Deploy and Review Apps]({% post_url integrations/2000-01-01-github-integration %}) and [Review apps]({% post_url integrations/2017-03-10-review-apps %}).

## Some suggestions

You can also create a [child app]({% post_url app/2017-03-10-child-apps %}) which is not a review app.
