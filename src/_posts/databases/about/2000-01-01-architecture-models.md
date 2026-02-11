---
title: Architecture Models
nav: Architecture Models
modified_at: 2026-02-03 10:00:00
index: 2
---


Scalingo Managed Databases lets you deploy and operate databases in minutes, 
with a fully managed service built for production workloads. 
[Common features][database-features] cover scaling, resilience, security, 
backups and minute based pricing. Then, the architecture model you choose 
defines the level of execution and network isolation, and the SecNumCloud scope.


| Architecture model          | Shared Resources                         | Dedicated Resources                                    |
|-----------------------------|------------------------------------------|--------------------------------------------------------|
| Execution isolation         | Container with shared vCPU               | VM with dedicated vCPU                                 |
| Network isolation           | Shared                                   | Dedicated VPC                                          |
| Cluster communications [^1] | Encrypted communications                 | Encrypted communications                               |
| Regions                     | osc-fr1, osc-secnum-fr1                  | osc-fr1, osc-secnum-fr1                                |
| Availability Zones          | Single AZ                                | Up to 3 AZ                                             |
| Service classes             | Starter, Business                        | Starter, Business, Enterprise                          |
| Scaling                     | Scale up and scale down                  | Scale up only                                          |
| Service class switching     | Scale in and out between service classes | Scale in and out between service classes               |
| Attachment model            | Add-on to an application                 | Dedicated database, no app required                    |
| Provisioning permissions    | Any Collaborator[^2]                     | Owner only                                             |
| Collaborators               | Inherits the app collaborators           | Has its own collaborators                              |
| Internet access             | Enable/disable, no source filtering      | Fine grained firewall                                  |
| HDS eligibility             | Yes                                      | Yes                                                    |
| SecNumCloud scope           | Infrastructure qualified                 | Infrastructure qualified; Service targeted in 2026[^3] |

[^1]: For Business and Enterprise (HA) plans, intra cluster communications are always encrypted, for both architecture models.
[^2]: The "Collaborator" role (excluding "Limited Collaborator") allows users to provision add-ons.
[^3]: In 2026, Scalingo's objective is to qualify the architecture model that powers Databases on Dedicated Resources. This qualification is not yet completed.


## Shared Resources

Shared Resources is Scalingo's default architecture model and has been powering 
our managed databases for years. It delivers strong performance and security on 
shared infrastructure.

It is suitable for a wide range of workloads, from development and testing to 
production.

### Shared Resources Infrastructure Model

In the Shared Resources model, each database instance runs in its own dedicated 
container, managed by the Scalingo platform.

Containers run on shared hosts alongside other databases. Isolation is enforced 
at the container level, while the underlying infrastructure is shared.

For HA clusters, nodes are placed on different hosts to improve resilience 
against host-level failures.


## Dedicated Resources

Dedicated Resources builds on the same deployment and management stack, but runs 
each database instance in a private environment with dedicated compute and 
network isolation (dedicated VM and dedicated VPC). For multi-node clusters, 
nodes are distributed across multiple Availability Zones within the same region.
This provides stronger isolation and security.

**Dedicated Resources are designed for SecNumCloud requirements and is the model 
we plan to certify under SecNumCloud.**

{% note %}
The Dedicated Resources architecture model is currently available for Scalingo 
for PostgreSQL® only, and only to selected customers.
To request access or learn more, please contact our [Support](mailto:support@scalingo.com) or [Sales](https://scalingo.com/book-a-demo) teams.
{% endnote %}

### Dedicated Resources Infrastructure Model

In the Dedicated Resources model, each database node runs on its own dedicated 
virtual machine, with allocated RAM, dedicated vCPU cores, and a dedicated 
storage volume with dedicated IOPS.

This infrastructure-level isolation (one VM per node) provides strong tenant 
separation and more predictable compute and storage performance.

Each database instance or cluster is deployed in a dedicated VPC. For multi-node 
clusters, nodes are distributed across up to three Availability Zones within the 
same region.


[database-features]: {% post_url databases/about/2000-01-01-features %}
