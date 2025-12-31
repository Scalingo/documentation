---
title: Recovery Management
modified_at: 2021-04-07 00:00:00
tags: internals faq crash recovery
index: 5
---

## What happen when a server of the platform is unavailable (crash, fire, hardware problem)?

### Applications

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

### Databases

If a database hosting server is detected as unavailable, our team is instantly alarmed.

* If the database is using a **business** plan, a failover will automatically
  happen in the minute the incident is detected. Keeping your database
  available in such an event
* For **starter** plans, a longer downtime can be expected
  since the database instance will be kept unavailable until the completely
  recovery or redeployment of the impacted server.

## What happens if a complete datacenter is taken down (electricity issue, fire…)?

In the case of a disaster incident in which a complete datacenter would be
wiped out permanently or inaccessible for a long enough period, it can be
decided to execute our Disaster Recovery Plan. This is a procedure that ensures
business continuity by defining how to restore our services as fast as possible
with minimal data loss.

### Locations of backups

All the backups are saved and replicated in multiple geographical locations:

* Replica 1: In the datacenter of the application/database
* Replica 2: In a datacenter at more than 10km from other replicas (real-time replication)
* Replica 3: In a datacenter at more than 10km from other replicas (daily
  snapshot operated by our infrastructure provider Outscale in the scope of
  their Disaster Recovery Plan)

This redundancy ensure there will always be sufficient data to recover a catastrophic event.

### Hosted Databases - Recovery Point Objective (RPO)

The RPO determines the maximum acceptable amount of data loss measured in time.
It depends of the type of database you are using:

* Scalingo for MySQL®, Scalingo for MongoDB®, Scalingo for Elasticsearch®, Scalingo for Caching, Scalingo for InfluxDB®: last daily backup: at worst 24h of data loss
* Scalingo for PostgreSQL®: continuous backuping, at worst: 30 minutes of data loss
