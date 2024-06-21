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

### Physical Access Control

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

## Backup and Recovery

### Backup Policy

We perform regular backups of the data hosted on the platform to protect it from data loss. The backups are stored in a secure redundant storage system to ensure that the data is protected from hardware failures and other disasters.

### Recovery Policy

In the event of a data loss, we follow a predefined recovery plan to restore the data from the backups. The recovery plan includes procedures for identifying the cause of the data loss, restoring the data from the backups, and verifying the integrity of the restored data.

### Backup Testing

We regularly test our backups to ensure that they are working correctly and that we can restore the data in the event of a data loss. The backups are tested by restoring the data to a separate environment and verifying that the data is intact and that the applications are working correctly.

## Connectivity

### Secure Connectivity

All data transmitted between the platform and the user is encrypted using HTTPS. This ensures that the data is protected from eavesdropping and tampering. The allowed ciphers are regularly updated to ensure that the platform is protected from the latest security vulnerabilities.

### Customer VPN

We offer the possibility to set up a VPN connection (OpenVPN, IPSec) between your infrastructure and the Scalingo platform. This allows you to securely connect your infrastructure to the platform and to protect your data from unauthorized access.

## Operational Security

### Logical Access Control

Access to the platform administration is restricted to authorized personnel only. It is secured by two-factor authentication and when possible uses a bastion host and a VPN connection.

### Access Review and Revocation

Access to the platform is reviewed regularly to ensure that only authorized personnel have access to the platform. Access is revoked immediately when an employee leaves the company or when their access is no longer required.

## Employee Security

### Security Training

All employees receive security training to ensure that they are aware of the security measures implemented by the platform and to prevent security incidents caused by human error.

### Security Awareness

All employees are required to follow security best practices to protect the platform from security incidents. This includes using strong passwords, enabling two-factor authentication, and following the security policies implemented by the platform.
They are trained to detect phishing attempts and to report them to the security team.

## Code Security

### Secure Development

All code changes are reviewed by our development team to ensure that they do not introduce security vulnerabilities. We use automated tools to scan the code for common security vulnerabilities and we perform manual code reviews to catch any vulnerabilities that the automated tools may have missed.

### Dependency Management

We regularly update the dependencies used by the platform to ensure that they are up-to-date and that they do not contain any known security vulnerabilities. We use automated tools to scan the dependencies for security vulnerabilities and we update them as soon as a vulnerability is detected.

### Vulnerability Management

We have a vulnerability management program in place to detect and respond to security vulnerabilities in the platform. We use automated tools to scan the platform for security vulnerabilities and we have procedures in place to patch the vulnerabilities as soon as they are detected.

### Change Management

All changes to the platform are reviewed by our development team to ensure that they do not introduce security vulnerabilities. We use automated tools to scan the changes for security vulnerabilities and we perform manual code reviews to catch any vulnerabilities that the automated tools may have missed. Our change management process includes an analysis of the security impact of the changes prior to the development phase and a security review of the changes prior to the deployment phase.

## Third-Party Security

### Vendor Security

We perform due diligence on all third-party vendors to ensure that they have implemented security measures to protect the data hosted on the platform. We require all third-party vendors to comply with our security policies and to provide evidence of their security measures.

### Third-Party Audits

We perform regular audits of our third-party vendors to ensure that they are complying with our security policies and that they have implemented security measures to protect our data.

### Third-Party Access

Access to the platform by third-party vendors is restricted to authorized personnel only. Access is monitored and logged to ensure that only authorized personnel have access to the platform. The access is restricted to the necessary permissions and is revoked immediately when the access is no longer required.

### Vendor Selection

We carefully select our third-party vendors to ensure that they have implemented security measures to protect the data hosted on the platform. We require all third-party vendors to comply with our security policies and to provide evidence of their security measures.
