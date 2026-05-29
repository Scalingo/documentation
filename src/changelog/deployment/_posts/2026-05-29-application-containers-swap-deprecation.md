---
modified_at: 2026-05-29 00:00:00
title: 'Application containers: swap deprecation plan'
---

Scalingo is progressively phasing out swap memory for application containers.

The rollout will be progressive:

- **June 1, 2026**: new customers will use the no-swap behavior by default.
- **September 1, 2026**: new applications created by existing customers will use
  the no-swap behavior by default.
- **January 1, 2027**: all application containers will use the no-swap behavior.

Existing applications keep their current behavior until they are migrated.

The documentation will be updated progressively to reflect this change.
