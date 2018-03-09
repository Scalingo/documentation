---
title: Deploy with Git
modified_at: 2017-08-03 00:00:00
tags: git deployment
order: 0
---

To deploy with Git you'll have to create a new application on Scalingo. A Git repository will be automatically created. Every push on the master branch of this repository will trigger a new deployment.

### How to create an app

```bash
# Create app with the CLI (or create one from the dashboard)
scalingo create my-app

# Setup the Git remote:
git remote add scalingo git@scalingo.com:my-app.git

# Deploy your app:
git push scalingo master
```

### Deploy with another branch than master

If you want to deploy another branch than master:

```bash
# Here we want do deploy 'mybranch' which is a local branch
git push scalingo mybranch:master
```

### Git authentication and SSH

The Git server created by Scalingo uses SSH authentication. If you have any problem setting up SSH please read [Troubleshooting `git push` and SSH common issues]({% post_url platform/getting-started/2000-01-01-troubleshooting-ssh %}).

### And after?

See [Deployment Environment]({% post_url platform/app/2000-01-01-build-environment %}) to configure your application and [Procfile]({% post_url platform/app/2000-01-01-procfile %}).
