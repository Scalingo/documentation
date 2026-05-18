---
title: Choosing a Container Size
nav: Choosing a Container Size
modified_at: 2026-05-18 00:00:00
tags: app scaling containers memory metrics
index: 1
---

Choosing the right container size is a balance between safety, performance, and
cost. Memory is often the resource that most directly constrains this choice
because each running container must stay below its own memory quota. A safe
initial size gives your application enough memory headroom while you collect
real metrics and validate the workload.

For simple applications, the default `M` container size is often a reasonable
starting point. Choose a larger size from the beginning when you already know
that your application has higher memory needs, for example because it uses a
memory-intensive runtime, high concurrency, large in-memory datasets, caches,
background jobs processing large payloads, or unknown production traffic.

See the [container sizes][container-sizes] page for the available sizes, memory
limits, and PID limits.


## Start Safe, Then Adjust

When you are unsure about the right size, start with a size that gives your
application enough headroom. After deployment, use [metrics][metrics],
[alerts][alerts], and realistic load testing to adjust the size.

Avoid choosing a smaller size only because the application starts successfully.
An application can boot with low memory usage and still consume much more
memory under real traffic, scheduled jobs, large requests, or specific user
flows.

Before downsizing, validate that the application keeps enough memory headroom
below the limit over time.


## Validate With Metrics and Load Testing

Before changing the container size, inspect the application charts in the
[Metrics tab][metrics]. Compare memory usage with the memory quota of the
selected container size, and also review CPU usage and application-level
signals.

Pay attention to:

- CPU usage.
- RAM and swap usage.
- Whether memory usage returns to a stable baseline after traffic peaks.
- Response time.
- 5xx errors.
- Restart events.

If production metrics are not enough to validate a size, test the application
with realistic load and non-sensitive data.

{% note %}
Before running intensive load tests against an application hosted on Scalingo,
read our [external testing procedures][external-testing].
{% endnote %}


## Match Capacity to Traffic

Once you have chosen the target size for each process type, use
[Scaling Your Application][scaling] to configure the expected capacity for your
traffic and workload.

If the application is critical or you are unsure about the safest sizing
strategy, contact Scalingo support.


## Monitor Resource Usage

Configure [alerts][alerts] for critical metrics, and keep
[notifiers][notifiers] configured so the right people receive notifications
before resource usage becomes critical.

If the application consumes all its available memory, it can be terminated by
the system. See the [Runtime Issues][oom-diagnosis] page for Out of Memory
crash diagnosis and recovery guidance.


[alerts]: {% post_url platform/app/2000-01-01-alerts %}
[container-sizes]: {% post_url platform/internals/2000-01-01-container-sizes %}
[external-testing]: {% post_url security/procedures/2000-01-01-external-testing %}#can-i-run-a-load-test-on-my-application-that-is-running-on-scalingo
[metrics]: {% post_url platform/app/2000-01-01-metrics %}
[notifiers]: {% post_url platform/app/2000-01-01-notifiers %}
[oom-diagnosis]: {% post_url platform/app/troubleshooting/2000-01-01-runtime-issues %}#out-of-memory-crashes
[scaling]: {% post_url platform/app/scaling/2000-01-01-scaling %}
