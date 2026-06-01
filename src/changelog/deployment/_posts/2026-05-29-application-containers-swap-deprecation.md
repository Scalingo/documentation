---
modified_at: 2026-06-01 00:00:00
title: 'Swap memory will be progressively disabled from application containers'
---

Scalingo is progressively updating how memory limits are enforced for
application containers.

Application containers will no longer be able to rely on swap memory. If an 
application exceeds its available memory, its container may be stopped with 
an out-of-memory error and restarted according to the usual restart policy.

The rollout will happen progressively:

- **1 June 2026**: swap will no longer be enabled for new Scalingo customers
- **1 September 2026**: swap will no longer be enabled for new applications 
  created by existing customers
- **1 January 2027**: swap will be disabled for all application containers

**In most cases, no immediate action is required.**

We recommend reviewing your applications' memory usage during the transition 
period and configuring memory alerts if needed.

The documentation will be updated progressively to reflect this change.
