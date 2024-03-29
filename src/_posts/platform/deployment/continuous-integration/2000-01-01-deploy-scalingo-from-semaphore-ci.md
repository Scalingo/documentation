---
title: Deploy to Scalingo from Semaphore
nav: Deploy from Semaphore
modified_at: 2022-04-26 00:00:00
tags: ci deployment build semaphore-ci
index: 23
---

To setup **Continuous Deployment** from Semaphore to Scalingo, please follow the
[official guide](https://semaphoreci.com/docs/deploying-with-git-deploy.html)
which will take you through the mandatory steps. This documentation page adds
some information for the step 3 **Write your deploy commands** of the Semaphore
guide.

### Setup Deploy Commands

```bash
# Add Scalingo as a known host
ssh-keyscan -H -ssh.osc-fr1.scalingo.com >> ~/.ssh/known_hosts
```

The SSH port and host actually depend on the region of your application:

{% include ssh_endpoints.md %}

```bash
# Push the branch you've setup on Semaphore
git push --force git@ssh.osc-fr1.scalingo.com:my-app.git $BRANCH_NAME:master
```

Note that the remote URL depends on the region of your application. You can get
it using our CLI with:

```bash
scalingo --app my-app git-show
```

### SSH Keys

To deploy to Scalingo from Semaphore, you'll have to add your private key to the
Semaphore interface. You will also need to add the public key to the [SSH Keys
page](https://dashboard.scalingo.com/account/keys) on the Scalingo Dashboard.

We recommend to generate a new key pair for integrating Semaphore with Scalingo.
