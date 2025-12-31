---
title: Scalingo JSON Manifest
modified_at: 2025-12-30 00:00:00
tags: app review apps one-click manifest
---

The manifest is an **optional** file named `scalingo.json` you can add at the
root of your repository to configure [review apps]({% post_url
platform/app/2000-01-01-review-apps %}) and [one-click deploy button]({%
post_url platform/deployment/2000-01-01-one-click-deploy %}). Its intent is to
configure how an application should be created.

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

### Monorepos

If your application code is in a subdirectory (configured using the `PROJECT_DIR` environment variable), Scalingo 
detects the JSON manifest under this subdirectory.

If there is no JSON manifest in the `PROJECT_DIR` folder, Scalingo 
tries to get the `scalingo.json` in every folder up to the root of your repository.

See our dedicated page on [monorepos]({% post_url platform/app/2000-01-01-monorepo %}) for more information about this type of setup.

## Configuration of Addons

Addons can also be declared in the JSON manifest and they'll be provisioned before deploying
a review app or starting a one-click deploy.

### Review Apps

By default, addons are copied from the parent app. If you want to change the plan the review app
will be using, or to avoid using some of them which only make sense in production, you can specify
the list of addons in the manifest.

### One-Click Deployments

Addons declared in the manifest will be provisioned before starting the deployment of the application.

### Example

The `options` attribute is optional, currently only the `version` parameter is allowed in it.

```json
{
  "addons": [
    {
      "plan": "postgresql:postgresql-starter-512",
      "options": {
        "version": "11"
      }
    }, {
      "plan": "redis:redis-starter-128"
    }
  ]
}
```

{% note %}
You can use the CLI
`scalingo addons-list`
`scalingo addons-plans {addon-id}`
to get addon names and their plans.
{% endnote %}

## Deployment Hooks

The JSON manifest also lets you declare scripts which will be executed as [postdeploy hook]({% post_url platform/app/2000-01-01-postdeploy-hook %}).

* `first-deploy`: Executed after the first deployment of a review app or one-click app. It will be executed as many times as necessary until a first deployment is considered a "success" by the platform.
* `postdeploy` [Deprecated]: Executed after each deployment of a review app except the first one if `first-deploy` is defined. This feature has been deprecated in favor of postdeploy script in the [`Procfile` file]({% post_url platform/app/2000-01-01-postdeploy-hook %}).

{% note %}
`first-deploy` and `postdeploy` have the same effect for one-click applications as the `scalingo.json` is only used once at the app creation.
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

## Container Formation

The `scalingo.json` manifest can be used to setup a container formation. A container formation defines the shape of the containers that will be launched.

### Review Apps

You can specify the shape and the number of containers to be launched when a Review App is created. This is useful for making an exact copy of a production environment in Review Apps without having to perform any manual actions.

### One-Click Deployment

The manifest describes how applications deployed with our one-click button are deployed. This can be useful, for example, if you want to deploy a worker at the same time to handle asynchronous tasks.

### Example

```json
{
  "formation": {
    "web": {
      "amount": 2,
      "size": "L"
    },
    "worker": {
      "amount": 1,
      "size": "XL"
    }
  }
}
```

{% note %}
You can find more information about formation in our [dedicated blog post](https://scalingo.com/blog/scalingo-json-formation)
{% endnote %}

## Reference Documentation

You can find the comprehensive documentation about the structure of the
Scalingo JSON Manifest in our [developers documentation](https://developers.scalingo.com/scalingo-json-schema)
