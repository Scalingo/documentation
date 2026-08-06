---
title: Manage Node.js Web Concurrency
nav: Web Concurrency
modified_at: 2026-08-06 00:00:00
tags: nodejs scaling concurrency
index: 6
---

Node.js concurrency can be increased in two different places:

- **Across containers:** run more Scalingo `web` containers. The router distributes requests between them.
- **Inside a container:** run several Node.js worker processes or threads in one container.

Start with one Node.js process per container unless measurements show that additional in-container workers improve throughput without causing memory pressure.

{% note %}
`scalingo-22`, `scalingo-24`, and `scalingo-26` identify Ubuntu base images. They do not identify the container size or available memory. Memory and CPU capacity come from the selected container type. Record the active stack when benchmarking because changes in Node.js, native libraries, or the operating-system image can affect measured performance.
{% endnote %}

## Horizontal scaling across containers

Horizontal scaling adds independent application instances. It improves capacity and resilience when the application is stateless or stores shared state in external services.

View the current formation:

```bash
scalingo --app my-app scale
```

Run three `web` containers using the `M` size:

```bash
scalingo --app my-app scale web:3:M
```

The platform routes HTTP traffic to the available `web` containers. Sessions, uploaded files, queues, and locks must therefore not depend on the local filesystem or memory of a single container.

See [Scaling Your Application]({% post_url platform/app/scaling/2000-01-01-scaling %}) for vertical scaling, horizontal scaling, limits, and autoscaling.

## Concurrency inside one container

A single Node.js process can handle many concurrent I/O-bound requests through the event loop. It does not automatically make CPU-bound JavaScript run in parallel.

Use several workers only when:

- the container has CPU capacity that one process cannot use effectively;
- the application or process manager has a tested worker model;
- memory remains below the container limit under peak load;
- graceful shutdown and health behavior are verified for every worker.

Common approaches include:

- the Node.js `cluster` module;
- `worker_threads` for specific CPU-intensive tasks;
- a process manager configured to start a fixed number of workers;
- separate Scalingo process types for background or CPU-heavy work.

Avoid using a development server as a production worker manager.

## Use `WEB_CONCURRENCY` explicitly

`WEB_CONCURRENCY` is a convention, not a Node.js built-in setting. It has an effect only when the application or process manager reads it.

Example using `cluster`:

```js
const cluster = require("node:cluster");
const os = require("node:os");

const requestedWorkers = Number.parseInt(
  process.env.WEB_CONCURRENCY ?? "1",
  10,
);
const workers = Number.isFinite(requestedWorkers)
  ? Math.max(1, requestedWorkers)
  : 1;

if (cluster.isPrimary) {
  console.log(`Starting ${workers} workers on ${os.availableParallelism()} CPUs`);

  for (let index = 0; index < workers; index += 1) {
    cluster.fork();
  }

  cluster.on("exit", () => cluster.fork());
} else {
  require("./server");
}
```

Configure the value explicitly:

```bash
scalingo --app my-app env-set WEB_CONCURRENCY=2
```

{% warning %}
Do not publish or rely on an automatically calculated `WEB_CONCURRENCY` value until Scalingo Engineering confirms which active component sets it, how container memory is detected, and which tests guarantee the behavior.
{% endwarning %}

## Estimate memory per worker

Every Node.js process has its own JavaScript heap, native allocations, buffers, module state, and connection pools. Two workers can use substantially more than twice the idle memory of one process after traffic and caches are loaded.

Measure memory with one worker under representative load, then leave headroom for:

- native modules and shared libraries;
- HTTP and database buffers;
- package-manager or shell wrapper processes;
- temporary spikes during garbage collection;
- operating-system overhead.

The buildpack supplies a default `NODE_OPTIONS` old-space value when the variable is absent. If you set your own limit, remember that it applies to each Node.js process:

```bash
scalingo --app my-app env-set \
  WEB_CONCURRENCY=2 \
  NODE_OPTIONS="--max-old-space-size=768"
```

This example allows up to roughly 768 MB of V8 old space per process; it does not cap total process memory at 768 MB.

## Separate web and background workloads

Long-running jobs should not block HTTP request handling. Define separate process types:

```text
web: node server.js
worker: node worker.js
```

Scale them independently:

```bash
scalingo --app my-app scale web:2:M worker:1:L
```

This makes it possible to give web and worker processes different container sizes and scaling policies.

## Choose a scaling strategy

| Symptom | First action |
| --- | --- |
| One container is near its memory limit even at low traffic | Use a larger container or reduce per-process memory |
| CPU rises with request volume but each container remains healthy | Add web containers |
| One Node.js process cannot use available CPU and memory is comfortable | Test a small fixed worker count |
| Long jobs cause request latency | Move the jobs to a worker process type |
| Traffic varies predictably or rapidly | Evaluate the Scalingo Autoscaler |
| One request or job needs more memory than the container provides | Scale vertically; more containers will not repair a single oversized workload |

## Validate changes

Change one variable at a time and observe:

- request rate per container;
- response latency;
- CPU saturation;
- memory high-water mark;
- restart and out-of-memory events;
- database connection count;
- event-loop delay;
- graceful shutdown during deploys and scaling events.

A safe rollout is:

1. Record baseline metrics.
2. Change container count or worker count, not both.
3. Apply representative load.
4. Compare throughput, latency, and memory.
5. Roll back when the change reduces stability or cost efficiency.

## Related documentation

- [Scaling Your Application]({% post_url platform/app/scaling/2000-01-01-scaling %})
- [Optimizing Application Workloads]({% post_url platform/app/scaling/2000-01-01-optimizing-application-workloads %})
- [Procfile]({% post_url platform/app/2000-01-01-procfile %})
- [Customize Node.js Builds]({% post_url languages/nodejs/2000-01-01-customizing %})
- [Troubleshoot Node.js Deployments]({% post_url languages/nodejs/2000-01-01-troubleshooting %})
