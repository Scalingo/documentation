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

### Clone Your Code

{% warning %}
  A Scalingo Git repository is intended for deployment purposes only. Cloning
  from this repository is not officially supported as a feature and should only
  be attempted as a last resort.  Do not use Scalingo's repository for code
  storage. Instead, use your own Git server or a Git hosting service like
  GitHub or GitLab.
{% endwarning %}

Once a deployment has succeeded, you can recover the code you pushed to Scalingo using:

```
git clone --origin scalingo git@ssh.osc-fr1.scalingo.com:my-app.git
```

This will create a copy of the Git history hosted in Scalingo repositories.
It will also add the `scalingo` remote to simplify future pushes.

{% note %}
  Only Git operations will be available via `git clone`. If you deployed your app
  in any other way (GitLab / GitHub integration, archive, ...) the changes made
  to your code won't be available.
{% endnote %}


### Shallow Error

Currently, Scalingo does not support update of shallowed repository (i.e. from a `git push`).
The `shallow error` means that the pushed repository on Scalingo does not contains all its history.
The error can happen whether you are pushing from your workstation or from an online worker.

It is often the result of a clone with the Git parameter `--depth`).

To be able to push the modifications, you need first to `unshallow` the repository.
To do so, please follow the instructions below.

#### From Your Environment:

You need to get all the repository history with the command:

```bash
git fetch origin YOUR_BRANCH --unshallow
```

Then retry to push your code with:

```bash
git push scalingo master
```

#### From the Continuous Integration

Some CI offers you the possibility to disable shallow repository by disabling
the parameter `depth` from configuration file.

- with travis:

  ```yml
  # .travis.yml
  git:
    depth: false
  ```

- with Gitlab CI:

  ```yml
  # .gitlab-ci.yml
  variables:
    GIT_DEPTH: 0
  ```

If the problem persist, you must surely run the following Git command once:

```bash
git fetch origin YOUR_BRANCH --unshallow
```
