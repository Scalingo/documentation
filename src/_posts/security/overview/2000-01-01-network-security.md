---
title: Network Security
nav: Network
modified_at: 2024-06-20 00:00:00
tags: compliance security measures
index: 2
---

### DDoS Protection

We use a multi-level approach to protect the platform from DDoS attacks:

- data scrubbing centers are used to filter out malicious traffic (Region `osc-secnum-fr1`)
- we implement IP filtering based on known malicious IP addresses lists that are regularly updated
- we use rate limiting to prevent excessive traffic from overwhelming the platform
- we have deployed an adequate number of servers to handle the expected traffic volume

The last level of protection is your application, as your code should be able to handle the traffic it receives. We have
no means of distinguishing between an attack and a sudden increase in legitimate traffic.

If your application is not able to withstand the traffic it receives, we encourage you to subscribe to a CDN service
that will help you absorb the traffic and distribute it across multiple servers.

### Network isolation

Our network is isolated from the public internet to prevent unauthorized access to the platform. Inside the network, we
use VLANs to separate different parts of the platform and to prevent unauthorized access between them.

### Firewalls

Scalingo uses firewalls to protect the platform from unauthorized access. The firewalls are configured to allow only the
necessary traffic and to block all other traffic. There are multiple layers of firewalls to protect the platform from
different types of attacks. Inside the network, we use firewalls to protect the different parts of the platform from
each other.

### VPN

Our operations team uses VPNs to access the platform securely. This ensures that all access to the platform is encrypted
and secure.
