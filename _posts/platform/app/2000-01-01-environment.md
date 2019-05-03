---
title: Environment Variables
modified_at: 2014-09-15 00:00:00
tags: app configuration environment
index: 3
---

The environment should be used to configure your application. When your
project is deployed and a new container is started, all the variables defined
in your environment are automatically injected into it.

{% include info_environment_how_to.md %}

## Variable Alias

You can define aliases of environment variables:

For example:

* `DATABASE_URL=$SCALINGO_MONGO_URL`

In this case the `DATABASE_URL` becomes an alias of `SCALINGO_MONGO_URL` value.

## Good Practices

Using the environment to configure your application is one of twelve good practices
defined in [the 12-factor](http://12factor.net/).

You should avoid writing any credentials in the files managed by Git.

## Accessing the Environment from your App

The following example is to get the value of the `PORT` variable.

#### Ruby

```ruby
ENV["PORT"]
```

#### Go

```go
os.Getenv("PORT")
```

#### Javascript

```js
process.env.PORT
```

#### Python

```python
os.getenv("PORT")
```

#### PHP

```ruby
$_ENV["PORT"]
```

#### Other Languages

The process should not be really different. Refer to the documentation of
the standard library of your language.

## Build Environment Variables

When your application is deployed, the build container is containing the environment
variables defined in the application configuration and the platform is also injecting
the following variable:

* `$SOURCE_VERSION`: SHA of the currently deployed Git commit.
* `$APP`: Name of the application the build has been triggered for.

## Runtime Environment Variables

When an application container is started, the platform is using the environment
variables defined in the application configuration but is also injecting a set of
environment variables in its environment. In the case of `web` containers, an
additional variable `$PORT` is defined.

* `$PORT`: Port number your server has to bind on.
* `$CONTAINER`: Type and index of the container, `web-1` or `worker-1` for instance
* `$CONTAINER_VERSION`: Version of the container started, usually the Git commit SHA.
* `$CONTAINER_SIZE`: Name of the size of the container `M`, `L`, `XL` etc.
* `$CONTAINER_MEMORY`: Available RAM memory of the container (in bytes)
* `$APP`: Name of the application deployed

## One-off Environment Variables

When starting a [one-off container]({% post_url platform/app/2000-01-01-tasks
%}) for an application, the platform injects the runtime environment variables
plus the following:

* `$SCALINGO_USER_ID`: Scalingo user ID of the user executing the one-off.
