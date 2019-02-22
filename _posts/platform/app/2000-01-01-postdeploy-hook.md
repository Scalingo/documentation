---
title: Post-deployment hook
modified_at: 2016-10-04 00:00:00
tags: app deployment hook postdeploy
index: 13
---

## Context

When you deploy your application, you may want to trigger automatically custom actions after the
deployment succeeded, this hook is then exactly what you need. This hook will automatically starts
the specified command at the end of your deployment.

## Configuration

To setup a post-deployment hook, you have to add a `postdeploy` entry in your [Procfile]({%
post_url platform/app/2000-01-01-procfile %}):

```yaml
postdeploy: command you want to run
```

Then commit your `Procfile` and from the next deployment, the hook will be executed.

## Workflow

The Post-deployment hook will be part of the deployment process, things will happen in the following order:

1. The application is built
2. Containers from the new version of the application are started
3. We wait until they started successfully (see common [deployment start errors]({% post_url platform/getting-started/2000-01-01-common-deployment-errors %}#start-errors))
4. An extra container is started to run the `postdeploy` command
5. If the `postdeploy` command has succeeded, we update the routing
   configuration, the new containers start to get requests and the deployment
   is considered a **success**

{% note %}
  If the `postdeploy` command fails, the deployment will fail with the status
  `hook-error` and the old version of the application will keep running, the
  application will have to get pushed again, with a new `postdeploy` hook or a
  code update.
{% endnote %}

## Environment

The environment available in the context of the container running the
`postdeploy` hook will be exactly the same as the one of your running app. It
contains the environment variables from your app, with the one we inject in any
[runtime environment]({% post_url platform/app/2000-01-01-environment %}#runtime-environment)

## Limits

* Duration: a postdeploy hook should be achieved in less than **20 minutes**, otherwise the process
  will be stopped and the status `-128` will be returned. If you have long task to achieve
  after a deployment, it is recommended **not** to use a `postdeploy` hook but a [one-off
  container]({% post_url platform/app/2000-01-01-tasks%}) once the deployment has been done.

## Examples

### Applying migrations

A common example to this feature is to apply migrations, for instance with a
Rails application:

```yaml
postdeploy: bundle exec rake db:migrate
```

{% note %}
  Keep in mind that migrations may fail. You should design them *knowing* that they may fail. Here is an
  [article from Codeship](https://blog.codeship.com/rails-migrations-zero-downtime/)
  explaining this process.
{% endnote %}

### Notifying external service

#### New Relic

```yaml
postdeploy: newrelic deployments --revision=$CONTAINER_VERSION
```

#### Rollbar

```yaml
postdeploy: curl https://api.rollbar.com/api/1/deploy/ -F access_token=$ROLLBAR_ACCESS_TOKEN -F environment=$RAILS_ENV -F revision=$CONTAINER_VERSION -F local_username=scalingo
```

#### AppSignal

The `appsignal` CLI `notify_of_deploy` command is deprecated. But you can notify AppSignal of a new
deployment by adding the file `config/appsignal.yml` with the following content:

```yaml
default: &defaults
  revision: <%= ENV.fetch("CONTAINER_VERSION") { nil } %>
  production:
<<: *defaults
```

This solution works for the AppSignal Ruby gem version `>= 2.6.1`.

### Both Applying migrations and notifying external service

Use the standard `&&` bash operator:

```yaml
postdeploy: bundle exec rake db:migrate && newrelic deployments --revision=$CONTAINER_VERSION
```

## What you should not do

### Build assets

The `postdeploy` hook is not the right place to build your assets. Keep in mind
that the action is executed in a dedicated one-off container, the other
containers from your application won't be impacted by any file change.

All operations related to assets should be done in the build process. The location of the
instruction to build the assets depends on the technology:

* PHP Symfony ([doc]({% post_url languages/php/2000-01-01-symfony %}#asset-management-with-assetic))
* Node.js ([doc]({% post_url languages/nodejs/2000-01-01-start %}#nodejs-build-hooks))
