---
title: Container Management
modified_at: 2016-11-16 00:00:00
category: internals
tags: internals containers
---

## Zero-downtime operations

The platform is ensuring **zero downtime deployments**: when a new version of
your application is deployed, the system is waiting for the new version of the
container to be online and well, before stopping the old version.

This is the same principle when you're **restarting** one or several containers
of your application, new containers have to be available at first, then the
order to stop old containers is done.

With this feature, it let you achieve **rolling release/continuous delivery**
easily, there is no friction when a new version of your software is deployed,
your users won't even remark it.

## Starting new containers

When a new `web` container is started, its environment contain the `PORT`
environment variable. Your application has to listen on this port in order to
receive request. Once the application has been started, the container scheduler
will try to connect to your application on the port defined previously during
**60 seconds**. Once a TCP connection is accepted by your container, we consider
the container ready to get requests. Otherwise, the operation is aborted with a
[Boot Timeout Error]({% post_url deployment/2014-08-26-start-error %}):

* In the case of a deployment, it will be stopped with the **status
  'timeout-error'** and you'll have to fix why your application has not been
  listening in time on the corresponding port.

* In a restart operation, we'll retry to start the container 20 times with
  exponential backoff, then you'll receive a notifciation email with a notice
  telling you that the scheduler didn't manage to restart your container.

Once the application is ready, the traffic is diverted to the newly booted
container(s), and the order to stop old containers is passed.

When **deploying** an application using multiple web containers, we're waiting
for **all web containers** to be available before making the switch to this new
release and stopping old containers.

> <h4 style="margin-top:0.3em">Short period with double containers</h4>
>
> For a short period both old and new containers are running. If your application
> is based on schedule tasks, or asynchronous workers, you need to take care of
> developing them idempotent in the potential case where a schedule task is handled
> twice.

## Shutdown of old containers

We have adopted a standard process:

1. Send SIGTERM to the process started in the container
2. Wait 30 seconds
3. Send SIGKILL if the process is still alive

In other words, your application has 30 seconds to catch the SIGTERM signal and
clean its state before we force it to stop.
