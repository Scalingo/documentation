---
title: Security Overview
nav: Security Overview
modified_at: 2024-06-20 00:00:00
tags: compliance security measures
index: 4
---

This document describes the security measures implemented by Scalingo to ensure the security of the platform and the data hosted on it.

## Physical Security

### Datacenters

Scalingo uses datacenters that are certified ISO 27001, ISO 27017, ISO 27018, HDS (Region `osc-secnum-fr1`) and SecNumCloud (Region `osc-secnum-fr1`). These certifications ensure that the datacenters have implemented a high level of security to protect the data hosted on them.

### Access Control

Access to the datacenters is restricted to authorized personnel only. Access is controlled by a badge system and is monitored by video surveillance.

## Network Security

### DDoS Protection

Outscale, the provider of the datacenters used by Scalingo, provides DDoS protection to protect the platform from DDoS attacks.
However, it is important to note that DDoS protection is not a silver bullet and that it is important to implement additional security measures to protect against DDoS attacks. In particular, the volume of traffic that will trigger the DDoS protection is quite high, so it is important to implement rate limiting and other security measures to protect against smaller attacks.

### Firewalls

Scalingo uses firewalls to protect the platform from unauthorized access. The firewalls are configured to allow only the necessary traffic and to block all other traffic. There are multiple layers of firewalls to protect the platform from different types of attacks.

### VPN

Our operations team uses VPNs to access the platform securely. This ensures that all access to the platform is encrypted and secure.

### Network isolation

Our network is isolated from the public internet to prevent unauthorized access to the platform. Inside the network, we use VLANs to separate different parts of the platform and to prevent unauthorized access between them.

## Application Security

### Code Review

All code changes are reviewed by our development team to ensure that they do not introduce security vulnerabilities. We use automated tools to scan the code for common security vulnerabilities and we perform manual code reviews to catch any vulnerabilities that the automated tools may have missed.

### Security Headers

We use security headers to protect the platform from common security vulnerabilities such as cross-site scripting (XSS) and clickjacking. These headers are configured to prevent common attacks and to protect the platform from known security vulnerabilities.

### Encryption

All data transmitted between the platform and the user is encrypted using HTTPS. This ensures that the data is protected from eavesdropping and tampering. The allowed ciphers are regularly updated to ensure that the platform is protected from the latest security vulnerabilities.

### Security Monitoring

We use security monitoring tools to detect and respond to security incidents in real-time. These tools monitor the platform for signs of abnormal activity and alert our operations team if any suspicious activity is detected.

### Incident Response

In the event of a security incident, our operations team follows a predefined incident response plan to contain the incident and mitigate its impact. The incident response plan includes procedures for identifying the cause of the incident, containing the incident, and restoring the platform to normal operation. After the incident has been resolved, we perform a post-mortem to identify the root cause of the incident and to prevent similar incidents from occurring in the future.

## Measures protecting your code and data

### Data Encryption

All data stored on the platform is encrypted at rest to protect it from unauthorized access. The encryption keys are managed by the platform and are rotated regularly to ensure that the data is protected from unauthorized access.

### Data Backups

We perform regular backups of the data hosted on the platform to protect it from data loss. The backups are stored in a secure redundant storage system to ensure that the data is protected from hardware failures and other disasters.

### Data Isolation

Each application hosted on the platform is isolated from other applications to prevent unauthorized access to the data. The platform uses containerization to isolate each application in its own container and to prevent unauthorized access between containers.

### Data Privacy

We take data privacy seriously and we are committed to protecting the privacy of our users' data. We do not share our users' data with third parties without their consent and we take all necessary measures to protect the data from unauthorized access.

### Data Integrity

Your applications are built on separate containers (builders), which are isolated from the runtime containers. This ensures that the code you deploy is not tampered with during the build process. Furthermore, the images built are immutable and cannot be modified once they are produced and deployed.

### Resilience

The platform is designed to be resilient to hardware failures and other disasters. We use redundant storage systems to protect the data from hardware failures and we have multiple datacenters to protect the platform from disasters such as fires and floods.
