---
title: Deployment Process
modified_at: 2018-02-09 01:00:00
order: 3
tags: deployment
---

The deployment process on Scalingo is composed of several steps. This article
aims at describing each of those to offer a comprehensive understanding to the
reader.

## Deployment Trigger

The first step to trigger a deployment is to send the application itself to the
platform (either the code or a build version of it). Multiple methods are
available to achieve this step:

* [Sending the code using git]({% post_url deployment/2017-08-03-deploy-with-git %})
* [Let the platform fetch the code from GitHub]({% post_url deployment/2017-08-03-deploy-with-github %})
* [Sending the code in a tar achive]({% post_url deployment/2000-01-01-deploy-from-archive %})

Special deployment methods are available for JVM-based applications:

* [Sending a built JAR or WAR archive]({% post_url deployment/2000-01-01-deploy-java-jar-war %})

## Building the application

Once the deployment has been triggered, the next phase is named **build**.
During this step, the deployment system detects the technologies used by the
application and installs everything required in order to make it runnable.

{% note %}
  For instance, in the case of a Ruby on Rails application, the correct version
  of Ruby is installed, then all the gems are downloaded using `bundle` and the
  assets are precompiled.
{% endnote %}

This process to detect the technology and to install all its dependencies is
based on open-source tools named [*buildpack*]({% post_url
internals/buildpacks/2015-01-04-buildpacks %}). At the beginning of the build, the
[officially supported buildpacks]({% post_url
internals/buildpacks/2015-01-04-buildpacks %}#buildpacks-included-on-scalingo)
are automatically used to detect which one can be used to build the
application, they usually cover most use cases.

However it may happen your application technology is not detected, or your
application is using multiple stacks (ie. Python + NodeJS), both these cases
are also covered.

As mentionned before buildpacks are open-source and other hosting providers are
also using them to deploy applications, thus the developer community has
developed a wide range of buildpacks for almost any kind of technology. The
platform has been designed to be extended by community buildpacks, [learn how
to do it here]({% post_url internals/buildpacks/2015-01-04-custom-buildpacks
%}).

If a project is based on multiple language runtimes, buildpacks can be combined
to install dependencies of multiple stacks. A custom buildpack has been created
to achieve this goal: [the multi buildpacks]({% post_url
internals/buildpacks/2015-09-28-multi-buildpack %}).

## Rolling out the new version of the application

Once your code is built, the deployment arrives at its last step, aiming at
replacing the previous version of the application by the one which just got
built. This step ensures the platform is able to achieve
**zero-downtime/rolling deployments** of application. The process is the
following:

1. Start containers with the new version of the application
2. Wait them to be ready: **TCP** `SYN` are sent to `web` and `tcp` containers,
   to check if the process inside them has correctly started and is listening
   to the port defined by the environment variable `PORT`. More details about
   container start operations is available [here]({% post_url
   internals/2014-11-25-container-management %}#starting-new-containers).
3. If a [postdeploy hook]({% post_url app/2000-01-01-postdeploy-hook %}) is
   defined, it is executed in a **one-off** container of the new version of the
   application. In the case the hook fails, the deployment would stop and the
   previous version would keep running.
4. Network traffic is routed to the containers hosting the new version of the
   application.

Once these 4 steps have ended successfuly, the deployment is considered as
successful, and the [order to shutdown]({% post_url
internals/2014-11-25-container-management %}#shutdown-of-old-containers) is
sent to old containers. They now have 30 seconds to cleanup cleanly.
