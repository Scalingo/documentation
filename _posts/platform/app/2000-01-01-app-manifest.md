---
title: Scalingo JSON Manifest
modified_at: 2020-11-18 00:00:00
tags: app review apps one-click manifest
---

The manifest is an **optional** file named `scalingo.json` you can add at the
root of your repository to configure [review apps]({% post_url
platform/app/2000-01-01-review-apps %}) and [one-click deploy button]({%
post_url platform/deployment/2000-01-01-one-click-deploy %}). Its intent is to
configure how an application should be created.

If your application code is in a subdirectory configured through the [`PROJECT_DIR`]({% post_url platform/getting-started/2000-01-01-common-deployment-errors %}#project-in-a-subdirectory) environment variable, Scalingo detects the JSON manifest under this subdirectory. If there is no JSON manifest in the `PROJECT_DIR` folder, Scalingo tries to get the `scalingo.json` in every folder up to the root of your repository.

## Configuration of the Environment

The `scalingo.json` manifest can be used to customize the environment of the
application.

### Review Apps

Variables described in the manifest are created when the review app is created,
if one of those variables is present in the parent app environment, it will be
replaced following the manifest rule.

### One-Click Deployment

The manifest describes the default values of the environment variables, the user
can still customize them before triggering the deployment.

### Example

```json
{
  "env": {
    "ENVIRONMENT": {
      "value": "staging"
    },
    "ADMIN_URL": {
      "generator": "url",
      "template": "%URL%/admin"
    },
    "SECRET_KEY": {
      "generator": "secret"
    }
  }
}
```

## Configuration of Addons

Addons can also be declared in the JSON manifest. The format is the following:

```json
{
  "addon_provider_id": "mongodb",
  "plan_id": "mongo-sandbox",
  "options": {  }
}
```

### Review Apps

By default, addons are copied from the parent app. If you want to change the plan the review app
will be using, or to avoid using some of them which only make sense in production, you can specify
the list of addons in the manifest.

### One-Click Deployments

Addons declared in the manifest will be provisioned before starting the deployment of the application.

### Example

```json
{
  "addons": [
    {
      "addon_provider_id": "mongodb",
      "plan_id": "mongo-sandbox",
      "options": {
        "version": "4.0.19-1"
      }
    }
  ]
}
```

{% note %}
You can use the CLI
`scalingo addons-list`
`scalingo addons-plans {addon-name}`
to get addon names and their plans.
{% endnote %}

## Deployment Hooks

The JSON manifest also lets you declare scripts which will be executed as
[postdeploy hook]({% post_url platform/app/2000-01-01-postdeploy-hook %})

* `first-deploy`: Executed after the first deployment of a review app or one-click app. It will be executed as many times as necessary until a first deployment is considered a "success" by the platform.
* `postdeploy` Executed after each deployment of a review app except the first
  one if `first-deploy` is defined.

{% note %}
`first-deploy` and `postdeploy` have the same effect for one-click applications
as the `scalingo.json` is only used once at the app creation.
{% endnote %}

### Example

```json
{
  "scripts": {
    "first-deploy": "bundle exec rake db:migrate db:seed",
    "postdeploy": "bundle exec rake db:migrate"
  }
}
```

## Reference Documentation

You can find the comprehensive documentation about the structure of the
Scalingo JSON Manifest in our [developers documentation](https://developers.scalingo.com/scalingo-json-schema)
