---
title: Container Sizes
modified_at: 2026-05-05 00:00:00
tags: containers sizes
index: 2
---

## Comparative Table

<div class="overflow-horizontal-content" markdown="1">
| Name                       | Memory  | CPU Priority | PID Limit[^pid-limit] |
| -------------------------- | ------- | ------------ | --------- |
| S - Small                  | 256 MB  | Low          | 128       |
| M - Medium (Default)       | 512 MB  | Standard     | 256       |
| L - Large                  | 1 GB    | Standard     | 512       |
| XL - eXtra Large           | 2 GB    | High         | 1024      |
| 2XL - eXtra eXtra Large    | 4 GB    | High         | 2048      |
{: .table }
</div>

Prices are available on the [Scalingo pricing page](https://scalingo.com/pricing).
Bigger container sizes are available upon request on the support. 

{% note %}
Limits apply when using Scalingo under the free trial. For more information,
see [what you can do under the free trial][free-trial-limits].
{% endnote %}

## Container Limits

Containers have various limits depending on their size. Here is a comprehensive list:

- **Memory**: see the comparative table above.
- **Swap**: twice the amount of RAM.
- **CPU**: all containers have access to all CPU cores. But higher priority
  means twice as much priority compared to standard priority. For example,
  consider three containers, one has a high priority and two others have a
  standard priority. When processes in all three containers attempt to use
  100% of CPU, the first container would receive 50% of the total CPU time and
  the two others would receive 25%.
- **PID limit**: see the comparative table above.
- **Open file limit** (`nofile`): 1,048,576. This is the maximum number of files an application can open.

[^pid-limit]: Each new process requires a PID.

[free-trial-limits]: {% post_url platform/getting-started/2000-01-01-free-trial %}#what-can-i-do-under-the-free-trial
