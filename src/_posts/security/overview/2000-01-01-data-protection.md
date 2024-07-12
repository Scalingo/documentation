---
title: Data protection
nav: Data protection
modified_at: 2024-06-20 00:00:00
tags: compliance security measures
index: 5
---

## Measures protecting your code and data

### Data Encryption

All data stored on the platform is encrypted at rest to protect it from unauthorized access. The encryption keys are
managed by the platform and are rotated regularly to ensure that the data is protected from unauthorized access.

### Data Backups

We perform regular backups of the data hosted on the platform to protect it from data loss. The backups are stored in a
secure redundant storage system to ensure that the data is protected from hardware failures and other disasters.

**Note**: The backup of the databases varies depending on the database plan and technology. Please refer to the database
documentation for more information.

### Data Isolation

Each application hosted on the platform is isolated from other applications to prevent unauthorized access to the data.
The platform uses containerization to isolate each application in its own container and to prevent unauthorized access
between containers.

### Data Privacy

We take data privacy seriously and we are committed to protecting the privacy of our users' data. We do not share our
users' data with third parties without their consent and we take all necessary measures to protect the data from
unauthorized access.

### Data Integrity

Your applications are built on separate containers (builders), which are isolated from the runtime containers. This
ensures that the code you deploy is not tampered with during the build process. Furthermore, the images built are
immutable and cannot be modified once they are produced and deployed.

### Resilience

The platform is designed to be resilient to hardware failures and other disasters. We use redundant storage systems to
protect the data from hardware failures and we have multiple datacenters to protect the platform from disasters such as
fires and floods.
