---
title: Scale automatically your application
nav: Autoscaling
modified_at: 2018-04-05 00:00:00
tags: app scaling metrics autoscaler
---

{% include beta_feature.md %}

{% note %}
  You might want to read first the page about [scaling an application]({% post_url
  platform/app/2000-01-01-scaling %}).
{% endnote %}

The autoscaling feature lets you scale automatically your application up and
down, depending on a user-defined threshold on the application metric.

An autoscaler can be added to an application by going to the "Containers" tab
of your app:

{% assign img_url = 'https://cdn.scalingo.com/documentation/screenshot_dashboard_autoscalers.png' %}
{% include mdl_img.html %}

The **Target** is used by the autoscaler to adapt the number of containers of
your application. We also provide you with a recommended value you can use as
the target. This recommended value is based on the median over the last 24 hours
of your application for most metrics. It means that it is only based on
historical usage and not on predictions on the future. The recommended value for
the CPU and the RAM usage is fixed and is 90%.

Finding the best target for your application is not an easy task. One should run
benchmarks on its application to detect which metric is the bottleneck. A good
procedure can be to scale the application to 1 container and execute a load
testing tool (e.g. [Vegeta](https://github.com/tsenart/vegeta)) against it. For
instance, if you observe your application does not respond after 100 RPM,
configuring the target to 80 RPM per container so that Scalingo automatically
scales up the application seems a good idea. These load tests should be executed
against the most greedy endpoints for better results.

## Autoscaling Logic

Scalingo's autoscaler service bases its decisions on a user defined metric
(e.g. RPM per container, response time, CPU consumption...). When creating a
new autoscaling, a target is provided. Our algorithm tries to keep the metric
as close to the target as possible by scaling up or down the application.

The autoscaler only scale the application up or down by one container. After a
scale event, the autoscaler will not scale the application up again before at
least one minute. The scale down is a bit less aggressive with a three minutes
cooldown. These cooldown values prevent the autoscaler to scale the application
frantically.

## Available Metrics

The autoscaling of an application can depend on five different metrics:

* Containers resource consumption: RAM, CPU and swap,
* 95th percentile of the requests response time,
* Requests per minute (RPM),
* and RPM per container: if your application has multiple `web` containers, it
  is the RPM divided by the number of containers.

The last three metrics are only available for `web` containers.

## Monitoring Autoscaling Events

Every time an application is scaled by the autoscaler, an event is created.
This event appears on the application's timeline. The user responsible for the
operation is labeled `scalingo-platform-autoscaler`.

{% assign img_url = 'https://cdn.scalingo.com/documentation/screenshot_dashboard_autoscaler_timeline.png' %}
{% include mdl_img.html %}

Notifications for such events are sent if you set it up in the Notifications
section. A guide to configure these notifications is available [here]({%
post_url platform/app/2000-01-01-notification %}).

## Autoscaling Limits

An increased response time or resource consumption of an application can have
different causes and scaling horizontally might not solve the issue. These
causes can be:

- A memory leak in your application.
- The database uses all its resources.

In such cases, configuring an autoscaler will not improve the responsiveness of
the application. One should investigate these issues before enabling an
autoscaler.
