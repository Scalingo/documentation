---
title: Deploy with Git
modified_at: 2017-08-03 00:00:00
category: deployment
tags: git deployment
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
