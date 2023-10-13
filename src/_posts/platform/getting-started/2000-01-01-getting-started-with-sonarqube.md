---
title: Getting Started With SonarQube on Scalingo
modified_at: 2023-11-13 16:00:00
tags: tutorial sonarqube
index: 15
---

SonarQube is an automatic code review tool to detect bugs, vulnerabilities, and
code smells in your project. It can integrate with your existing workflow to
enable continuous code inspection across your project branches and pull
requests.

This tutorial will show you how to deploy a SonarQube instance on Scalingo in
under 5 minutes.

## Deploying SonarQube

### Planning your Deployment

- Sonarqube requires its own database. We usually advise to use a [PostgreSQL
  Starter or Business 512 addon](https://scalingo.com/databases/postgresql) for
  this purpose.

- Sonarqube requires quite a lot of RAM to run properly. We recommend to deploy
  at least one 2XL container to host it.

- SonarQube require Java version 17 to run. We can instruct Scalingo to use
  this version of JAVA by using the `system.properties` file as described in
  [our documentation]({% post_url languages/java/2000-01-01-start %}#choose-a-jdk).

### Using our One-Click Deploy Button

Click the One-Click Deploy button below to automatically deploy SonarQube with
your Scalingo account:

[![Deploy](https://cdn.scalingo.com/deploy/button.svg)](https://my.scalingo.com/deploy?source=https://github.com/Scalingo/scalingo-sonarqube)

### Using the Command Line

We maintain a repository called [scalingo-sonarqube](https://github.com/Scalingo/scalingo-sonarqube)
on GitHub to help you deploy SonarQube **Community Edition** on Scalingo. Here
are the few steps you will need to follow:

1. Clone our repository:

   ```bash
   git clone https://github.com/Scalingo/scalingo-sonarqube
   cd scalingo-sonarqube
   ```

2. Create the application on Scalingo (to keep things simple in this tutorial,
   we will call it `my-app`):

   ```bash
   scalingo create my-app
   ```

   Notice that our Command Line automatically detects the git repository, and
   adds a git remote to Scalingo:

   ```bash
   git remote -v

   origin   https://github.com/Scalingo/scalingo-sonarqube (fetch)
   origin   https://github.com/Scalingo/scalingo-sonarqube (push)
   scalingo git@ssh.osc-fr1.scalingo.com:my-app.git (fetch)
   scalingo git@ssh.osc-fr1.scalingo.com:my-app.git (push)
   ```

3. Create the database:

   ```bash
   scalingo --app my-app addons-add postgresql postgresql-starter-512
   ```

4. Everything's ready, deploy to Scalingo:

   ```bash
   git push scalingo master
   ```

{% note %}
The default credentials after a first deployment are `admin` and `admin`.
After a first successful login, SonarQube asks you to update the admin
password.
{% endnote %}


## Updating SonarQube

By default, Scalingo tries to install the latest LTS version of the Community
Edition, which we try to keep up-to-date [in the buildpack](https://github.com/Scalingo/sonarqube-buildpack/blob/master/bin/compile#L16).

Consequently, updating SonarQube only consists of triggering a new deployment
of your instance. To do so, create an empty commit and push it to Scalingo:

```bash
$ git commit --allow-empty -m "Update SonarQube"
$ git push scalingo master
```

{% note %}
Scalingo does not provide any guarantee in terms of packaging and availability
after each SonarQube release. You can still get in touch with our support team,
should you need a specific version.
{% endnote %}


## Customizing your Deployment

### Deploying a Specific Version

You can install the version of your choice by adding the environment variable
`SONARQUBE_VERSION` to your application. For example, using the command line:

```bash
scalingo --app my-app env-set SONARQUBE_VERSION="10.2.1.78527"
```

### Installing a SonarQube Plugin

To install a SonarQube plugin:
- Copy the plugin JAR archive into the `plugins` folder of your repository ;
- Commit the content of this repository ;
- Push it to Scalingo.

Your SonarQube instance will have the plugin installed.


### Environment

[SonarQube supports many environment variables](https://docs.sonarsource.com/sonarqube/latest/setup-and-upgrade/configure-and-operate-a-server/environment-variables/)

Moreover, the buildpack makes use of the following environment variable(s).
They can be leveraged to customize your deployment:

| Name                | Description                  | Default Value    |
| ------------------- | ---------------------------- | ---------------- |
| `SONARQUBE_VERSION` | SonarQube version to deploy. | Set in buildpack |


