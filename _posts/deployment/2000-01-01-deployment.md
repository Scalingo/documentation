---
title: Deployment
modified_at: 2000-01-01 00:00:00
category: platform
order: 3
tags: deployment
---

## Deployment: From source code to a running application

If you've joined us, it's certainly because you like how our deployments works. You don't have to spend time worrying about *how* to deploy your code, just send it on Scalingo and it is up on the Internet.

There is multiple ways to push your code on the platform :

* [Link your app to a Github repository, it will be deployed whenever you push code on a specific branch]()
* [Use our git remote to push code from git, trigger deployment manually]()
* [Send a tar achive containing your code, useful to automate deploying from an unsupported platform]()

### Build

We use buildpacks internally to detect which language and tools we should use to build your app.

Most of the time, you'll not need to worry about that. However, in some case, you will need to configure them yourself.

The first one is if you use a language that is not officialy supported. Buildpacks are an open-source technology and one can create a buildpacks for any technology. Those custom buildpacks [can be used in Scalingo]().

The second case is when your app use more than one technology and need so [multiple buildpacks]().

### Containers

Once your code is built, we can run new instances of your app on the fly. Each instance will run in what we call a "container". You can considerate them as isolated replicable environments. Isolated because it does not depend on which machine it runs and replicable because with the same input, a container will always produce the same output.

One app can have multiple containers:

* When you [scale your app](), we create copy of your first container and requests are dispatched randomly between them.
* You can run different part of your code, for example the main app and a cron-like manager, in different containers. You can take a look at how [Procfile]() works.
* When you run a [one-off container]() from the [Scalingo CLI](), it's actually a new container created on the fly.
* A [post deployment hook]() is like a one-off but is run automatically when a deployment is launched for the first time.

There is more informations on containers on the [Container Management Page]()
