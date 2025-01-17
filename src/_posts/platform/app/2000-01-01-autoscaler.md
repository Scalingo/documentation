---
title: Scalingo Autoscaler
nav: Scalingo Autoscaler
modified_at: 2024-12-30 12:00:00
tags: app scaling autoscaling metrics autoscaler
---

{% note %}
You might consider reading about [scaling an application]({% post_url platform/app/2000-01-01-scaling %})
first.
{% endnote %}

The ***Scalingo Autoscaler*** is a feature that, once configured and enabled,
allows the platform to automatically and dynamically adjust the number of
containers of your application (horizontal scaling) depending on a performance
metric while remaining within strict boundaries to prevent unforeseen costs.

## Understanding the Autoscaler Logic

When the configured metric deviates from the defined *target*, the Autoscaler
automatically adjusts the number of containers of the application, either up or
down, to maintain the specified target.

The Autoscaler considers the following parameters to decide what to do and when
to take action:

- **Hysteresis**: the Autoscaler decision is based on the "mean per minute" of
  the target metric. Two consecutive means over the target value are required
  for the Autoscaler to boot an additional container
- **Aggregation**: for CPU, RAM and swap metrics, the mean of all containers is
  used
- **Cooldown (scale-out)**: after a scale-out event, the Autoscaler does not
  scale the application out again for at least one minute
- **Cooldown (scale-in)**: after a scale-in event, the cooldown period is three
  minutes
- **Step**: by default, the Autoscaler adds only one container per decision
  round, ensuring a progressive and controlled adjustment. When the metric is
  RPM per minute, the Autoscaler is able to add more than one container per
  decision round when required, allowing to scale much faster. The maximum
  number of containers limit is still honoured in such a case.

These rules are designed to prevent the application from scaling wildly. They
make autoscaling effective at handling moderately increasing or decreasing
metrics, but less effective at managing sudden, massive spikes. For such cases,
and considering they are predictable, we usually adivse to manually scale the
application to an appropriate container formation.


## Available Metrics

The Autoscaler can depend on 6 different metrics:

| Metric                                                                   | Kind        |
| ------------------------------------------------------------------------ | ----------- |
| [Requests Per Minute (RPM) per container](rpm-per-container-recommended) | `router`    |
| [Response Time](#response-time)                                          | `router`    |
| [Number of 5xx errors](#5xx-errors)                                      | `router`    |
| [CPU consumption](#cpu-consumption)                                      | `technical` |
| [RAM consumption](#ram-consumption)                                      | `technical` |
| [Swap consumption](#swap-consumption)                                    | `technical` |

We provide a recommended value for each metric that you can use as the target.
For router metrics, these values are computed based on the median of your
application's usage over the last 24 hours. This means they are solely based on
historical data and do not include any future predictions.

### RPM per container (recommended)

Requests Per Minute (RPM) per container is calculated as the total number of
requests received by your application divided by the number of running `web`
containers.

#### Usage

For applications with fluctuating traffic, this metric helps maintain a stable
user experience by dynamically adding or removing containers to meet demand
without overprovisioning.

#### Recommended Target

The target for RPM per container should be determined by performing small-scale
load tests on your application. This helps understand how containers respond
under different levels of traffic, ensuring the Autoscaler can scale
effectively when needed.

### Response Time

Response time measures the latency of your application in processing requests.
The Autoscaler focuses on typical application performance by evaluating the
[95th percentile](https://en.wikipedia.org/wiki/Burstable_billing%2395th_percentile)
of response times. This ensures that scaling decisions are not influenced by
outlier spikes.

#### Usage

This metric is particularly relevant for applications where user satisfaction
is tied to responsiveness. Monitoring response time ensures that the
application scales to meet performance expectations.

#### Recommended Target

A good response time target depends on the criticality of your application's
speed.

Note that this metric might not always point to container saturation, it can
also reflect external factors such as a database performance issue, a slow
access to external online resources, or application-level bottlenecks.

### 5xx Errors

This metric monitors server-side errors,, such as 500 Internal Server Errors,
which indicate issues with your application or backend. The Autoscaler
evaluates the frequency of 5xx errors per minute to determine whether scaling
adjustments are needed.

#### Usage

This metric is particularly valuable for maintaining the reliability of your
application under stress. For example, if the number of errors increases due to
insufficient resources during peak traffic, scaling-out can stabilize the
system. However, persistent errors may indicate deeper issues, such as bugs,
database bottlenecks, or misconfigured dependencies, which should be addressed
directly.

#### Recommended Target

The target threshold for 5xx errors per minute should be defined based on your
application's behavior and tolerance for errors. Applications with strict
reliability requirements typically require a low threshold, while others may
tolerate occasional errors during peak loads.

### CPU Consumption

CPU consumption measures the average CPU usage across all containers. It
reflects how computationally intensive your application workload is.

#### Usage

This metric is commonly used for compute-intensive applications. When CPU
consumption frequently exceeds the target, the Autoscaler adds containers to
distribute the load.

However, if high CPU usage persists despite autoscaling, it may indicate that
your application requires more powerful containers to run properly. In such
cases, switching for a larger plan (vertical scaling) can provide more CPU
priority per container, thus enhancing the ability of your application to deal
with resource-intensive scenarios.

#### Recommended target

The recommended target for CPU consumption is 90% of the total CPU capacity,
ensuring your application uses resources efficiently without reaching
saturation.

### RAM Consumption

RAM consumption monitors the memory usage across all containers. Applications
with high memory needs, such as those handling large datasets or caching, can
benefit from autoscaling based on this metric.

#### Usage

This metric is particularly relevant for memory-bound applications. If your
application frequently exhausts its RAM allocation, autoscaling will help
distribute the workload to additional containers.

#### Recommended target

A target of 90% RAM usage is usually recommended, allowing a safety buffer to
prevent out-of-memory errors and ensure smooth operations.

### Swap Consumption

Swap consumption tracks the use of disk-based swap memory, which occurs when an
application exceeds its allocated RAM. While swap provides additional capacity,
excessive usage can significantly degrade performance.

#### Usage

Monitoring swap consumption helps prevent performance degradation. When swap
usage exceeds the target, the Autoscaler adds containers to reduce the load on
existing instances.

#### Recommended target

The recommended target for swap consumption is 10%. This ensures that your
application uses RAM efficiently without relying heavily on slower disk-based
swap.


## Limitations

- The minimum number of containers **must** be 2 to guarantee a minimal
  tolerance to fault. Allowing to scale-in to fewer than 2 containers would
  break the application high availability and create a risk of disruption in
  case of a failure. This would moreover go against our 99.96% Service Level
  Agreement.
- Router metrics are only available for `web` containers, while technical
  metrics are available for all types of containers.

## Costs

Although the Scalingo Autoscaler itself is free, the additional containers
started during a scale-out operation are billed like any other container (on
the other hand, scaling-in allows to save costs).

Consequently, billing depends on the type of container you chose for your
application (M is the default container size), on the maximum number of
containers set in the Autoscaler configuration and on your application
workload.


## Enabling the Autoscaler

### Using the Dashboard
The Autoscaler is not enabled by default. It's automatically enabled once
configured.

### Using the Command Line

### Using the Terraform Provider


## Disabling the Autoscaler

### Using the Dashboard

### Using the Command Line

### Using the Terraform Provider


## Configuring the Autoscaler

### Using the Dashboard

1. From your web browser, open your application dashboard
2. Click on the **Resources** tab
3. Locate the **Containers** block
4. In this block, locate the **Scale** button next to the process type for
   which you want to setup the Autoscaler
5. Click the down arrow next to the **Scale** button
6. From the dropdown menu, select **Setup autoscaler**
7. The following popup window appears:
{% assign img_url = 'https://cdn.scalingo.com/documentation/screenshot_dashboard_autoscalers.png' %}
{% include mdl_img.html %}
{:start="8"}
8. In the popup window:
   1. Pick the minimum number of containers for this process type
      (minimum is 2)
   2. Pick the maximum number of containers for this process type
   3. Chose the metric to watch
   4. Chose a value above which the Autoscaler considers scaling-out
   5. Validate by clicking the **Confirm** button
   6. The Autoscaler is configured and enabled

### Using the Command Line

1. Make sure you have correctly [setup the Scalingo command line tool]({% post_url platform/cli/2000-01-01-start %})
2. From the command line, run the following command to setup the Autoscaler:
   ```bash
   scalingo --app my-app autoscalers-add --container-type <process_type> \
       --metric <metric> --target <target> \
       --minimum-containers <min> --maximum-containers <max>
   ```
   With:
   - `process_type`: name of the process type to scale (e.g. `web`,
     `clock`, `scheduler`, ...)
   - `metric`: name of the metric to watch. Must be one of:
     - `rpm_per_container`
     - `p95_response_time`
     - `5XX`
     - `cpu`
     - `memory`
     - `swap`
   - `target`: 
   - `min`: minimum number of containers
   - `max`: maximum number of containers

### Using the Terraform Provider


## Monitoring the Autoscaler

The following event is available to monitor the Autoscaler executions:

| Event        | Description                                                          |
| ------------ | -------------------------------------------------------------------- |
| `app_scaled` | An autoscaling operation (scale-in and scale-out) has been triggered |

To learn more about events and notifications, please visit the page dedicated
to [app notifications]({% post_url platform/app/2000-01-01-notification %}).


## Understanding Scaling

In the context of Platform as a Service context such as Scalingo, ***scaling***
designates the process of adjusting the application's capacity to handle
varying workloads. We usually distinguish two different approaches:
[***vertical*** scaling](#understanding-vertical-scaling) and
[***horizontal*** scaling](#understanding-horizontal-scaling).

### Understanding Vertical Scaling

Vertical scaling (also known as *scaling up*) involves increasing the capacity
of a single resource, such as adding more CPU, memory, or storage to an
existing server or container.

When using Scalingo, vertical scaling is accomplished by changing the plan you
are using (e.g., switching your app container from a L instance to an XL one,
or changing your database addon's plan from a Starter 512M to a Starter 1G).

Vertical scaling is generally favored when dealing with legacy applications
that aren't designed for distributed workloads, or for monolithic applications
with predictable growth and resource needs.

### Understanding Horizontal Scaling

Horizontal scaling (also known as *scaling out*) involves adding more instances
of a resource, such as application containers, to distribute the workload. This
means deploying additional application instances that can each process
requests on their side.

When using Scalingo, horizontal scaling is accomplished by adjusting the number
of containers for your application. The platform [**automatically** routes the
traffic]({% post_url platform/internals/2000-01-01-routing %}#requests-scheduling)
to the available instances. This process, called *load-balancing*, allows to
distribute the load across multiple containers.

Horizontal scaling has multiple advantages:
- it adds fault tolerance and resilience to your application, as the failure of
  one instance does not affect others.
- it can scale almost infinitely, allowing your application to grow fast.
- it can save costs, as the number of running containers can be automatically
  adjusted (up and down) depending on your current application needs.

For all these reasons, horizontal scaling is generally better suited for
applications with distributed architectures that require high availability, and
the ability to adapt to unpredictable or fluctuating workloads. It's often the
best approach in PaaS environments such as Scalingo.

Here is a quick comparison table, in the context of a Platform as a Service:

| Feature         | Vertical Scaling                        | Horizontal Scaling                |
| --------------- | --------------------------------------- | --------------------------------- |
| **Approach**    | Enhancing individual instance capacity  | Adding more instances             |
| **Cost**        | Can become expensive at higher limits   | Often more cost-efficient         |
| **Resilience**  | Low (single point of failure)           | High (distributed resources)      |
| **Flexibility** | Limited by physical/virtual constraints | High                              |


### Understanding Scalingo Autoscaler

Scalingo's autoscaler adjusts the number of containers of your application (horizontal scaling) according to the performance metric defined as the source, while remaining within the high and low limits set during its configuration.

An autoscaler can be added to an application by going to the "Containers" tab
of your app:


The *Minimum Containers* value cannot be under 2. The reason is that the
autoscaler should not impact the availability of the application, and scaling
an application to less than 2 containers might impact the availability. Indeed,
our terms of service state that when an application is scaled to 1 container,
the SLA Scalingo provides is 98%. It is 99.9% if the application is scaled to 2
containers. We don't want the autoscaler to have an impact on the contractual
availability.

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
(e.g. RPM per container, response time, CPU consumption...).

When creating a new autoscaler, a target is provided: our algorithm tries to
keep the metric as close to the target as possible by scaling up or down the
application, up or down, by one container at a time.

A few details to keep in mind :

* the autoscaling is based on the "mean per minute" of the target metric, and requires
two consecutive means to be over the target value before being triggered;
* for the metrics where it makes sense (eg. CPU, RAM, swap), the mean of all containers
is used;
* after a scale up event, the autoscaler will **not** scale the application up again before at
least **one** minute;
* after a scale down, the cooldown is of **three** minutes;

Those rules are here to avoid scaling the application frantically. This makes the autoscaling
good at handling "reasonably" increasing/decreasing metrics, but not when it comes to dealing
with huge, sudden spikes.

If you know such events can happen, you should manually scale up the application to a suitable
container formation.

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
