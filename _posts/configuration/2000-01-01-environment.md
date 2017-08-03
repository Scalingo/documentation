---
title: Application environment
modified_at: 2014-09-15 00:00:00
category: configuration
tags: app configuration environment
order: 3
---

The environment should be used to configure your application. When your
project is deployed and a new container is started, all the variables defined
in your environment are automatically injected into it.

{% include info_environment_how_to.md %}

## Build Environment

During the build phase some environment variables are injected by our platform: [read more]({% post_url deployment/2000-01-01-build-environment %}).

## Runtime Environment

When an application container is started, the platform is using the environment
variables defined in the application configuration but is also injecting a set of
environment variables in its environment. In the case of `web` containers, an
additional variable `$PORT` is defined.

* `$PORT`: Port number your server has to bind on.
* `$CONTAINER`: Type and index of the container, `web-1` or `worker-1` for instance
* `$CONTAINER_VERSION`: Version of the container started, usually the GIT commit SHA.
* `$APP`: Name of the application deployed

## Variable alias

You can define aliases of environment variables:

For example:

* `DATABASE_URL` -&gt; `$SCALINGO_MONGO_URL`

In this case the `DATABASE_URL` becomes an alias of `SCALINGO_MONGO_URL` value.

## Good practices

Using the environment to configure your application is one of twelve good practices
defined in [the 12 factors](http://12factor.net/).

You should avoid writing any credentials in the files managed by `git`.

## Accessing the environment from your app

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

#### Other languages

The process shoul not be really different, refer to the documentation of
the standard library of your language.
