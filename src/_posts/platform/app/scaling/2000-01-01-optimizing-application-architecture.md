---
title: Optimizing Application Architecture
nav: Optimized Architecture
modified_at: 2026-05-18 00:00:00
tags: app scaling architecture containers memory metrics performance concurrency
index: 5
---

An optimized application architecture makes efficient use of the resources
allocated to each container while keeping the application easy to operate. On
Scalingo, this usually means separating workloads into [process types][procfile],
keeping web requests short, tuning concurrency carefully, and using metrics to
decide when to optimize code, split work, or scale the application.

This page focuses on how to structure the application workload. To choose a
container size, see [Choosing a Container Size][choosing-container-size]. To
change the number or size of running containers, see
[Scaling Your Application][scaling].


## Design Around Process Types

Use [process types][procfile] to separate workloads that do not have the same
operational profile. A `web` process should handle HTTP requests and return
responses quickly, using [background jobs][long-process] for long work.

Run background workers, importers, exporters, and other resource-intensive jobs
in dedicated process types so each workload can use its own container count and
size, making scaling and debugging easier.

Typical process types include:

- `web` for HTTP traffic;
- `worker` for background jobs;
- `clock` or `scheduler` custom process types for long-running,
  high-frequency, or precise recurring jobs;
- dedicated workers for heavy jobs such as PDF generation, image processing,
  imports, exports, or batch tasks.

For most recurring jobs, consider the
[Scalingo Scheduler][scalingo-scheduler] with a `cron.json` file as the
built-in option for running scheduled tasks without a continuously running
process.


## Tune Concurrency Carefully

Concurrency lets a process handle more work in parallel, but each additional
thread, worker, or child process usually consumes more memory and may increase
database or external service pressure.

Tune concurrency separately for each process type:

- increase web concurrency only if response time and resource usage stay
  healthy under realistic traffic;
- reduce worker concurrency if occasional jobs create memory pressure;
- keep enough database connections for the configured concurrency;
- use separate process types for jobs that have different resource profiles,
  such as CPU-heavy and memory-heavy jobs.

Some runtimes expose Scalingo-specific or buildpack-provided defaults and
environment variables. See the language pages for details:
[Ruby][ruby], [Python][python], [PHP][php], [Java][java], [Node.js][nodejs],
and [Go][go].


## Handle Memory-Intensive Workloads

Memory pressure is often caused by specific workloads rather than by every
request. Check whether the application consumes more memory regularly, or only
during occasional tasks such as:

- background jobs;
- PDF generation;
- image or video processing;
- large imports or exports;
- report generation;
- scheduled batch tasks;
- large in-memory caches or datasets.

Depending on what you observe, prefer the smallest change that addresses the
actual cause:

- optimize the code path that allocates too much memory;
- tune runtime-specific memory settings;
- split heavy jobs into a dedicated process type;
- reduce worker or job concurrency;
- split large jobs into smaller chunks;
- isolate workloads that do not have the same resource profile.

If each container still needs more memory after these changes, continue with
[Choosing a Container Size][choosing-container-size].


## Size and Scale Your App

Once your application is optimized for its workload:

- [choose the right size][choosing-container-size] for each process type;
- [scale the application][scaling] to match capacity to traffic;
- read [Application Metrics][metrics] and configure [alerts][alerts] to monitor
  the application after changes.

If the application reaches its memory limit and crashes, see [Runtime
Issues][oom-diagnosis] for diagnosis and recovery guidance.


[alerts]: {% post_url platform/app/2000-01-01-alerts %}
[choosing-container-size]: {% post_url platform/app/scaling/2000-01-01-choosing-container-size %}
[go]: {% post_url languages/go/2000-01-01-start %}
[java]: {% post_url languages/java/2000-01-01-start %}
[long-process]: {% post_url platform/app/2000-01-01-long-process %}
[metrics]: {% post_url platform/app/2000-01-01-metrics %}
[nodejs]: {% post_url languages/nodejs/2000-01-01-start %}
[oom-diagnosis]: {% post_url platform/app/troubleshooting/2000-01-01-runtime-issues %}#out-of-memory-crashes
[php]: {% post_url languages/php/2000-01-01-start %}
[procfile]: {% post_url platform/app/2000-01-01-procfile %}
[python]: {% post_url languages/python/2000-01-01-start %}
[ruby]: {% post_url languages/ruby/2000-01-01-start %}
[scaling]: {% post_url platform/app/scaling/2000-01-01-scaling %}
[scalingo-scheduler]: {% post_url platform/app/task-scheduling/2000-01-01-scalingo-scheduler %}
