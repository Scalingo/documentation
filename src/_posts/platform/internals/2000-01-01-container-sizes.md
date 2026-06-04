---
title: Container Sizes
modified_at: 2026-05-05 00:00:00
tags: containers sizes
index: 2
---

The following table provides a side-by-side comparison of resources and process
limits applied to each container size, allowing for a clear overview of the
capabilities and isolation characteristics associated with each profile.

| Size    | Memory (MB) | Swap (MB) | [CPU Priority](#cpu) | [PID](#pid) | [FD](#fd) |
| :-----: | ----------: | --------: | :------------------: | ----------: | :-------: |
| **S**   | 256         | 512       | Low                  | 128         | 1048576   |
| **M**   | 512         | 1024      | Standard             | 256         | 1048576   |
| **L**   | 1024        | 2048      | Standard             | 512         | 1048576   |
| **XL**  | 2048        | 4096      | High                 | 1024        | 1048576   |
| **2XL** | 4096        | 8192      | High                 | 2048        | 1048576   |

The default container size is **M**.

Prices are available on the [Scalingo pricing page](https://scalingo.com/pricing).

{% include application_swap_deprecation_note.md %}

{: #cpu}**CPU Priority**
: All containers can use all available CPU cores.

  - A *High* priority container receives twice the CPU share of a *Standard*
    priority container when CPU resources are contested.
  - Following the same logic, a *Low* priority container receives half the CPU
    share of a *Standard* priority container when CPU resources are contested.

  For example, if three containers are fully utilizing the CPU — one with High
  priority and two with Standard priority — the High priority container would
  receive 50% of the total CPU time, while each Standard priority container
  would receive 25%.

{: #pid}**PID**
: Maximum number of processes the container can spawn.

{: #fd}**FD** (`nofile`)
: Maximum number of file descriptors a process can open.


*[PID]: Process IDentifier
*[FD]: File Descriptors
