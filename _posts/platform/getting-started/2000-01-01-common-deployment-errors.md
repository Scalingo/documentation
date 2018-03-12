---
title: Common Deployment Errors
modified_at: 2015-03-24 00:00:00
index: 7
---

## Unknown Technology

When pushing your app to Scalingo, you might get the following error:

```text
<-- Start deployment of [my-app] -->
 !     We didn't find the type of technology your are using...
       We're sorry this build is failing!

       Refer to the documentation to find out why:
       http://doc.scalingo.com/deployment/unknown-technology

       If you can't find the issue in your application,
       please send us an email at support@scalingo.com

       <3,
       Scalingo
 !   Error deploying the application
 !   → Invalid return code from buildpack
```

There's two main solutions to this problem.

### Project in a subdirectory

It may happen that your project is in a subfolder of your Git repository. It's
completely OK but remind that Scalingo's deployment system looks at the root of
the Git repository by default.

You need to setup the `PROJECT_DIR` environment variable for your application,
and our build system will automatically look at it. The variable has to target
a valid directory, otherwise the deployment process will fail.

**Example**

If your project has the following architecture:

```text
/server
/server/server.go
/server/public/img/logo.png
/server/public/css/style.css
/server/public/js/app.js
/doc
/doc/api.md
```

You want to deploy what is in the `/server` directory, so you have to define
`PROJECT_DIR=server`. That's it! It will be taken into account at your next
deployment.

{% warning %}
Only the `PROJECT_DIR` directory will be present during runtime. The parent
directory is not added to the application image we are building at the
deployment phase.
{% endwarning %}

### Technology detection

In order to detect the technology used by your application, we iterate over the
technologies alphabetically. It means that if your project contains multiple
technologies, we will pick the first one detected.

If you want to skip the detection phase and force the use of a specific
buildpack, add the environment variable `BUILDPACK_NAME` to your project.

If you need to use multiple technologies you can use the [multi-buildpacks]({%
post_url platform/deployment/buildpacks/2000-01-01-multi %}).

You can also develop your own buildpack and add the environment variable
`BUILDPACK_URL` to have complete control on the detection and build phases.

More information are available on [buildpacks]({% post_url
platform/deployment/buildpacks/2000-01-01-intro %}) or [multi-buildpacks]({%
post_url platform/deployment/buildpacks/2000-01-01-multi %}).

Here is how we detect your technology:

[Ruby]({% post_url languages/ruby/2000-01-01-start %})

A `Gemfile` should be present at the root of your repository.

[Node.js]({% post_url languages/nodejs/2000-01-01-start %})

The file `package.json` should be present at the root of the project.

[Meteor]({% post_url languages/meteorjs/2000-01-01-start %})

The directory `.meteor` should be present at the root of your project.

[PHP]({% post_url languages/php/2000-01-01-start %})

You need to have either an `index.php` file or both `composer.json` and `composer.lock` files at the root of your project.

[Python]({% post_url languages/python/2000-01-01-start %})

The file `requirements.txt` and `setup.py` should be present at the root of your project.

[Java]({% post_url languages/java/2000-01-01-start %})

The file `pom.xml` should be present at the root of your project.

[Scala]({% post_url languages/scala/2000-01-01-start %})

You need to have at least an `*.sbt` file or a `project/*.scala`/`.sbt/*.scala` file or a `project/build.properties` file.

[Groovy]({% post_url languages/groovy/2000-01-01-start %})

The file `grails-app` must be at the root of your project.

[Clojure]({% post_url languages/clojure/2000-01-01-start %})

The file `project.clj` must be at the root of your project.

[Go]({% post_url languages/go/2000-01-01-start %})

You need to have at least one `*.go` file at the root of your project.
Then, we detect the Go language and install any dependency with your `Godeps` directory (see more about [Godeps](https://github.com/tools/godep)).

[Haskell]({% post_url languages/haskell/2000-01-01-start %})

A file `*.cabal` must be at the root of your project.

[Erlang]({% post_url languages/erlang/2000-01-01-start %})

You need to have either a `rebar.config` file or a `ebin` file at the root of your project.

## Git Submodule

If your project repository uses Git submodules, please be aware that Scalingo
will not pull them. This Git feature is not supported on the platform for
different reasons. The main reason being that we currently have no way to
authenticate the `git pull` operation to a private Git repository when doing
the deployment. Actually Git submodules are often considered as a broken
feature of Git, that is why we do not encourage its usage or support it today.

We recommend you to vendor a specific release of the code of the sub-git
repository in your main repository before pushing.

## Build Errors

When your application is deployed, the dependencies are gathered and are packaged
into an _application image_

### Invalid return code from buildpack

You application image is built using a buildpack ([List of buildpacks]({% post_url platform/deployment/buildpacks/2000-01-01-intro %})).
If the buildpack exits with an error, it is probably linked to your project. You should
be able to see the content of the error in your console. Then adapt your code according to it.

If you think the error comes from our buildpacks, feel free to contact us and we will fix
it as soon as we can.

### Image too large

The maximal size of an application image is __650MB__. If your assets, your
dependencies and the code of your application weigh more than this limit,
different solutions are available to lighten the image of your application:

* Try to remove unused external dependencies or assets.
* Define a [.slugignore file]({% post_url platform/app/2000-01-01-slugignore %}) to exclude files from the
  image.

If you absolutely need all these data, please contact us at
[support@scalingo.com](mailto:support@scalingo.com).

{% note %}
  Why this quota? Besides being a simple security limit, this quota is also present to
  preserve the PaaS user experience. A large image results in longer deployments, the
  instantaneity aspect is lost.
{% endnote %}

## Start Errors


After creating the container image of your application, it is deployed
in our infrastructure. The following errors may happened if your application
is not configured correctly.

If something wrong happens, you should first look at the logs of your app. In
most cases, all the information you need is displayed here.

### Boot Timeout

When started on our servers, your application has **60 seconds** to bind the
port defined by the environment variable `PORT`. After this delay, we consider
that your application is not able to boot and this error happens.

**Common causes**

* The server is not listening on the port defined by the environment variable
  `PORT`. Then your application is running correctly but it is not reachable.

### Crash of the application

When your application starts, it may stop unexpectedly for various reasons
related to your project.

**Common causes**

* Syntax error and import error in your code. Make sure that your project is
  working correctly locally before deploying it on our platform. If it
  doesn't, it won't be better here.
* The database link is badly configured. If you are using our built-in database
  addons, we create an environment variable with a name following this scheme:
  `SCALINGO_{DB_TYPE}_URL`. Your application must use this value or you can
  rename it to fit your needs.
