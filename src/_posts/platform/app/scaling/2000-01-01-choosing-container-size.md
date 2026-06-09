---
title: Choosing a Container Size
nav: Choosing a Container Size
modified_at: 2026-06-09 00:00:00
tags: app scaling containers memory metrics
index: 1
---

Choosing the right container size is an important step when deploying an
application on Scalingo. Container size determines the amount of CPU and memory
available to your application, which directly affects its performance,
stability, and cost. Consequently, evaluating your application's resource
requirements, and monitoring its consumption are crucial to match your workload,
whether you're running a small development environment or a production-critical
service.


## Picking an Initial Size

For simple applications, the default `M` container size is often a reasonable
starting point. Choose a larger size from the beginning when you already know
that your application has higher memory needs, for example because it uses a
memory-intensive runtime, high concurrency, large in-memory datasets, caches,
background jobs processing large payloads, or unknown production traffic.

When you are unsure about the right size, start with a size that gives your
application enough headroom to handle traffic peaks, expensive requests, and
occasional jobs.

Avoid choosing a smaller size only because the application starts successfully.
An application can boot with low memory usage and still consume much more
memory under real traffic, scheduled jobs, large requests, or specific user
flows.

See the [container sizes][container-sizes] page for the available sizes, memory
limits, and PID limits.

## Adjusting the Container Formation

Once you have chosen an initial size for each [process type][procfile],
regularly review application charts in the [Metrics tab][metrics].

Resource utilization trends provide valuable insight into whether the current
container size is appropriate or if additional resources are required to
maintain performance and stability:

- **CPU usage**: Sustained high CPU utilization may indicate that the application
  is CPU-bound and would benefit from additional CPU resources or more container
  instances ([horizontal scaling][h-scaling]). Conversely, consistently low CPU
  usage may suggest that the application is overprovisioned and could be
  downsized to reduce costs.
- **Memory and swap**: Monitor memory consumption to ensure the application has
  sufficient headroom during normal operation and traffic peaks. Frequent use of
  swap space is a strong indicator of memory pressure and can significantly
  degrade performance, often signaling the need for a [larger container
  size][v-scaling].
- **Application-level signals**: Increasing response times or a growing number of
  server-side errors can indicate that the application is approaching its
  capacity limits, even when CPU and memory utilization appear healthy, and may
  warrant [scaling out][h-scaling] to maintain service quality and fluent user
  experience.
- **Restart events**: Unexpected or recurring container restarts can point to
  resource exhaustion, application crashes, or other operational issues.
  Investigating restart patterns can help determine whether scaling up resources
  is necessary to improve application stability.

If production metrics are not enough to validate a size, test the application
with realistic load and non-sensitive data.

If the application is critical or you are unsure about the safest sizing
strategy, contact Scalingo support.

{% note %}
- While scaling out and scaling up are generally safe options, we usually advise
  to take extra care when scaling in or down. Please ensure that the application
  keeps enough memory headroom below the limit over time to avoid any
  unavailability.
- Before running intensive load tests against an application hosted on Scalingo,
  read our [external testing procedures][external-testing].
{% endnote %}


## Monitoring

Configure [alerts][alerts] for critical metrics, and keep
[notifiers][notifiers] configured so the right people receive notifications
before resource usage becomes critical.

Monitor both functional and technical metrics. Functional metrics, such as
requests per minute per container, help you understand how much traffic each
container handles. Technical metrics, such as RAM and CPU usage, help you
monitor resource pressure before it affects the application.


[alerts]: {% post_url platform/app/2000-01-01-alerts %}
[container-sizes]: {% post_url platform/internals/2000-01-01-container-sizes %}
[external-testing]: {% post_url security/procedures/2000-01-01-external-testing %}#can-i-run-a-load-test-on-my-application-that-is-running-on-scalingo
[metrics]: {% post_url platform/app/2000-01-01-metrics %}
[notifiers]: {% post_url platform/app/2000-01-01-notifiers %}
[procfile]: {% post_url platform/app/2000-01-01-procfile %}
[scaling]: {% post_url platform/app/scaling/2000-01-01-scaling %}
[h-scaling]: {% post_url platform/app/scaling/2000-01-01-scaling %}#horizontal-scaling
[v-scaling]: {% post_url platform/app/scaling/2000-01-01-scaling %}#vertical-scaling
