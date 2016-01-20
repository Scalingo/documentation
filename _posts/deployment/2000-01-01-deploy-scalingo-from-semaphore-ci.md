---
title: Deploy to Scalingo from Semaphore
modified_at: 2016-01-20 00:00:00
category: deployment
tags: ci deployment build semaphore-ci
---

To setup **Continuous Deployment** from Semaphore to Scalingo, please follow the [official guide](https://semaphoreci.com/docs/deploying-with-git-deploy.html) which will take you through the steps. Once you are at the **deploy commands** step the following section will help you to fill it.

### Setup Deploy Commands

```bash
# Add Scalingo as a known host
ssh-keyscan -H -p 22 scalingo.com >> ~/.ssh/known_hosts

# Push the branch you've setup on Semaphore
git push --force git@scalingo.com:example-app.git $BRANCH_NAME:master
```

### SSH Keys

To deploy to Scalingo from Semaphore, you'll have to add your private key to the Semaphore interface. You will also need to add the public key to the [SSH Keys page](https://my.scalingo.com/keys) on Scalingo Dashboard.

We recommand to generate a new key pair for integrating Semaphore with Scalingo.

