---
layout: page
title: Configure Dynatrace to monitor Scalingo applications
nav: Configure Dynatrace
modified_at: 2019-05-17 13:00:00
tags: integration dynatrace
---

## Integration purposes

Dynatrace is a SaaS product helping you to monitor your web applications.
It provides APM (Application Performance Management) and cloud infrastructure
monitoring to give you insights into how your application behaves, list
potential performance bottlenecks, etc.
It requires the Dynatrace agent to be run so that it sends monitoring data to
the service. You can eventually build dashboards to visualize the different
information gathered and get a better understanding of your application
resources consumption.

## Configuration of your application on Scalingo

In order to install the Dynatrace agent, you must use a specific buildpack. Hence you need to
configure your application to [use a multi buildpack]({% post_url
platform/deployment/buildpacks/2000-01-01-multi %}).

In the `.buildpacks` file at the root of your project, add the
`https://github.com/Dynatrace/heroku-buildpack-dynatrace.git` buildpack in
first position. Then add your language specific buildpack.

The Dynatrace buildpack is configurable through various environment variables.
The only mandatory ones are `DT_TENANT` and `DT_API_TOKEN` available from the
Dynatrace PaaS integration setup page.

You can have a look at the
[buildpack's README](https://github.com/Dynatrace/heroku-buildpack-dynatrace#configuration) for a comprehensive list of
available configuration options.

{% note %}
The Dynatrace buildpack can take a lot of disk space. If Scalingo build system
complains about the image size, contact the support on the embedded chat or at
[support@scalingo.com](mailto:support@scalingo.com) for an increased limit.
{% endnote %}
