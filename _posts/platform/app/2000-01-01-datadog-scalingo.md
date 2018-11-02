---
layout: page
title: Configure Datadog to monitor Scalingo applications
nav: Configure Datadog
tags: integration datadog
---

## Integration purposes

Datadog is a SaaS product helping you to monitor your web applications. It requires the Datadog
agent to be run so that it sends monitoring data to the service. You can eventually build dashboards
to visualize the different information gathered and get a better understanding of your application
resources consumption.

## Configuration of your application on Scalingo

In order to install the Datadog agent, you must use a specific buildpack. Hence you need to
configure your application to [use a multi buildpack]({% post_url
platform/deployment/buildpacks/2000-01-01-multi %}).

In the `.buildpacks` file at the root of your project, add the
`https://github.com/DataDog/heroku-buildpack-datadog.git` buildpack in first position. Then add
your language specific buildpack.

The Datadog buildpack is configurable through various environment variables. The only mandatory
one is `DD_API_KEY` available from the [Datadog API
integrations](https://app.datadoghq.com/account/settings#api) page. You can have a look at the
[buildpack's README](https://github.com/DataDog/heroku-buildpack-datadog#configuration) for a
comprehensive list of available configuration options.

{% note %}
The Datadog buildpack takes up to 350 MB. If Scalingo build system complains about the image
size, contact the support on the embedded chat or at
[support@scalingo.com](mailto:support@scalingo.com) for an increased limit.
{% endnote %}
