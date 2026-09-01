---
modified_at: 2026-05-18 12:00:00
title: 'SonarQube - Deprecation'
github: 'https://github.com/Scalingo/sonarqube-buildpack'
---

The [sonarqube-buildpack](https://github.com/Scalingo/sonarqube-buildpack) has
been deprecated and archived on the 18th of May 2026.

SonarQube now embeds Elasticsearch, making it hard to scale properly and
persist data across restarts on Scalingo. As a result, we can no longer provide
a reliable deployment experience.

If you want to deploy SonarQube on Scalingo, please use your own buildpack.

We won't provide any support for SonarQube anymore.
