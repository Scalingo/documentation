---
title: Multi-Stage Environment on Scalingo
nav: Multi-Stage Environment
modified_at: 2018-06-01 00:00:00
tags: follow-the-light multi-stage production staging
---

When one develops a production application, having a staging environment is a good practice. Keeping
staging and production as similar as possible is one of the good practice defined in the
[12-factor](https://12factor.net). In this page, we explain how to tweak your development workflow
to adopt this best practice.

## The Git Flow

{% note %}
If your code is hosted on GitHub, you can refer to the [GitHub Flow](#the-github-flow) section.
{% endnote %}

When using Git as a version control system, we will configure two applications on Scalingo so that
you can deploy the staging applications first, then the production one.

First create two applications for your production and staging environment: namely `my-app` and
`my-app-staging`. Using the CLI:

```console
scalingo create my-app
scalingo create my-app-staging
```

Create different remote so that you can deploy on both production and staging applications:

```console
git remote add scalingo git@scalingo.com:my-app.git
git remote add scalingo-staging git@scalingo.com:my-app-staging.git
```

After developing a new feature and tested it on your development environment, you can deploy it on
the staging environment:

```console
git push scalingo-staging master
```

Test your feature by going to
[https://my-app-staging.scalingo.io](https://my-app-staging.scalingo.io). When ready, deploy to the
production application with:

```
git push scalingo master
```

## The GitHub Flow

When using GitHub to host your code, you can benefit from a deep integration with Scalingo. In this
section we explain the preferred workflow to deploy staging and production environment on Scalingo.
We will configure your applications on Scalingo so that every time you push some code on the
staging or production branch, the corresponding application automagically deploys.

First, create two branches in your Git repository to host your staging and production environments:

```console
git branch --track staging
git branch --track production
```

Then, on the Scalingo dashboard, go to the "Code" section and activate auto-deploy: auto-deploy .
