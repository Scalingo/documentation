---
title: Scalingo JSON Manifest
modified_at: 2018-09-10 00:00:00
tags: app review apps one-click manifest
---

The manifest is an **optional** file named `scalingo.json` you can add at the
root of your repository to configure [review apps]({% post_url
platform/app/2000-01-01-review-apps %}) and [one-click deploy button]({%
post_url platform/deployment/2000-01-01-one-click-deploy %}), its intent is
to configure how an application should be created.

## Configuration of the environment

The `scalingo.json` manifest can be used to customize the environment of the
application.

### Review apps

Variables described in the manifest are created when the review app is created,
if one of those variables is present in the parent app environment, it will be
replaced following the manifest rule.

### One-click deployment

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
    }
    "SECRET_KEY": {
      "generator": "secret",
    }
  }
}
```

## Configuration of addons

Addons can also be declared in the JSON manifest, it is following the format `name:plan`.

### Review apps

By default, addons are copied from the parent app, if you want to change the plan the review app
will be using, or to avoid using some of them which only make sense in production, you can specify
the list of addons in the manifest.

### One-click deployments

Addons declared in the manifest will be provisioned before starting the deployment of the application.

### Example

```json
{
  "addons": ["mongodb:sandbox", "redis:free"]
}
```

## Deployment hooks

The JSON manifest also lets you declare scripts which will be executed as
[postdeploy hook]({% post_url platform/app/2000-01-01-postdeploy-hook %})

* `first-deploy`: Executed after the first deployment of a review app or one-click app.
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

## Reference documentation

You can find the comprehensive documentation about the structure of the
Scalingo JSON Manifest in our [developers documentation](https://developers.scalingo.com/scalingo-json-schema)
