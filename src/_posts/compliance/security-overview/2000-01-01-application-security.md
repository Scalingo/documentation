---
title: Application Security
nav: Application
modified_at: 2024-06-20 00:00:00
tags: compliance security measures application
index: 3
---

Deploying an application on Scalingo ensures that you are following a base set of security practices from the beginning.

### Immutable Infrastructure

As you push your code to Scalingo, we build a new container image with your code and dependencies. This ensures that the
infrastructure is always up-to-date and that the latest security patches are applied. The built image is frozen and any
changes that would be made to the container are lost when the container is stopped, scaled, or rescheduled by our platform.

### Container Isolation

Each application is deployed in its own container, which is isolated from other containers running on the same host.
This ensures that the application is protected from other applications running on the same host. The containers are also
isolated from the host operating system, which provides an additional layer of security.

### Scalability

The platform allows you to scale your application horizontally by adding more containers or vertically by increasing the
size of the containers. This ensures that your application can handle the expected traffic volume and that it is
protected from denial-of-service attacks or simple traffic spikes.

Furthemore, if enabled, the auto-scaling feature will automatically adjust the number of containers based on, for
example, the CPU usage of the application or the number of requests it receives.

### Dependency Management

We regularly update the dependencies used by the platform to ensure that they are up-to-date and that they do not

### Security Headers

We use security headers to protect the platform from common security vulnerabilities such as cross-site scripting (XSS)
and clickjacking. These headers are configured to prevent common attacks and to protect the platform from known security
vulnerabilities.

### Encryption

All data transmitted between the platform and the user is encrypted using HTTPS. This ensures that the data is protected
from eavesdropping and tampering. The allowed ciphers are regularly updated to ensure that the platform is protected
from the latest security vulnerabilities.
