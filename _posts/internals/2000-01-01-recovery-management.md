---
title: Recovery management after Platform problem
modified_at: 2016-05-31 00:00:00
category: internals
tags: internals faq crash recovery
---

## What happen when a server of the platform is unavailable (crash, fire, hardware problem)?

If one of our servers is detected as unavailable, our internal scheduler will
dispatch the containers running on this server, all around the cluster.

* If the app is using one container, it will be unavailable the time for it
  to be restarted on another host.
* If the app is using two or more containers, they are necessarily
  running on different hosts, as a result others containers will still be
  present to respond to end users HTTP requests while the container is restarted
  on a new server.

It's for this reason that the uptime SLA is different, either you have 1
container or more. You'll find details about these rules in our [Terms of
Service](https://scalingo.com/tos).

## What happens if a complete datacenter is taken down (electricity issue, fire…)?

In the case a full datacenter gets unavailable, we've setup, with our hardware provider,
a recovery plan able to resume the activity in another DC. Application and
databases data are replicated which let us restart all containers in a second DC
as fast as we can. In this, downtime is unavailable, but processes have been setup
to reduce it and recover your apps the fastest possible way.
