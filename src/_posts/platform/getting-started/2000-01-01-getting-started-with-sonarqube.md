---
title: Getting started with SonarQube on Scalingo
modified_at: 2021-02-05 00:00:00
tags: tutorial sonarqube
index: 15
---

SonarQube is an automatic code review tool to detect bugs, vulnerabilities, and code smells in your code. It can integrate with your existing workflow to enable continuous code inspection across your project branches and pull requests.

This tutorial will show you how to deploy a SonarQube instance on Scalingo in under 2 minutes.

## SonarQube Deployment

We published a repository [scalingo-sonarqube](https://github.com/Scalingo/scalingo-sonarqube) on GitHub to help you deploy SonarQube on Scalingo. Deploying a SonarQube instance is now at a click range:

[![Deploy](https://cdn.scalingo.com/deploy/button.svg)](https://my.scalingo.com/deploy?source=https://github.com/Scalingo/scalingo-sonarqube)

By default, Scalingo installs the version declared in the buildpack [here](https://github.com/Scalingo/sonarqube-buildpack/blob/master/bin/compile#L16). At the time of writing this version is `8.6.1.40680`. You may want to install an older or more recent version.

By default, SonarQube asks you for a login and a password. The defaults are `admin` and `admin`. After the first successful login, SonarQube asks you to update the admin password.

## Install a SonarQube Plugin

You may want to install a SonarQube plugin. In such situation, fork the [scalingo-sonarqube](https://github.com/Scalingo/scalingo-sonarqube) repository. Then copy the plugin JAR archive into the `plugins` folder. Commit the content of this repository, and push it to Scalingo. Your SonarQube instance will have the plugin installed.

## Deploy a Specific SonarQube Version

By default, Scalingo installs the SonarQube version 8.6.0.39681. You can install the version of your choice by adding the environment variable `SONARQUBE_VERSION` to your application. For example:

```
SONARQUBE_VERSION=8.1.0.31237
```
