---
title: Deploy to Scalingo from GitLab CI/CD
nav: Deploy from GitLab CI
modified_at: 2020-07-29 00:00:00
tags: ci deployment build gitlab
index: 22
---

{% note %}
This page explain how to deploy your application using GitLab CI/CD. In order to
automatically deploy your application when `git push`-ing to your GitLab
repository, please refer to the [GitLab integration]({% post_url
platform/deployment/2000-01-01-deploy-with-gitlab %}) page.
{% endnote %}

This page describes steps to setup **Continuous Deployment** from GitLab CI/CD
to Scalingo. Follow this guide to automatically deploy to Scalingo after a
successful build.

### Setup GitLab CI/CD Steps

Deploying to Scalingo is simplified by the
[dpl](https://github.com/travis-ci/dpl#scalingo) tool. To trigger a deployment
after a success build on GitLab CI/CD, here are the steps to configure in your
`.gitlab-ci.yml`:

```yaml
deploydevelopment:
  stage: deploy
  variables:
    SCALINGO_APP_NAME: <app name>
    SCALINGO_REGION: osc-fr1
  dependencies:
    - test:rspec_models
    - test:rspec_controllers
    - test:rspec_features
  only:
    - develop
  script:
    - gem install dpl --pre
    - dpl --provider=scalingo --app=$SCALINGO_APP_NAME --api-token=$SCALINGO_API_TOKEN --region=$SCALINGO_REGION
```

{% note %}
It is important to install dpl with the `--pre` flag. This is due to an issue in
dpl v1. The `--pre` flag installs dpl v2.
{% endnote %}

### Scalingo API Token

The variable `SCALINGO_API_TOKEN` must be an API token available on the
'Profile' page of the [Scalingo Dashboard](https://my.scalingo.com/profile). Do
NOT store this token in the `.gitlab-ci.yml` file. Please refer to this [GitLab
documentation
page](https://docs.gitlab.com/ee/ci/examples/deployment/#storing-api-keys).
