---
title: Deployment
modified_at: 2000-01-01 00:00:00
category: platform
order: 3
tags: deployment
---

## Deployment: From source code to a running application

If you've joined us, it's certainly because you like our deployment system. We use buildpacks internally to detect which language and tools we should use to build your app. So you don't have to spend time worrying about *how* to deploy your code, just send it on Scalingo and it is up on the Internet.

There is multiple ways to push your code on the platform :

* [Link your app to a Github repository, it will be deployed whenever you push code on a specific branch]()
* [Use our git remote to push code from git, trigger deployment manually]()
* [Send a tar achive containing your code, useful to automate deploying from an unsupported platform]()

### Containers

Your code run in a "container". You can considerate them as an isolated replicable environment.

You're code is bundled inside a container since we receive it. It is then build inside of it so that, because it is completly isolated, it will always produce the same output with the same input.

One app can have multiple containers:

* When you scale your app, we create copy of your first container and requests are dispatched randomly between them.
* You can run different part of your code, for example "workers" in different containers. You can take a look at how [Procfile]() works.
