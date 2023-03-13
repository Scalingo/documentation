---
title: Deploy with Git
modified_at: 2023-03-13 00:00:00
tags: git deployment
index: 4
---

To deploy with Git you'll have to create a new application on Scalingo. A Git repository will be automatically created. Every push on the master branch of this repository will trigger a new deployment.

### How to Create an App

```bash
# Create app with the CLI (or create one from the Dashboard):
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
# OR
git push scalingo main
```

{% note %}
  Note that we only accept the master and main branch on Scalingo Git servers.
  If you want to push on another branch, see below the command to push your branch.
{% endnote %}

### Deploy with Another Branch than Master and Main

If you want to deploy another branch than master and main:

```bash
# Here we want do deploy 'mybranch' which is a local branch
git push scalingo mybranch:master
# OR
git push scalingo mybranch:main
```

### Deploy a Previous Version of an App

If you want to deploy a version of your code that is not the current head of
master, you first need to get the commit ID with `git log`. Then:

```bash
git push --force scalingo <commit ID>:refs/heads/master
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

```bash
git clone --origin scalingo git@ssh.osc-fr1.scalingo.com:my-app.git
```

This will create a copy of the Git history hosted in Scalingo repositories.
It will also add the `scalingo` remote to simplify future pushes.

{% note %}
  Only Git operations will be available via `git clone`.
  If you deployed your app in any other way (GitLab / GitHub integration, archive, ...)
  the changes made to your code won't be available.
{% endnote %}

#### Known Issue with Master Branch

If you have the following message when doing a `git clone`:
```
warning: remote HEAD refers to nonexistent ref, unable to checkout.
```

It means that you're using the `master` branch. Since the default branch is now
`main`, `git` doesn't know that you're using `master` branch instead of `main`.

You need to manually checkout to the right branch inside the Git repository with:
`git checkout master` to retrieve the content of the repository.

Or if you want to avoid this error when doing the `git clone` command you can
add `--branch master` argument, like this:
```bash
git clone --branch master git@ssh.osc-fr1.scalingo.com:my-app.git
```

### Shallow Error

Currently, Scalingo does not support update of shallowed repository (i.e. from a `git push`).
The shallow error means that the pushed repository on Scalingo does not contains all its history.
The error can happen whether you are pushing from your workstation or from an online worker.

It is often the result of a clone with the Git parameter `--depth`.

To be able to push the modifications, you need to first unshallow the repository.
For that purpose, please follow the instructions below.

#### From Your Environment:

You need to get all the repository history with the command:

```bash
git fetch origin master --unshallow
```

Then retry to push your code with:

```bash
git push scalingo master
```

#### From the Continuous Integration

Some CI offers you the possibility to disable shallow repository by disabling
the parameter `depth` from configuration file.

- with Travis:

  ```yml
  # .travis.yml
  git:
    depth: false
  ```

- with GitLab CI:

  ```yml
  # .gitlab-ci.yml
  variables:
    GIT_FETCH_EXTRA_FLAGS: --unshallow
    GIT_DEPTH: 0
  ```

If the problem persists, you must surely run the following Git command once:

```bash
git fetch origin master --unshallow
```

### SSH Endpoints

{% include ssh_endpoints.md %}
