---
title: Deploy with Git
modified_at: 2017-08-03 00:00:00
category: deployment
tags: git deployment
order: 0
---

To deploy with git, you'll have to create a new application on Scalingo, choose your addon if you need one and follow the command on the section deployment. 

### Setup Deploy Commands

```bash
# Setup the git remote:
git remote add scalingo git@scalingo.com:yourapplication.git

# Deploy your app:
git push scalingo master
```

### Deploy with an other branch than master

If you want to deploy an application since a branch doesn't called `master`, put the command :

```bash
git push scalingo yourbranche:master
```

### Git authentication and SSH

If you have any problem to create the application, it must be due to a git autentication error or an invalid SSH key error. Please see [Troubleshooting git push and SSH common issues]({% post_url ssh/2000-01-01-troubleshooting-ssh %})

### And after?

See [Deployment Environment]({% post_url app/2000-01-01-build-environment %}) to configure your application and [Procfile]({% post_url internals/2014-12-01-procfile %}).
