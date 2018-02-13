---
title: Scale automatically your application
nav: Autoscaling
modified_at: 2018-04-05 00:00:00
tags: app scaling metrics autoscaler
---

<blockquote class="bg-info">
  You might want to read first the page <a href="{% post_url platform/app/2000-01-01-scaling %}">about
  scaling an application</a>.
</blockquote>

The autoscaling feature lets you scale automatically your application up and down, depending on a
user-defined metric.

An autoscaler can be added to an application by going to the "Containers" tab of your app:

TODO: Better screenshot

{% assign img_url = 'https://cdn.scalingo.com/documentation/screenshot_dashboard_autoscalers.png' %}
{% include mdl_img.html %}

The **Desired Target** is used by the autoscaler to adapt the number of containers of your
application. We also provide you with the 95th percentile average over the last 24 hours as a
recommendation value.

## Autoscaling Logic

Scalingo's autoscaler service bases its decisions on a user defined metric (e.g. RPM per container,
response time, CPU consumption...). When creating a new autoscaling, a target is provided. Our
algorithm tries to keep the metric as close to the target as possible by scaling up or down the
application.

The autoscaler only scale the application up or down by one container. After a scale event, the
autoscaler will not scale the application up again before at least one minute. The scale down is a
bit less aggressive with a three minutes cooldown. These cooldown values prevent the autoscaler to
scale the application frantically.

## Available Metrics

The autoscaling of an application can depend on five different metrics:

* Containers resource consumption: RAM, CPU and swap,
* 95th percentile of the requests response time,
* Requests per minute per container,

The last two metrics are only available for `web` containers.

## Monitoring Autoscaling Events

Every time an application is scaled by the autoscaler, an event is created. This event appears on
the application's timeline. The user responsible for the operation is labeled
`scalingo-platform-autoscaler`.

{% assign img_url = 'https://cdn.scalingo.com/documentation/screenshot_dashboard_autoscaler_timeline.png' %}
{% include mdl_img.html %}

Notifications for such events are sent if you set it up in the Notifications section. A guide to
configure these notifications is available [here]({% post_url platform/app/2000-01-01-notification
%}).

## Autoscaling Limits

An increased response time or resource consumption of an application can have different causes and
scaling horizontally might not solve the issue. These causes can be:

- A memory leak in your application.
- The database uses all its resources.

In such cases, configuring an autoscaler will not improve the responsiveness of the application. One
should investigate these issues before enabling an autoscaler.
