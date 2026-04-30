---
title: Deployment Issues
modified_at: 2026-04-30 00:00:00
tags: app deployment troubleshooting buildpack build errors
index: 1
---

This page gathers common issues that can happen before an application image is
ready to start.


## Unknown Technology

When pushing your app to Scalingo, you might get the following error:

```text
<-- Start deployment of [my-app] -->
 !     We didn't find the type of technology you are using...
       We're sorry this build is failing!

       Refer to the documentation to find out why:
       https://doc.scalingo.com/deployment/unknown-technology

       If you can't find the issue in your application,
       please send us an email at support@scalingo.com

       <3,
       Scalingo
 !   Error deploying the application
 !   -> Invalid return code from buildpack
```

There are two main solutions to this problem.

### Project in a Subdirectory (Monorepo)

Your project might be located in a subdirectory of your Git repository, which
is common in monorepo setups. This is supported, but note that Scalingo's
deployment system looks at the repository root by default.

You need to setup the `PROJECT_DIR` environment variable for your application.
See our dedicated page on
[environment variables]({% post_url platform/app/2000-01-01-environment %}).

You can find more information about monorepo deployment in our
[dedicated guide]({% post_url platform/app/2000-01-01-monorepo %}).

### Technology Detection

To detect the technology used by your application, we iterate over the
technologies alphabetically. It means that if your project contains multiple
technologies, we will pick the first one detected.

If you want to skip the detection phase and force the use of a specific
buildpack, add the environment variable `BUILDPACK_NAME` to your project.

If you need to use multiple technologies, you can use the [multi-buildpacks]({%
post_url platform/deployment/buildpacks/2000-01-01-multi %}).

You can also develop your own buildpack and add the environment variable
`BUILDPACK_URL` to have complete control on the detection and build phases.

More information is available on [buildpacks]({% post_url
platform/deployment/buildpacks/2000-01-01-intro %}) or [multi-buildpacks]({%
post_url platform/deployment/buildpacks/2000-01-01-multi %}).

Each language has its own expected files and conventions. Check the start page
for your application language:

{% include language_start_pages.md %}

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

During the deployment process, Scalingo first builds your application: its
dependencies are gathered and packaged into an **application image**.

### Invalid Return Code From Buildpack

Your application image is built using a buildpack ([List of buildpacks]({%
post_url platform/deployment/buildpacks/2000-01-01-intro %})).
If the buildpack exits with an error, it is probably linked to your project.
You should be able to see the content of the error in your console. Then adapt
your code according to it.

If you think the error comes from our buildpacks, feel free to contact us and
we will fix it as soon as we can.

### Image Too Large

The maximum size of an application image is **2 GiB**. If your assets, your
dependencies, and your application code exceed this limit, you need to reduce
the size of the image before deployment:

* Try to remove unused external dependencies or assets.
* Define a [.slugignore file]({% post_url platform/app/2000-01-01-slugignore %})
  to exclude files from the image.

If you absolutely need all this data, please contact our support team.

{% note %}
  Keep your application image as small and lightweight as possible. Smaller
  images help make builds, deployments, and application scaling faster and
  smoother.
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

For example: given a **200 MB .tar.gz** archive, when the underlying **.tar**
archive is larger than **300 MB**, then you will encounter this limit.
{% endnote %}

If you need to deploy a larger archive, please contact our support team.
