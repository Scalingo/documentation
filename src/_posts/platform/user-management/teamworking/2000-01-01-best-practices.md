---
title: Best Practices
modified_at: 2025-07-01 12:00:00
tags: user team role collaborator security
index: 50
---


This guide outlines recommended practices for managing roles, collaborators,
and security settings on Scalingo, depending on your team's size and structure.
While Scalingo keeps access control simple, [using roles][roles] strategically
helps balancing collaboration with operational security.

The following recommendations follow the principle of [least
privilege][least-privilege], meaning that all collaborators should be assigned
the minimum permissions according to their responsibilities.

## Threat Modeling and Shared Responsibility

Roles on Scalingo are designed to enforce the principle of least privilege
within the platform. They control what users can see or modify across
applications, databases, deployments, and configuration layers. By assigning
roles appropriately, you can reduce the risk of accidental changes or
unauthorized access to critical resources.

However, platform-level access control is only one layer of protection.
Application integrity also depends on the quality and trustworthiness of the
code being deployed. Scalingo does not inspect your source code or development
workflows. As such, it is the responsibility of each owner to:

- Maintain strict access controls on your SCM provider (GitHub, GitLab)
- Review and validate all code before it reaches production
- Use protected branches and pull request reviews to enforce standards

While roles can prevent a user from deploying an unvalidated branch directly
from the dashboard they do not prevent a developer with access to your
repository from introducing harmful logic into your codebase.\
**We strongly recommend aligning your internal security practices with the
deployment methods and access permissions you have configured on Scalingo**.


## Setting the Appropriate Roles

### Small Teams

Structure example: A CTO or lead developer, and a few developers.

- Assign the **Owner** role to the CTO or technical lead responsible for
  billing and application lifecycle.
- Give the **Collaborator** role to developers who are trusted with full access
  to settings and data.
- If contributors have limited responsibilities, prefer using the **Limited
  Collaborator** role to restrict access to sensitive operations.
- Encourage code review and protected branches in your SCM to limit the impact
  of elevated permissions.

### Mid-Sized Teams

Structure example: A CTO, a lead developer, senior developers, junior
developers.

- Keep the **Owner** role for the CTO or an engineering manager in charge of
  account and billing governance.
- Assign the **Collaborator** role to trusted leads who need access to all
  environments, data, and team management.
- Use the **Limited Collaborator** role for senior developers who handle
  deployments and logs but don't need access to sensitive configurations or
  secrets.
- Junior developers do not need a Scalingo account. They can contribute to the
  project exclusively through your GitHub or GitLab workflows.
- Leverage branch protections and CI validation workflows for better deployment
  governance.

### Large or Multi-Project Teams

Structure example: Several project teams and multiple environments.

- Use a global service account (dedicated Scalingo account) as the application
  **Owner**, especially for production apps. This avoids coupling billing or
  critical permissions to a personal account.
- Apply the same role split as in [mid-sized teams](#mid-sized-teams):
  **Collaborator** for leads, **Limited Collaborator** for developers.
- Use a specific and dedicated service account to [scope API tokens](#)
  to a given application and ensure better isolation between apps.


## Scoping API Tokens

Since API tokens inherit all the permissions of the user account they are
generated from, we recommend using a dedicated service account when you need
application-scoped API access.\
Add this service account as a **Collaborator** on the specific application
only, and generate API tokens from it.

This ensures that the token has access exclusively to the intended application,
and cannot be used across other apps.


## Auditing

### Auditing Collaborators' 2FA Status

Although 2FA cannot be enforced globally on Scalingo, you can view each
collaborator's 2FA status from the [Collaborators page][dashboard-collab] of
your Scalingo dashboard.

### Reviewing Accesses

Access rights tend to evolve over time, and it's easy to overlook outdated or
excessive permissions. We recommend conducting regular access reviews to ensure
that each collaborator still has the appropriate role based on their current
responsibilities. This also helps identify inactive accounts or permissions
that should be revoked.

Regular reviews help maintain the principle of least privilege and reduce the
risk of unauthorized access. We also encourage checking the 2FA status of your
collaborators.

You can also use the [Scalingo API][api] to automate checks and integrate them
into your internal security alerts or audit processes.


[least-privilege]: https://en.wikipedia.org/wiki/Principle_of_least_privilege

[dashboard-collab]: https://dashboard.scalingo.com/collaborators
[api]: https://developers.scalingo.com

[roles]: {% post_url platform/user-management/teamworking/2000-01-01-roles %}
