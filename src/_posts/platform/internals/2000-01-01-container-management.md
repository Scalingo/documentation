---
title: Container Management
modified_at: 2021-07-07 00:00:00
tags: internals containers
index: 1
---

## Zero-Downtime Operations

The platform is ensuring **zero downtime deployments**: when a new version of
your application is deployed, the system is waiting for the new version of the
container to be online, before stopping the old version.

This is the same principle when you're **restarting** one or several containers
of your application, new containers have to be available at first, then the
order to stop old containers is done.

With this feature, it let you achieve **rolling release/continuous delivery**
easily. There is no friction when a new version of your software is deployed,
your users won't even notice it.

## Starting New Containers

When a new `web` or `tcp` container is started, its environment contains the `PORT`
environment variable. Your application must listen on this port in order to
receive requests. Once the application has been started, the container scheduler
will try to connect to your application on the port defined previously during
**60 seconds**. Once a TCP connection is accepted by your container, we consider
the container ready to get requests. Otherwise, the operation is aborted with a
[Boot Timeout Error]({% post_url platform/getting-started/2000-01-01-common-deployment-errors %}):

* In the case of a deployment, it will be stopped with the **status
  'timeout-error'** and you'll have to fix why your application has not been
  listening in time on the corresponding port.

* In a restart or scale operation, we will retry to start the container 20 times with
  exponential backoff, then you'll receive a notification email with a notice
  telling you that the scheduler didn't manage to start your container.

Once the application is ready, the traffic is diverted to the newly booted
container(s), and the order to stop old containers is passed.

When **deploying** an application using multiple web containers, we're waiting
for **all web containers** to be available before making the switch to this new
release and stopping old containers.

{% note %}
  <strong>Short period with double containers</strong>
  For a short period both old and new containers are running. If your application
  is based on schedule tasks, or asynchronous workers, you need to take care of
  developing them idempotent in the potential case where a scheduled task is handled twice.
{% endnote %}

## Shutdown of Old Containers

We have adopted a standard process:

1. Send SIGTERM to the process started in the container
2. Wait 30 seconds
3. Send SIGKILL if the process is still alive

In other words, your application has 30 seconds to catch the SIGTERM signal and
clean its state before we force it to stop.

## The `.profile` Script

During startup of any container types, the container starts a Bash shell that sources the `.profile` script, before executing the container start command. You can use it to customize the application environment to your needs. You should be careful when overriding an environment variable as the value defined by the buildpack might be important. Here is a couple fo examples on how you could safely define some environment variables:

```bash
# Add a a new folder to the PATH
export PATH="$PATH:$HOME/custom/bin"

# Set a default LANG if it does not exist in the environment
export LANG=${LANG:-en_US.UTF-8}
```

The `.profile` script is guaranteed to be executed after the scripts in `.profile.d/`.
