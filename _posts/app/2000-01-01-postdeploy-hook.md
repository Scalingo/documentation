---
title: Post-deployment hook
modified_at: 2016-10-04 00:00:00
category: app
tags: app deployment hook postdeploy
---

## Context

When you deploy your application, you may want to trigger custom action after
the deployment succeeded automatically, this hook is then exactly what you
need. This hook will automatically starts the specified command at the end of
your deployment.

## Configuration

To setup a Post-deployment hook, you just have to add a `postdeploy` entry in your [Procfile]({% post_url internals/2014-12-01-procfile %}):

```yml
postdeploy: command you want to run
```

Then commit your `Procfile` and from the next deployment, the hook will be executed.

## Workflow

The Post-deployment hook will be part of the deployment process, things will happen in the following order:

1. The application is built
2. Containers from the new version of the application are started
3. We wait until they started successfully (see common [deployment start errors]({% post_url deployment/2014-08-26-start-error %}))
4. An extra container is started to run the `postdeploy` command
5. If the `postdeploy` command has succeeded, we update the routing
   configuration, the new containers start to get requests and the deployment
   is considered a **success**

> If the `postdeploy` command fails, the deployment will fail with the status
> `hook-error` and the old version of the application will keep running, the
> application will have to get pushed again, with a new `postdeploy` hook or a
> code update.

## Environment

The environment available in the context of the container running the
`postdeploy` hook will be exactly the same as the one of your running app. It
contains the environment variables from your app, with the one we inject in any
[runtime environment]({% post_url app/2000-01-01-runtime-environment %})

## Examples

### Applying migrations

A common example to this feature is to apply migrations, for instance with a
rails application:

```yaml
postdeploy: bundle exec rake db:migrate
```

> Keep in mind that migrations may fail, design them knowing that, here is an
> [article from Codeship](https://blog.codeship.com/rails-migrations-zero-downtime/)
> explaining this process.

### Notifying external service

#### Newrelic

```yaml
postdeploy: newrelic deployments --revision=$CONTAINER_VERSION
```

#### Rollbar

```yaml
postdeploy: curl https://api.rollbar.com/api/1/deploy/ -F access_token=$ROLLBAR_ACCESS_TOKEN -F environment=$RAILS_ENV -F revision=$CONTAINER_VERSION -F local_username=scalingo
```

### Both Applying migrations and notifying external service

Use the standard && bash operator:

```yaml
postdeploy: bundle exec rake db:migrate && newrelic deployments --revision=$CONTAINER_VERSION
```

## What you should not do

### Build assets

The `postdeploy` hook is not the right place to build your assets. Keep in mind
that the action is executed in a dedicated one-off container, the other
containers from your application won't be impacted by any file change. All
operation relative to assets should be done in the build process.
