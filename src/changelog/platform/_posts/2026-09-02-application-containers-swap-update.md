---
modified_at: 2026-09-02 00:00:00
title: 'Swap memory changes for application containers'
---

Since **1 September 2026**, newly created applications no longer use swap
memory.

For existing applications that retain access to swap memory until the end of
2026, the swap limit is reduced to 25% of the container memory limit after
their next restart.

If an application exceeds its available memory without swap available, its
container may be stopped with an out-of-memory error and restarted according to
the usual restart policy.

For more details, refer to the [blog post](https://scalingo.com/blog/clearer-memory-limits-for-application-containers).
