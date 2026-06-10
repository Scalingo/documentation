---
title: Optimizing Application Workloads
nav: Optimizing Workloads
modified_at: 2026-06-10 00:00:00
tags: app scaling workloads containers memory metrics performance concurrency
index: 5
---

When an application starts hitting resource limits, increasing the container
size is not always the only option. Sometimes, the issue comes from a specific
workload: a long request, a background job, a large import, or too much
concurrency in one process.

This page lists optimization options you can consider when you want to improve
how these workloads use container resources.

For container sizing, see [Choosing a Container Size][choosing-container-size].
To change the number or size of running containers, see
[Scaling Your Application][scaling].


## Design Around Process Types

Use [process types][procfile] to separate workloads that do not have the same
operational profile. A `web` process should handle HTTP requests and return
responses quickly, using [background jobs][long-process] for long work.

Run background workers, importers, exporters, and scheduled jobs in process
types that match their role. This makes each workload easier to scale, size,
and debug independently.

Typical process types include:

- `web` for HTTP traffic;
- `worker` for background jobs;
- `clock` or `scheduler` [custom process types][custom-clock-processes] for
  long-running, high-frequency, or precise recurring jobs;
- dedicated workers for imports, exports, batch tasks, or other specialized
  workloads.

For most recurring jobs, consider the
[Scalingo Scheduler][scalingo-scheduler] with a `cron.json` file as the
built-in option for running scheduled tasks without a continuously running
process.


## Consider Private Networks for Separate Applications

For larger applications, process types are not the only way to separate
responsibilities. When a workload is operated as a separate application,
[Private Networks][private-networks] let application containers communicate
privately and share internal services within the same project.

Private Networks are complementary to process types:

- use process types to separate workloads inside an application;
- use Private Networks when a workflow spans multiple applications within the
  same project.


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


## Isolate Resource-Intensive Workloads

Resource pressure is often caused by specific workloads rather than by every
request. Check whether the application consumes more CPU or memory regularly,
or only during occasional tasks such as:

- background jobs;
- PDF generation;
- image or video processing;
- large imports or exports;
- report generation;
- scheduled batch tasks;
- large in-memory caches or datasets.

Depending on what you observe, prefer the smallest change that addresses the
actual cause:

- optimize the code path that consumes too many resources;
- tune runtime-specific memory or concurrency settings;
- reduce worker or job concurrency;
- split large jobs into smaller chunks;
- move specialized jobs to their own process type when they do not share the
  same resource profile as the rest of the application.

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
[custom-clock-processes]: {% post_url platform/app/task-scheduling/2000-01-01-custom-clock-processes %}
[go]: {% post_url languages/go/2000-01-01-start %}
[java]: {% post_url languages/java/2000-01-01-start %}
[long-process]: {% post_url platform/app/2000-01-01-long-process %}
[metrics]: {% post_url platform/app/2000-01-01-metrics %}
[nodejs]: {% post_url languages/nodejs/2000-01-01-start %}
[oom-diagnosis]: {% post_url platform/app/troubleshooting/2000-01-01-runtime-issues %}#out-of-memory-crashes
[php]: {% post_url languages/php/2000-01-01-start %}
[private-networks]: {% post_url platform/networking/private/2000-01-01-overview %}
[procfile]: {% post_url platform/app/2000-01-01-procfile %}
[python]: {% post_url languages/python/2000-01-01-start %}
[ruby]: {% post_url languages/ruby/2000-01-01-start %}
[scaling]: {% post_url platform/app/scaling/2000-01-01-scaling %}
[scalingo-scheduler]: {% post_url platform/app/task-scheduling/2000-01-01-scalingo-scheduler %}
