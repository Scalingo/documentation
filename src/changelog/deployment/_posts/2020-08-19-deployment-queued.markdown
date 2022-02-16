---
modified_at: 2020-08-19 18:00:00
title: 'Concurrent deployments limited to 10 per app owner'
---

Starting from today, concurrent deployments are now limited to 10 per app owner.
If a user tries to launch a deployment on an app owned by someone having more
than 10 deployments running the deployment will be queued.

A queued deployment will be kept in the queue until another deployment finishes.
