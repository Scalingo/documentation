---
title: Deploy with Git
modified_at: 2019-07-08 00:00:00
tags: git deployment
index: 4
---

To deploy with Git you'll have to create a new application on Scalingo. A Git repository will be automatically created. Every push on the master branch of this repository will trigger a new deployment.

### How to Create an App

```bash
# Create app with the CLI (or create one from the dashboard)
scalingo create my-app

# Setup the Git remote:
git remote add scalingo git@ssh.osc-fr1.scalingo.com:my-app.git
```

Note that the remote URL depends on the region of your application. You can get
it using our CLI with:

```bash
scalingo --app my-app git-show
```

Deploy your application:

```bash
git push scalingo master
```

### Deploy with Another Branch than Master

If you want to deploy another branch than master:

```bash
# Here we want do deploy 'mybranch' which is a local branch
git push scalingo mybranch:master
```

### Deploy a Previous Version of an App

If you want to deploy a version of your code that is not the current head of
master, you first need to get the commit ID with `git log`. Then:

```bash
git push --force scalingo <commit ID>:master
```


### Git Authentication and SSH

The Git server created by Scalingo uses SSH authentication. If you have any
problem setting up SSH please read [Troubleshooting `git push` and SSH common
issues]({% post_url platform/getting-started/2000-01-01-troubleshooting-ssh %}).

### And After?

See [Deployment Environment]({% post_url platform/app/2000-01-01-environment
%}#build-environment) to configure your application and [Procfile]({% post_url
platform/app/2000-01-01-procfile %}).
