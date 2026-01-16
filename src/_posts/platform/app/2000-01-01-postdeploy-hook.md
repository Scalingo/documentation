---
title: Post-deployment hook
modified_at: 2023-12-22 00:00:00
tags: app deployment hook postdeploy
index: 13
---

## Context

When you deploy your application, you may want to trigger automatically custom
actions after the deployment succeeded. This hook will automatically starts the
specified command at the end of your deployment.

## Configuration

To setup a post-deployment hook, you have to add a `postdeploy` entry in your
[Procfile]({% post_url platform/app/2000-01-01-procfile %}):

```yaml
postdeploy: command you want to run
```

Then commit your `Procfile` and from the next deployment, the hook will be
executed.

## Workflow

The Post-deployment hook will be part of the deployment process, things will
happen in the following order:

1. The application is built
2. Containers from the new version of the application are started
3. We wait until they started successfully (see common [deployment start
   errors]({% post_url
   platform/getting-started/2000-01-01-common-deployment-errors
   %}#start-errors)). They are not reachable yet, see [limits](#limits) below.
4. An extra container is started to run the `postdeploy` command
5. If the `postdeploy` command succeeds, we update the routing
   configuration. The new containers start to get requests and the deployment is
   considered a **success**

What this workflow implies is that the application boot should not rely on data initialized by the post-deployment hook.

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

* Duration: a postdeploy hook should be achieved in less than **20 minutes**,
  otherwise the process will be stopped and the status `-128` will be
  returned. If you have long task to achieve after a deployment, it is
  recommended **not** to use a `postdeploy` hook but a
  [one-off container]({% post_url platform/app/2000-01-01-tasks %}) once the
  deployment has been done.
* During the postdeploy execution, the new version of the application is not
  yet reachable. If you make a query to it, the old version will respond, or,
  if it is the first deployment, your query will return a "404 not found" error.
* Memory available: a postdeploy hook is executed in a M container (512 MB RAM available). This size is modifiable upon request on the support.

## Examples

### Database Migrations

A common example to this feature is to apply database migrations, for instance with a [Rails application]({% post_url languages/ruby/rails/2000-01-01-start %}#database-migration):

```yaml
postdeploy: bundle exec rake db:migrate
```

{% note %}
Keep in mind that database migrations may fail. You should design them *knowing* that
they may fail. Here is an [article from
Codeship](https://blog.codeship.com/rails-migrations-zero-downtime/) explaining
this process.
{% endnote %}

### Notifying External Service

#### New Relic

```yaml
postdeploy: newrelic deployments --revision=$CONTAINER_VERSION
```

#### Rollbar

```yaml
postdeploy: curl https://api.rollbar.com/api/1/deploy/ -F access_token=$ROLLBAR_ACCESS_TOKEN -F environment=$RAILS_ENV -F revision=$CONTAINER_VERSION -F local_username=scalingo
```

#### AppSignal

The `appsignal` CLI `notify_of_deploy` command is deprecated. But you can notify
AppSignal of a new deployment by adding the file `config/appsignal.yml` with the
following content:

```yaml
default: &defaults
  revision: <%= ENV.fetch("CONTAINER_VERSION") { nil } %>
production:
  <<: *defaults
```

This solution works for the AppSignal Ruby gem version `>= 2.6.1`.

You can also use AppSignal Push API to manually create a deploy marker with this
postdeploy command:

```yaml
postdeploy: curl -X POST -d "{\"revision\":\"$CONTAINER_VERSION\",\"user\":\"scalingo\"}" "https://push.appsignal.com/1/markers?api_key=$APPSIGNAL_PUSH_API_KEY&name=$APPSIGNAL_APP_NAME&environment=$APPSIGNAL_APP_ENV"
```

#### Sentry

Create an executable script named `postdeploy.sh` with the following content:

```sh
#!/bin/bash

set -e
set -o pipefail

bundle exec rake db:migrate
curl $SENTRY_DEPLOY_HOOK -X POST -H "Content-Type: application/json" -d "{\"version\": \"$CONTAINER_VERSION\"}"
```

The `SENTRY_DEPLOY_HOOK` environment variable must be added to the application environment. Its content is the value in Sentry settings: Settings > Projects > Project Name > Releases.

Make it executable by using the following command:

```sh
chmod +x postdeploy.sh
```

Finally, modify the `Procfile` to include:

```yaml
postdeploy: /app/postdeploy.sh
```

### Applying Migrations and Notifying External Service

Use the standard `&&` bash operator:

```yaml
postdeploy: bundle exec rake db:migrate && newrelic deployments --revision=$CONTAINER_VERSION
```

## What You Should Not Do?

### Build Assets

The `postdeploy` hook is not the right place to build your assets. Keep in mind
that the action is executed in a dedicated one-off container, the other
containers from your application won't be impacted by any file change.

All operations related to assets should be done in the build process. The
location of the instruction to build the assets depends on the technology:

* PHP Symfony ([doc]({% post_url languages/php/2000-01-01-symfony %}#asset-management-with-assetic))
* Node.js ([doc]({% post_url languages/nodejs/2000-01-01-start %}#nodejs-build-hooks))

## Difference With the Heroku Release Phase

The post-deployment hook is close to what Heroku names the _release_ phase.
There are, however, a few noticeable differences we explain in this section.

On Scalingo, the post-deployment hook is synchronously executed at the end of
every successful deployment.

On Heroku, the release phase is executed after each new release of the code. A
new release is created after various events such as a new deployment, but also a
change in the environment variables or the provisioning of a new addon.
