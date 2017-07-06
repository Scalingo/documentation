---
title: Deploy to Scalingo from CircleCI
modified_at: 2016-06-14 00:00:00
category: deployment
tags: ci deployment build circle-ci
---

This page describes steps to setup **Continuous Deployment** from CircleCI to Scalingo. Follow this guide to automatically deploy to Scalingo after a successful build.

### Setup `circle.yml`

To trigger a deployment after a success build on Circle you have to add the `deployment` section to your `circle.yml`:

```yaml
deployment:
  production:
    branch: master
    commands:
      - git push git@scalingo.com:example-app.git $CIRCLE_SHA1:master
```

You can read more about Configuring CircleCI [Deployment](https://circleci.com/docs/configuration#deployment) on the CircleCI documentation.

### SSH Keys

To deploy to Scalingo from CircleCI, you'll have to add your private key to the CircleCI interface. On CircleCI website, head over to your project's **Project Settings**, then the **SSH keys** page to add your key. You will also need to add the public key to the [SSH Keys page](https://my.scalingo.com/keys) on Scalingo Dashboard.

We recommand to generate a new key pair for integrating CircleCI with Scalingo.

### Executing post-delpoyment commands

You've to download our command line tool in the CircleCI environment and use the `scalingo run` command.

```yaml
deployment:
    production:
      branch: production
      commands:
        - git push git@scalingo.com:example-app.git $CIRCLE_SHA1:master
        - curl -LO https://github.com/Scalingo/cli/releases/download/1.3.1/scalingo_1.3.1_linux_amd64.tar.gz
        - tar xvf scalingo_1.3.1_linux_amd64.tar.gz
        - scalingo_1.3.1_linux_amd64/scalingo -a example-app login --ssh
        - scalingo_1.3.1_linux_amd64/scalingo -a example-app run rake db:migrate
```
