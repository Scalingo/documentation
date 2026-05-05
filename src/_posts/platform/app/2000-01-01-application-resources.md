---
title: Application Resources
nav: Resources
modified_at: 2026-05-05 00:00:00
tags: app resources cpu memory ram swap storage oom
index: 1
---

Application resources define the CPU, memory, swap, and storage available to
each container running your application.

## Container Sizing



For the full list of available container sizes and their limits, see
[Container Sizes][container-sizes].


## CPU

## Memory

### RAM

### Swap

### Out of Memory Crashes

When an application consumes all its allocated memory (RAM + swap), the system
applies a protection mechanism called the **OOM Killer** (Out of Memory Killer).

#### Sequence of events

1. The application progressively uses all available RAM
2. The system starts using swap space
3. When memory and swap reach 100% usage, the OOM Killer intervenes
4. The application is immediately terminated by the system

#### Observable consequences

* **Abrupt termination:** The application stops without a graceful shutdown process
* **Automatic restart:** The container restarts according to its configuration
* **Restart event:** A "Restart" event appears in the metrics timeline
* **Data loss:** All non-persisted data in memory is lost

#### Prevention and monitoring

To avoid this scenario:

* Regularly monitor memory charts in the [Metrics tab][metrics]
* Set up [alerts][alerts] before reaching memory limits
* Analyze usage spikes in correlation with deployment events
* Consider upgrading to a larger [container size][container-sizes] if needed

**Note:** The OOM Killer is a system protection mechanism. If your application regularly experiences OOM events, it typically indicates a need for code optimization or increased allocated resources.

## Storage

### Ephemeral Filesystem

## Monitoring Resource Usage

## Preventing Resource Exhaustion

[alerts]: {% post_url platform/app/2000-01-01-alerts %}
[container-sizes]: {% post_url platform/internals/2000-01-01-container-sizes %}
[metrics]: {% post_url platform/app/2000-01-01-metrics %}
