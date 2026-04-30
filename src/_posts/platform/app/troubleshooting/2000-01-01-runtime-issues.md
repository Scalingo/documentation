---
title: Runtime Issues
modified_at: 2026-04-30 00:00:00
tags: app runtime crash recovery troubleshooting
index: 3
---

**Runtime Errors** are errors that happen during the execution of the process.
Per definition, they can only occur when your container has reached its
*running* state (which means your deployment is considered successful by the
platform).

Deployment flow: `[x]` completed, `[!]` covered here, `[ ]` covered later.

```text
[x] Source fetched
[x] Technology detected
[x] Application image built
[x] Container started
[x] Postdeploy hook run
[!] Application running
```

## Understanding Runtime Errors

Unfortunately, and even if it has reached this state, unexpected errors can
still lead your application to crash.

The most common causes are:

- Incompatible dependencies
- Segfault of a library/runtime
- Configuration issues
- Bugs in your application code
- Uncaught exception in your code (especially with non-compiled languages)
- Insufficient resources
- Temporary error/unavailability of an external resource

A Runtime Error can have several consequences, depending on the severity of the
error and the impact it has on your application:

- Reduced performance: slow response time typically results in poor user
  experience.
- Downtime: the unavailability of your application, even if temporary, can have
  a significant impact on business operations.
- Data loss, or Corrupt Data: losing strategic data can have serious
  consequences for your organization or for your users/customers, especially in
  an [HDS context]({% post_url compliance/2000-01-01-hds %}).
- Security Risks: runtime errors can sometimes introduce security risks,
  especially if your application is too verbose. This can lead to sensitive
  data leak and further exploitation.

## Mitigating and Preventing Runtime Errors

The very first step to take to mitigate the consequences of a Runtime Error is
to ensure that you have regular, tested backups (for databases, this feature is
included in all our *business* plans) and to setup some
[redundancy]({% post_url platform/app/scaling/2000-01-01-scaling %}#redundancy).

Additionally, we generally advise to have a disaster recovery plan in place.
This plan should ideally outline the actions to be taken in the event of such a
failure. It may include procedures and step by step guides to identify and
resolve the encountered error.

We also recommend to regularly check the application's health. This can be
done by checking the metrics, analyzing the logs, or setting up automated
anomaly detection. The goal is to identify and fix potential issues before they
occur.

Finally, we strongly encourage developers to test their code, to follow the
best practices and to conduct Q/A testings in a dedicated environment before
migrating to production.

## Recovering from a Runtime Error

When a Runtime Error occurs and leads to an application crash, the platform
automatically takes some remedial measures to try to recover from it. The very
first action consists in logging the crash event in your dashboard. Once done,
the platform uses its restart policy, described hereafter:

The platform maintains a crash counter for each running container. This crash
counter is set to zero by default.

When a container crashes for the first time (when its crash counter equals
zero), the platform sets the crash counter to one and then tries to restart the
container. This is done as soon as the failure is detected.

After a successful restart, the container enters a *warmup* period which always
lasts 10 minutes. From here, we distinguish two main cases:

1. The container successfully goes past the *warmup* period. In this case, the
   platform considers that the restart operation fixed the issue and thus
   resets the container's crash counter to zero.

2. The container crashes again during the *warmup* period. In this case, the
   platform immediately increments the crash counter by one.
   - If the crash counter value is less than 13, then the platform waits some
     time before restarting the container again. The duration of the waiting
     period is given by the following formula:
     `duration (minutes) = (crash counter value - 2) x 5`
   - If the crash counter value equals 2, 5 or 12, the platform sends a warning
     e-mail to the application's collaborators.
   - If the crash counter value reaches 13, which means the container keeps
     crashing after 12 delayed restarts, the platform gives up. The container
     is crashed and won't be restarted anymore, which means your application
     may now be totally unavailable.

### Fixing Runtime Errors

Besides the measures taken by the platform, we strongly advise you to carefully
investigate the logs of your crashing application as soon as possible. Once
your fix is ready, push your updated code to Scalingo to trigger a new
deployment, hopefully resolving the issue.

## Getting Notified When a Crash Occurs

By default, the platform only notifies the application's collaborator(s) when
a recurrent crash occurs (i.e. when an early Runtime Error keeps occurring, or
when a Timeout Error occurs).

You can modify this behavior by tweaking your
[Notifier's configuration]({% post_url platform/app/2000-01-01-notification %}).
The `app_crashed`, `app_crashed_repeated` and the `app_deploy` events can be
particularly worth considering.
