---
title: Deploy to Scalingo from CircleCI
nav: Deploy from CircleCI
modified_at: 2019-09-24 00:00:00
tags: ci deployment build circle-ci
index: 22
---

This page describes the steps to setup **Continuous Deployment** from CircleCI to Scalingo. Follow this guide to automatically deploy to Scalingo after a successful build.

{% note %}
Each time the token `[region]` is present in examples, replace it by the name of the region you are actually using (`osc-fr1`, `osc-secnum-fr1`, `agora-fr1`, etc.)
{% endnote %}

### Setup `.circleci/config.yml`

To trigger a deployment after a successful build on CircleCI you have to add a `deploy` job and configure workflows in your `.circleci/config.yml`:

```yaml
version: 2
jobs:
  build:
    steps:
      # Add steps to build your app
  deploy:
    machine:
      enabled: true
    steps:
      - run:
          name: Add Scalingo to known_hosts
          command: ssh-keyscan -H ssh.[region].scalingo.com >> ~/.ssh/known_hosts
      - run:
          name: Deploy on Scalingo
          command: |
            git push git@ssh.[region].scalingo.com:my-app.git $CIRCLE_SHA1:master
workflows:
  version: 2
  build-and-deploy:
    jobs:
      - build
      - deploy:
          requires:
            - build
          filters:
            branches:
              only: master
```

You can read more about Configuring CircleCI [Deployment](https://circleci.com/docs/2.0/deployment-integrations/#overview) on the CircleCI documentation.

### SSH Keys

To deploy to Scalingo from CircleCI, you'll have to add your private key to the CircleCI interface. On CircleCI website, head over to your project's **Project Settings**, then the **SSH keys** page to add your key. You will also need to add the public key to the [SSH Keys page](https://my.scalingo.com/keys) on Scalingo Dashboard.

We recommend to generate a new key pair for integrating CircleCI with Scalingo.

### Executing post-deployment commands

You can define [postdeploy hook]({% post_url platform/app/2000-01-01-postdeploy-hook %}) integrated in your Procfile. If you still prefer to run post-deployment commands at CircleCI level, you will have to download our command line tool in the CircleCI environment and use the `scalingo run` command.

```yaml
command: |
  ssh-keyscan -H ssh.[region].scalingo.com >> ~/.ssh/known_hosts
  git push git@ssh.[region].scalingo.com:my-app.git $CIRCLE_SHA1:master
  curl -LO https://github.com/Scalingo/cli/releases/download/1.6.0/scalingo_1.6.0_linux_amd64.tar.gz
  tar xvf scalingo_1.6.0_linux_amd64.tar.gz
  scalingo_1.6.0_linux_amd64/scalingo -a my-app login --ssh
  scalingo_1.6.0_linux_amd64/scalingo -a my-app run rake db:migrate
```
