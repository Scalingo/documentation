---
title: Review apps
modified_at: 2017-03-10 00:00:00
category: integration
tags: app review apps
---

Review apps are a *powerful collaboration tool* to discuss about a new features between members of your organization. We implemented this feature as part of our [GitHub integration]({% post_url integrations/2000-01-01-github-integration %}).

## What are review apps?

Let say that you have worked some hours on an awesome new feature. It's time to show the world your work and to open a new Pull Request (PR) on GitHub (even if it's not fully done). With Review Apps enabled on Scalingo, we will create a new application (a Review App) with the code of the new feature. You can now easily share the result of your work, to get it validated, with all people involved, even if they are not in the tech field.

Maybe they will tell you to change something like adding tests or to change a button color. You just have to push your modification on the branch involved in the PR to update the Review App.

Once all of our teammates are satisfied and the PR is closed, we will automatically delete the review app. You can disable this behavior or add a delay to fit your needs. This latter setting means that you can still review PR after your dev team has closed the PR.

If you don't want to create a new review app for each PR you can also choose among open PRs of your app to manually deploy a review app.

{% assign img_url = "https://cdn.scalingo.com/blog/20161020-github-integration/review_apps.png" %}
{% include mdl_img.html %}

## What about Addons, collaborators and environment variables?

If you've enabled Review Apps, a new application will be created every time a new Pull Request is opened in your GitHub repository. This new application is a child application (we'll see later this year which new exciting stuff this specification will help us build). This child app will have a copy of add-ons, collaborators and environment variables from the parent application.

Most of the time you want to customize those 3 things. That's where the new postdeploy hooks and manifest come in handy. Combining those two powerful features, you can tailor exactly how child apps are configured and their behaviors.

As a quick example, here is a sample `scalingo.json` that customize the environment variable `CANONICAL_HOST_URL` for a child app:

```
{
  "env": {
    "CANONICAL_HOST_URL": {
      "generator": "url"
    }
  }
}
```

Here, the value of the environment variable CANONICAL_HOST_URL will contain the URL to reach the newly deployed app. The `scalingo.json` configuration always takes precedence on parent app configuration.

## Is it possible to create Review Apps if my code is hosted at a different place?

We only implement directly Review Apps for code hosted on GitHub. However it is very easy for you to set it up for your specific case thanks to the Scalingo API:

* Create a [child application]({% post_url app/2017-03-10-child-apps %})
* Deploy a gzipped tar archive containing your code: [http://developers.scalingo.com/deployments.html#trigger-manually-a-deployment-from-an-archive](http://developers.scalingo.com/deployments.html#trigger-manually-a-deployment-from-an-archive)
