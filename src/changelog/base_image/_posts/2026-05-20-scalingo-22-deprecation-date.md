---
modified_at: 2026-05-21 00:00:00
title: 'Deprecation Plan for scalingo-22'
---

The [scalingo-22]({% post_url platform/internals/stacks/2000-01-01-scalingo-22-stack %}) stack, based on the Ubuntu 22.04 LTS operating system, is deprecated and will be discontinued on June 1, 2027.

From this date, Scalingo will no longer support applications running on scalingo-22, and new deployments, including Review Apps, must use scalingo-24 or later. To ensure the security, performance, and reliability of both your applications and our platform, we strongly encourage you to plan their migration to scalingo-24, based on Ubuntu 24.04 LTS, before June 1, 2027.

The [scalingo-24]({% post_url platform/internals/stacks/2000-01-01-scalingo-24-stack %}) stack, based on Ubuntu 24.04 LTS, will be supported through May 2029. This makes it a secure and sustainable choice for ensuring the continued functionality of your applications.

**Deprecation Plan**

- **June 2026: End-of-support notification**. All owners and collaborators of applications using scalingo-22 are informed of the end of support for this stack.
- **June 1, 2027: Discontinued**. Ubuntu 22.04 LTS and scalingo-22 no longer receive updates.\\
  From this date, it is no longer possible to select this stack to create new applications.\\
  Scalingo will no longer support applications running on scalingo-22, and new deployments, including Review Apps, must use scalingo-24 or later.


**Act-now Items (as of 2026-05-21)**

To ensure the security, performance, and reliability of your applications, we encourage you to:
- Start planning your migration to `scalingo-24` without any further delay
- Conduct migration tests to identify potential blocking items
- Fix any blocking items found
- Migrate as soon as possible, before June 1, 2027.

Resources to guide you:
- [Scalingo Stacks](https://doc.scalingo.com/platform/internals/stacks/stacks)
- [Details on scalingo-24](https://doc.scalingo.com/platform/internals/stacks/scalingo-24-stack)
- [Ubuntu releases list](https://documentation.ubuntu.com/project/release-team/list-of-releases/)
