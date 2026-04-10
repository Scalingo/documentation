---
title: Deployment Issues
modified_at: 2026-04-10 00:00:00
tags: troubleshooting deployment buildpack build archive image
index: 2
---

Deployment Issues happen during the build and packaging phase, before your
application's containers are started.

For a broader overview, see [Troubleshooting Your Application]({% post_url
platform/app/2000-01-01-troubleshooting %}). If your application image is
built successfully but the application fails to start, see [Boot and Startup
Errors]({% post_url
platform/app/troubleshooting/2000-01-01-boot-and-startup-errors %}).

## Unknown Technology {#unknown-technology}

When pushing your app to Scalingo, you might get the following error:

```text
<-- Start deployment of [my-app] -->
 !     We didn't find the type of technology your are using...
       We're sorry this build is failing!

       Refer to the documentation to find out why:
       https://doc.scalingo.com/deployment/unknown-technology

       If you can't find the issue in your application,
       please send us an email at support@scalingo.com

       <3,
       Scalingo
 !   Error deploying the application
 !   → Invalid return code from buildpack
```

There are two main causes for this problem: the application code is not at the
root of the repository, or the expected detection files are missing.

### Project in a Subdirectory {#project-in-a-subdirectory}

It may happen that your project is in a subfolder of your Git repository. This
is supported, but Scalingo's deployment system looks at the root of the Git
repository by default.

You need to set the `PROJECT_DIR` environment variable for your application,
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
`PROJECT_DIR=server`.

{% warning %}
Only the `PROJECT_DIR` directory will be present during runtime. The parent
directory is not added to the application image we are building during the
deployment phase.
{% endwarning %}

### Technology Detection

To detect the technology used by your application, we iterate over the
technologies alphabetically. If your project contains multiple technologies, we
will pick the first one detected.

If you want to skip the detection phase and force the use of a specific
buildpack, add the environment variable `BUILDPACK_NAME` to your project.

If you need to use multiple technologies, you can use the
[multi-buildpacks]({% post_url platform/deployment/buildpacks/2000-01-01-multi %}).

You can also develop your own buildpack and add the environment variable
`BUILDPACK_URL` to have complete control on the detection and build phases.

More information is available on [buildpacks]({% post_url
platform/deployment/buildpacks/2000-01-01-intro %}) or
[multi-buildpacks]({% post_url
platform/deployment/buildpacks/2000-01-01-multi %}).

Here is how we detect your technology:

| Technology | Detection |
| --- | --- |
| [Ruby]({% post_url languages/ruby/2000-01-01-start %}) | A `Gemfile` should be present at the root of your repository. |
| [Node.js]({% post_url languages/nodejs/2000-01-01-start %}) | The file `package.json` should be present at the root of the project. |
| [Meteor]({% post_url languages/meteorjs/2000-01-01-start %}) | The directory `.meteor` should be present at the root of your project. |
| [PHP]({% post_url languages/php/2000-01-01-start %}) | You need either an `index.php` file or both `composer.json` and `composer.lock` at the root of your project. |
| [Python]({% post_url languages/python/2000-01-01-start %}) | The file `Pipfile`, `requirements.txt` or `setup.py` must be present at the root of your project. |
| [Java]({% post_url languages/java/2000-01-01-start %}) | The file `pom.xml` should be present at the root of your project. |
| [Scala]({% post_url languages/scala/2000-01-01-start %}) | You need at least an `*.sbt` file, a `project/*.scala` file, a `.sbt/*.scala` file, or a `project/build.properties` file. |
| [Groovy]({% post_url languages/groovy/2000-01-01-start %}) | The `grails-app` directory must be at the root of your project. |
| [Clojure]({% post_url languages/clojure/2000-01-01-start %}) | The file `project.clj` must be at the root of your project. |
| [Go]({% post_url languages/go/2000-01-01-start %}) | You need at least one `*.go` file at the root of your project. |
| [Crystal]({% post_url languages/crystal/2000-01-01-start %}) | The file `shard.yml` should be present at the root of your project. |
| [Elixir]({% post_url languages/elixir/2000-01-01-start %}) | Create a `.buildpacks` file at the root of your project to declare the Elixir buildpack explicitly. |

## Git Submodule {#git-submodule}

If your project repository uses Git submodules, please be aware that Scalingo
will not pull them. This Git feature is not supported on the platform for
different reasons. The main reason is that we currently have no way to
authenticate the `git pull` operation to a private Git repository during the
deployment.

We recommend vendoring a specific release of the code of the sub-repository in
your main repository before pushing.

## Build Errors {#build-errors}

When your application is deployed, the dependencies are gathered and packaged
into an application image.

### Invalid Return Code From Buildpack

Your application image is built using a buildpack ([list of buildpacks]({%
post_url platform/deployment/buildpacks/2000-01-01-intro %})). If the
buildpack exits with an error, it is probably linked to your project. You
should be able to see the content of the error in your console, then adapt your
code or configuration accordingly.

If you think the error comes from our buildpacks, contact us and we will
investigate it.

### Image Too Large

The maximal size of an application image is **2 GiB**. If your assets, your
dependencies and your code weigh more than this limit, different solutions are
available to lighten the image of your application:

* Try to remove unused external dependencies or assets.
* Define a [.slugignore file]({% post_url platform/app/2000-01-01-slugignore %})
  to exclude files from the image.

If you absolutely need all these data, please contact us at
[support@scalingo.com](mailto:support@scalingo.com).

{% note %}
Why this quota? Besides being a security limit, this quota is also present to
preserve the PaaS user experience. A large image results in longer deployments,
and the instantness aspect is lost.
{% endnote %}

### Archive Too Large

When deploying an application, the Scalingo build system downloads the source
code as an archive. The maximum archive size is limited to **300 MB**.

If your archive exceeds this limit you will get the following error:

```text
Fail to fetch source code: fail to handle tgz: The archive is too heavy (more than 314572800 bytes)
```

{% note %}
The limit applies to the **uncompressed** archive.

For example: given a **200 MB `.tar.gz`** archive, when the underlying `.tar`
archive is larger than **300 MB**, then you will encounter this limit.
{% endnote %}

If you need to deploy a larger archive, please contact us at
[support@scalingo.com](mailto:support@scalingo.com).

## Not Sure This Is Your Case?

If the build succeeded and the platform is now trying to start your
application, continue with [Boot and Startup Errors]({% post_url
platform/app/troubleshooting/2000-01-01-boot-and-startup-errors %}).

If your issue looks specific to a given language or framework, check the
technology-specific guides such as [Node.js Common Deployment Errors]({%
post_url languages/nodejs/2000-01-01-deployment-errors %}).

If the problem is related to process types, start commands, or the command used
to boot your application, review the [Procfile]({% post_url
platform/app/2000-01-01-procfile %}) documentation.
