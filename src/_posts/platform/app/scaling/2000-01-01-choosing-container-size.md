---
title: Choosing a Container Size
nav: Choosing a Container Size
modified_at: 2026-05-12 00:00:00
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

See the [container sizes][container-sizes] page for the available sizes and
their memory limits.


## Start Safe, Then Tune

When you are unsure about the right size, start with a size that is slightly
larger than your first estimate. After deployment, use metrics, alerts, and
load testing to adjust the size.

Avoid choosing a smaller size only because the application starts successfully.
An application can boot with low memory usage and still consume much more
memory under real traffic, scheduled jobs, large requests, or specific user
flows.

Before downsizing, validate that the application keeps enough memory headroom
below the limit over time.


## Read Memory Metrics Before Changing Size

Before changing the container size, inspect the memory charts in the
[Metrics tab][metrics]. Compare the application memory usage with the memory
quota of the selected container size.

Pay attention to:

- RAM and swap usage.
- Whether memory usage returns to a stable baseline after traffic peaks.
- Per-container details when the application runs several containers.
- Deploy, restart, scale, traffic, and background job events around memory
  spikes.

Memory usage that keeps increasing over time without returning to a stable
baseline can indicate a memory leak. In that case, investigate the application
before relying only on scaling.


## Validate With Load Testing

The most reliable way to validate a container size is to test the application
with realistic load. Use production-like traffic patterns, important endpoints,
background jobs, and non-sensitive data.

During the test, monitor:

- Memory and swap usage.
- CPU usage.
- Response time.
- 5xx errors.
- Restart events.
- Application and database bottlenecks.

If the application approaches its memory limit or starts swapping heavily,
either increase the container size, reduce memory usage, or tune the runtime
settings that control memory and concurrency.

{% note %}
Before running intensive load tests against an application hosted on Scalingo,
read our [external testing procedures][external-testing].
{% endnote %}


## Choose the Right Remediation

High memory usage does not always require the same response:

- Increase the container size when each container needs more memory to run
  safely.
- Add more containers when memory usage increases because traffic increases and
  the workload can be distributed.
- Tune runtime memory or concurrency settings when the runtime starts too many
  workers, uses too large a heap, or keeps too little memory headroom.
- Reduce application memory usage by reviewing caches, large in-memory data
  structures, payload processing, or background job behavior.
- Investigate a memory leak when memory usage keeps growing over time.

If the application is critical or you are unsure about the safest sizing
strategy, contact Scalingo support.


## Monitor Memory Risk

Configure [alerts][alerts] for RAM and swap usage, and keep
[notifiers][notifiers] configured so the right people receive notifications
before memory usage becomes critical.

If the application consumes all its available memory, it can be terminated by
the system. See the [Runtime Issues][oom-diagnosis] page for Out of Memory
crash diagnosis and recovery guidance.


## Runtime Tuning

Scaling changes the resources available to the application. Runtime tuning
changes how the application uses these resources. Depending on the language and
runtime, you may need to tune memory limits, heap size, workers, or concurrency.

See the language-specific documentation for the main runtime settings:

- [Go][go]
- [Java][java]
- [Node.js][nodejs]
- [PHP][php]
- [Python][python]
- [Ruby][ruby]


[alerts]: {% post_url platform/app/2000-01-01-alerts %}
[container-sizes]: {% post_url platform/internals/2000-01-01-container-sizes %}
[external-testing]: {% post_url security/procedures/2000-01-01-external-testing %}#can-i-run-a-load-test-on-my-application-that-is-running-on-scalingo
[metrics]: {% post_url platform/app/2000-01-01-metrics %}
[notifiers]: {% post_url platform/app/2000-01-01-notifiers %}
[oom-diagnosis]: {% post_url platform/app/troubleshooting/2000-01-01-runtime-issues %}#out-of-memory-crashes

[ruby]: {% post_url languages/ruby/2000-01-01-start %}#memory-management
[go]: {% post_url languages/go/2000-01-01-start %}#memory-management
[java]: {% post_url languages/java/2000-01-01-start %}#memory-management
[nodejs]: {% post_url languages/nodejs/2000-01-01-start %}#memory-management
[php]: {% post_url languages/php/2000-01-01-start %}#memory-management
[python]: {% post_url languages/python/2000-01-01-start %}#memory-management
