---
modified_at: 2025-02-07 14:00:00
title: 'Deprecation Plan for scalingo-20'
---

The [scalingo-20]({% post_url platform/internals/stacks/2000-01-01-scalingo-20-stack %}) stack, based on the Ubuntu 20.04 LTS operating system, will be deprecated in April 2025.

Applications using scalingo-20 will continue to function after this date. However, to ensure the security, performance, and reliability of both your applications and our platform, we strongly encourage you to plan their migration to scalingo-22, based on Ubuntu 22.04 LTS, as soon as possible.

The [scalingo-22]({% post_url platform/internals/stacks/2000-01-01-scalingo-22-stack %}) stack, based on Ubuntu 22.04 LTS, will be supported until April 2027. This makes it a secure and sustainable choice for ensuring the continued functionality of your applications.

**Deprecation Plan**

- **February, 2025: End-of-support notification**. All owners and collaborators of applications using scalingo-20 are informed of the end of support for this stack.
- **May 1, 2025: Usage exemption for legacy apps**. Ubuntu 20.04 LTS and scalingo-20 officially reach end-of-life and no longer receive updates.
From this date, it is no longer possible to select this stack to create new applications.
Existing applications using the scalingo-20 stack will continue to function normally, with the ability to create new deployments or Review Apps on this version.
- **January 1, 2026: End of usage exemption**. From this date, no new deployments are allowed on the scalingo-20 stack. Deployments made before this date continue to function, but using a supported stack becomes mandatory for any new deployment.


**Plan today**

To ensure the security, performance, and reliability of your applications, we encourage you to migrate to scalingo-22 as soon as possible.

Resources to guide you:
- [Scalingo Stacks](https://doc.scalingo.com/platform/internals/stacks/stacks)
- [Details on scalingo-22](https://doc.scalingo.com/platform/internals/stacks/scalingo-22-stack)
- [Overview of scalingo-22](https://scalingo.com/blog/scalingo-22-new-stack)
