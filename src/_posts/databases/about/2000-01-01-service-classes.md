---
title: Service Classes
nav: Service Classes
modified_at: 2026-02-03 10:00:00
index: 3
---

Scalingo offers three ***service classes*** with distinct characteristics,
enabling you to choose the level of performance, replication, security and
price that suits your use case. All our plans are 100% managed and billed per
minute based on usage.

You can switch service classes in a few minutes, moving from a single-node
instance to a multi-node cluster, and vice versa.


## Service Classes

### Starter

The Starter class is designed for applications under development and
non-critical, production environments. With an SLA of 98%, it offers a secure,
high-performance environment for a wide range of use cases.

### Business

The Business class delivers strong high availability and production-grade
resilience, which are essential for critical production applications. Thanks
to hot replication of your data on a standby instance, we ensure service
continuity along with a 99.96% SLA. It is the first service class eligible
for Health data hosting (HDS).

### Enterprise

The Enterprise class delivers maximum fault tolerance and the highest SLA
expectations. Thanks to hot replication of your data on multiple standby
instances, we ensure service continuity along with a 99.99% SLA. It is
tailored for mission-critical and compliance-intensive environments.

{% note %}
The Enterprise service class is currently available to selected customers only.
To request access or learn more, please contact Support or Sales teams.
{% endnote %}


## Service Availability (SLA)

The availability commitment below refers to unplanned downtime only and is
measured per calendar month.

| Service class | SLA    | Max unplanned downtime (30 days) |
|---------------|--------|----------------------------------|
| Starter       | 98%    | 864 minutes                      |
| Business      | 99.96% | 17 minutes (approx.)             |
| Enterprise    | 99.99% | 4 minutes (approx.)              |

Please check our [Service Level Agreement][sla] for all details.


[sla]: https://scalingo.com/service-level-agreement
