---
title: Manage Collaborators
modified_at: 2025-06-25 00:00:00
tags: app collaborators
order: 3
---

Inviting collaborators enables you to share access to specific applications while preserving full control and accountability. This feature is designed to support seamless teamwork from development to production.

{% note %}
Granting collaborator access should be done with care. While collaborators cannot delete an application, they still hold sufficient privileges to modify configurations, deploy new code, or scale resources. These actions can impact the stability or availability of your services.
{% endnote %}

When inviting a new collaborator, it is essential to assign them the appropriate role based on their responsibilities. [Roles]({% post_url platform/user-management/2000-01-01-roles %} define the level of access and actions a user can perform on your applications and databases.

@import https://doc.scalingo.com/platform/app/collaborators#managing-collaborators

When you remove permissions from a user, environment variables and other credentials are not changed. Users can still directly access services if they know the service credentials. To fully revoke access, make sure to rotate all relevant secrets, such as database passwords and API tokens.

{% note %}
At the moment, updating the password of the default database user requires assistance from the Scalingo support team. Once the password is changed, you must manually update the associated environment variable and restart the parent application for the new credentials to be used.
{% endnote %}
