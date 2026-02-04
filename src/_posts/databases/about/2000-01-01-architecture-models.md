---
title: Architecture Models
nav: Architecture Models
modified_at: 2026-02-03 10:00:00
index: 4
---


Scalingo Managed Databases lets you deploy and operate databases in minutes, 
with a fully managed service built for production workloads. 
[Common features][database-features] cover scaling, resilience, security, 
backups and minute based pricing. Then, the architecture model you choose 
defines the level of execution and network isolation, and the SecNumCloud scope.


| Architecture model          | Shared Resources                         | Dedicated Resources                      |
|-----------------------------|------------------------------------------|------------------------------------------|
| Execution isolation         | Container with shared vCPU               | VM with dedicated vCPU                   |
| Network isolation           | Shared                                   | Dedicated VPC                            |
| Cluster communications [^1] | Encrypted communications                 | Encrypted communications                 |
| Availability Zones          | Single AZ                                | Up to 3 AZ                               |
| Regions                     | osc-fr1, osc-secnum-fr1                  | osc-fr1, osc-secnum-fr1                  |
| Service classes             | Starter, Business                        | Starter, Business, Enterprise            |
| Scaling                     | Scale up and scale down                  | Scale up only                            |
| Service class switching     | Scale in and out between service classes | Scale in and out between service classes |
| Attachment model            | Add-on to an application                 | Dedicated database, no app required      |
| Collaborators               | Inherits the app collaborators           | Has its own collaborators                |
| Internet access             | Can be enabled or disabled               | Fine grained firewall                    |
| HDS eligibility             | Yes                                      | Yes                                      |
| SecNumCloud scope           | Infrastructure only                      | Infrastructure and service               |

[^1]: For Business and Enterprise (HA) clusters, intra cluster communications are always encrypted, for both architecture models.


## Architecture models overview

### Shared Resources (SR)

Shared Resources is Scalingo's default architecture model and has been powering 
our managed databases for years. It delivers strong performance and security on 
shared infrastructure.

It is suitable for a wide range of workloads, from development and testing to 
production.

### Dedicated Resources (DR)

Dedicated Resources builds on the same deployment and management stack, but runs 
each database instance in a private environment with dedicated compute and 
network isolation (dedicated VM and dedicated VPC). For multi node clusters, 
nodes are distributed across multiple Availability Zones within the same region.
This provides stronger isolation and security.

**Dedicated Resources is designed for SecNumCloud requirements and is the model 
we plan to certify under SecNumCloud.**

{% note %}
The Dedicated Resources architecture model is currently available for Scalingo 
for PostgreSQL® only, and only to selected customers.
To request access or learn more, please contact Support or Sales teams.
{% endnote %}


## Shared Resources infrastructure model

This section describes how Shared Resources is implemented at the infrastructure level.

<-----WIP----->


## Dedicated Resources infrastructure model

This section describes how Dedicated Resources is implemented at the infrastructure level.

<-----WIP----->

- Isolation and compute
  - 1 VM per service node
  - RAM fully allocated. No overcommit
  - Fully dedicated vCPU cores
  - 1 volume with dedicated IOPS per service node
- Networking
  - 1 VPC = 1 Dedicated Outscale account per database instance or cluster
  - Nodes are spread across up to three availability zones (AZ) within each region
- Scaling behavior
  - can only be vertically scaled up
  - can be horizontally scaled in and out by switching service class: Starter ↔ Business ↔ Enterprise

### Firewalling
Scalingo provides firewalling capabilities for managed databases.

Details to document precisely:
- Maximum number of rules. currently noted as “30?”
- Average sync time. currently noted as “2 minutes”
- CIDR notation with mask
  - single IP with /32
  - or range

### Collaborators
- Only **Collaborators** can be invited.
- It’s not possible to add **Limited Collaborators**.
  - Rationale currently noted: their goal is to be able to develop the app but prevent any access to data.
  - Potential future: allow them to create backups without any way to access data or modify database configuration.


[database-features]: {% post_url databases/about/2000-01-01-features %}
