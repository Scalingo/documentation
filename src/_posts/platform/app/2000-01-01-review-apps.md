---
title: Review Apps
modified_at: 2022-01-25 00:00:00
tags: app review apps
index: 31
---

Review apps are a *powerful collaboration tool* to discuss about a new features
between members of your organization. We implemented this feature as part of
our [SCM integration]({% post_url platform/app/2000-01-01-scm-integration
%}).

## What Are Review Apps?

Let say that you have worked some hours on an awesome new feature. It's time to
show the world your work and to open a new Pull/Merge Request (PR) on the SCM
tool (even if it's not fully done). With review apps enabled on Scalingo, we
will create a new application (called a _review app_) with the code of the new
feature. You can now share the result of your work, to get it validated, with
all people involved, even if they are not in the tech field.

Maybe they will tell you to change something like adding tests or to change a
button color. You need to push your following modifications on the branch
involved in the PR to update the review app.

Once all of our teammates are satisfied and the PR is closed, we will
automatically delete the review app. You can disable this behavior or add a
delay to fit your needs. This latter setting means that you can still review PR
after your dev team has closed the PR.

If you don't want to create a new review app for each PR you can also choose
among open PRs of your app to manually deploy a review app.

{% assign img_url = "https://cdn.scalingo.com/blog/20161020-github-integration/review_apps.png" %}
{% include mdl_img.html %}

It is also possible to manually create a review app using the [Scalingo CLI]({% post_url platform/cli/2000-01-01-features %}):

```sh
scalingo --app my-app integration-link-manual-review-app 42
```

In this example, `42` is the pull request or merge request ID.

{% note %}
If one manually deletes a review app, it will not be automatically created again after a deployment. You need to manually deploy a new one.
{% endnote %}

## Addons, Collaborators and Environment Variables

If you've enabled review apps, a new application will be created every time a
new PR is opened in your linked SCM-hosted repository. This new
application is a child application.

By default child applications will get a copy
collaborators and environment variables from the parent application.

Child applications also inherit the addons formation of the parent application: same addons and same addon plans but also environment variables. As a note, environment variables are often sensitive data, containing API keys, database credentials, or other secrets.

This default behavior can be customized, see below.

It is however important to understand that the customization can allow to connect directly the Review App to the parent application database and addons, so Review Apps must be enabled only when trusted sources are allowed to create merge requests in the source code repositories. As a consequence, Scalingo prevents Review Apps from being created from forks of the original repository.

{% note %}
Datatabases content and other addons content won't be copied from the parent application to its child applications.
{% endnote %}



## Configuration of Review Apps

Having a strict copy of the parent application is sometimes not desirable. You
might not want to copy production credentials, or it is sometimes required to
start a custom task after the initialization of the app. That's where the [Scalingo
JSON manifest]({% post_url platform/app/2000-01-01-app-manifest %}) becomes useful.

If there are valid reasons and cases where configuring the `scalingo.json` is the adequate solution, it is important to understand that it is sometimes not the apporiate one. As Review Apps can connect to their parent database, and addons, this means personal, or health-related information can be exposed. As a consequence, Scalingo recommends not to enable Review Apps for production applications; the preferred approach is to create a second application linking to the same repository. This second, separate application can then have Review Apps, while protecting production data.

As a quick example, here is a sample `scalingo.json` that customize the
environment variable `CANONICAL_HOST_URL` for a child app:

```json
{
  "env": {
    "CANONICAL_HOST_URL": {
      "generator": "url"
    }
  }
}
```

Here, the value of the environment variable `CANONICAL_HOST_URL` will contain
the URL to reach the newly deployed app. The `scalingo.json` configuration
always takes precedence over parent app configuration.

### Protect a Review App with Basic Auth

You may want to protect access to your review apps so that authentication is
mandatory before reaching the review app. A solution is to update the
`scalingo.json` file to look like:

```json
{
  "env": {
    "BASIC_AUTH": {
      "value": true
    }
  }
}
```

Then you can test the presence of this environment variable in your application
and setup Basic Auth in case this environment is defined in the environment of
the application.

You can also generate a different password for each review app by using the
`secret` generator in the `scalingo.json` file:

```json
{
  "env": {
    // ...
    "PASSWORD": {
      "description": "Basic auth password for review apps",
      "generator": "secret"
    }
  }
}
```

The environment variable `PASSWORD` should be used by your application to
configure Basic Auth on your app.

### Run a Task After the First Deployment of a Review App

When a review app is created, you might want to execute a custom action like
seeding its database. This can be done using the `first-deploy` script in the
`scalingo.json` manifest. If such a property is defined, the given command will
be executed as a [postdeploy hook]({% post_url
platform/app/2000-01-01-postdeploy-hook %}) after the first deployment.

{% warning %}
This script replaces the `postdeploy` hook for the first deployment of a review
app. If a `postdeploy` is defined in your `scalingo.json` or `Procfile`, it
won't be executed.
{% endwarning %}

```json
{
  "scripts": {
    "first-deploy": "bundle exec rake db:deploy db:seed"
  }
}
```

### Run a Task After Each Deployment of a Review App

To run a custom command after each deployment of a review app, you need to
define a [postdeploy hook]({% post_url platform/app/2000-01-01-postdeploy-hook
%}) for your application. However defining a postdeploy hook would also
impact the parent application.

To make sure only review apps are impacted, the common practice is to define a
custom environment variable in the `scalingo.json` manifest:

```json
{
  "env": {
    "IS_REVIEW_APP": {
      "value": "true"
    }
  }
}
```

Then use the environment variable in your postdeploy task to check if it is
executed in the scope of a review app or not.

## Is It Possible to Create Review Apps If My Code Is Hosted at a Different Place?

We implement review apps for code hosted on GitHub or GitLab. However you can
set it up for your specific case thanks to the Scalingo API:

* Create a [child application]({% post_url platform/app/2000-01-01-child-apps %})
* Deploy a gzipped tar archive containing your code:
[http://developers.scalingo.com/deployments.html#trigger-manually-a-deployment-from-an-archive](http://developers.scalingo.com/deployments.html#trigger-manually-a-deployment-from-an-archive)
