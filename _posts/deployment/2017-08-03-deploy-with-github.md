---
title: Deploy with GitHub
modified_at: 2017-08-03 00:00:00
category: deployment
tags: git deployment
order: 1
---

To deploy with GitHub, you'll have to create a new application on Scalingo, choose your addon if you need one and follow the command on the section deployment, like in Deploy with Git.

## Link your app to GitHub

In the section Code in your Dashboard, you'll find a category Deploy with GitHub. Please click on `Link this app to GitHub` and check you are in the right account, choose your GitHub user, and find your GitHub repo in the list or with the searchbar.

## Auto deploy or manual deploy?

Once your repo is linked, you'll have the choose to deploy automatically or manually your application in the same category Deploy with GitHub actualized. You'll have to select the branch that you want to deploy.

If you choose to deploy automatically, your application will be updated each time you'll push on your repo GitHub and we will add a new SSH key to your GitHub account.

If you choose to deploy manually you will have to active the deployment each time you want to update your application.

<img src="/assets/images/auto-manual-deploy.jpg" width="100%">

## Review apps

As for the deployment, the review apps could be create automatically for each pull request or for only certains pull requests, manually.

If you choose to create automatically review app, you'll have multiple option: to detroy the review app when the pull request is closed, to detroy the review app after some hours.

Your child aplication will have the same addons and environment variables, like your first application.

For more information, you must see the posts [GitHub integration, Auto Deploy and Review Apps]({% post_url integrations/2000-01-01-github-integration %}) and [Review apps]({% post_url integrations/2017-03-10-review-apps %}).

## Unlink your repo GitHub

The first line under the title of the category Deploy with GitHub remembers you your repo link. There is also the button to `unlink` the application.

## Some suggestions

You can also create a [child app]({% post_url app/2017-03-10-child-apps %}) which is not a review app.
