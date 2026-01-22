---
title: Environment Variables
modified_at: 2026-01-02 12:00:00
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
defined in [the 12-factor](https://12factor.net/).

You should avoid writing any credentials in the files managed by Git (example: `.env` files).

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

#### JavaScript

```js
process.env.PORT
```

#### Python

```python
os.getenv("PORT")
```

#### PHP

```php
$_ENV["PORT"]
```

#### Java

```java
System.getenv("PORT");
```

#### Other Languages

The process should not be really different. Refer to the documentation of the standard library of your language.

## Multi-Lines Environment Variable

The current web dashboard does not handle well the configuration of an environment variable which spans on multiple lines. There is a couple of workaround you could use to circumvent this limitation.

A first solution is to define this environment variable using our [CLI]({% post_url tools/cli/2000-01-01-start %}). For instance, if the content of the environment variable is the content of a file:

```bash
scalingo --app my-app env-set "MY_VAR=$(cat fichier.key)"
```

The con of this solution is that the web dashboard becomes unusable to edit environment variables because of this multi-lines variable. If you want to still be able to use the web dashboard to manage your environment variable, the solution is to encode your multi-lines environment variable in Base64, then decode it in your application. First, set the environment variable in Base64:

```bash
scalingo --app my-app env-set "MY_VAR=$(cat fichier | base64 -w 0)"
```

You can now read the content of this environment variable in your application by decoding the content of the variable. For instance, in PHP:

```php
base64_decode($_ENV["MY_VAR"])
```

Most programming languages offer a way to decode a Base64 content.

## Build Environment Variables

When your application is deployed, the build container is containing the environment
variables defined in the application configuration and the platform is also injecting
the following variable:

* `SOURCE_VERSION`: SHA of the currently deployed Git commit.
* `APP`: Name of the application the build has been triggered for.

## Runtime Environment Variables

When an application container is started, the platform is using the environment
variables defined in the application configuration but is also injecting a set of
environment variables in its environment. In the case of `web` containers, an
additional variable `$PORT` is defined.

* `PORT`: Port number your server has to bind on
* `CONTAINER`: Type and index of the container (e.g. `web-1` or `worker-1`)
* `CONTAINER_VERSION`: Version of the container started, usually the Git commit SHA
* `CONTAINER_SIZE`: Name of the size of the container (e.g. `M` or `XL`)
* `CONTAINER_MEMORY`: Available RAM memory of the container (in bytes)
* `APP`: Name of the application deployed
* `SCALINGO_APPLICATION_ID`: ID of the application deployed (e.g. `ap-a71da13f-7c70-4c00-a644-eee8558d8053`)
* `HOSTNAME`: The container application hostname based on the application name and the container type (e.g. `my-app-web-1`)
* `STACK`: Name of the stack the application deployed is using
* `REGION_NAME`: Name of the region where the application is deployed
* `SCALINGO_PRIVATE_NETWORK_ID`: ID of the [private network] where the application is located (e.g. `pn-ad0fd6a1-d05e-40ea-bf63-c4f8a75a9d8c`). This variable is not available if the application is not deployed in a private network.
* `SCALINGO_PRIVATE_HOSTNAME`: private hostname of the container inside the [private network] where the application is located (e.g. {% pndn 1.web.ap-a71da13f-7c70-4c00-a644-eee8558d8053.pn-ad0fd6a1-d05e-40ea-bf63-c4f8a75a9d8c.private-network.internal. %}). This variable is not available if the application is not deployed in a private network.

## One-Off Environment Variables

When starting a [one-off container]({% post_url platform/app/2000-01-01-tasks
%}) for an application, the platform injects the runtime environment variables
plus the following:

* `SCALINGO_USER_ID`: Scalingo user ID of the user executing the one-off.

## Multi-values Environment Variables

If you need to define a list of values for an environment variable, there is no built-in mechanism to handle this automatically, but you can follow the steps below to get a workaround.

Write the value of the environment variable using CSV style notation: `MY_VAR="value1;value2;value3"`.

Then you'll need to get the value of the environment variable in your application code and parse it manually.


[private network]: {% post_url platform/networking/private/2000-01-01-overview %}
