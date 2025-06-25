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

When inviting a new collaborator, it is essential to assign them the appropriate role based on their responsibilities. [Roles]({% post_url platform/user-management/2000-01-01-roles %}) define the level of access and actions a user can perform on your applications and databases.

## Managing Collaborators

### Listing all Collaborators

Using the Dashboard:
- Go to the **Collaborators** tab
- If you already have collaborators, you'll see a consolidated list of all users collaborating on your apps, along with their 2FA status
- You can click on the **Group by Apps** toggle to display a tree view of your apps and their associated collaborators. For now, only applications with collaborators are displayed there

### Listing Collaborators of an app

Using the dashboard:
- Go to your application dashboard
- Go to **Settings** tab
- You will automatically be taken to the collaborators menu

Using the Command Line
```shell
scalingo --app my-app collaborators
```

### Adding a Collaborator

{% note %}
While the main Collaborators page provides a consolidated list, collaborators are managed individually for each application.
{% endnote %}

Using the Dashboard

- Go to your application that needs a new collaborator
- Go to the Settings tab
- You will automatically be taken to the Collaborators menu
- Click on the Add button
- Add the required collaborator email
- You will now see the collaborator in light grey in the table.
- The collaborator will receive an email to join the collaboration (and subscribe to Scalingo if required).
- Once done, you will see the collaborator in black.

Using the Command Line

```shell
scalingo --app my-app collaborators-add user@example.com
```

### Removing a Collaborator

Using the Dashboard

- Go to your application that needs a new collaborator
- Go to the Settings tab
- You will automatically be taken to the Collaborators menu
- Click on the trash can corresponding to the collaborator's mail
- Validate in the pop-up

Using the Command Line

```shell
scalingo --app my-app collaborators-remove user@example.com
```

When you remove permissions from a user, environment variables and other credentials are not changed. Users can still directly access services if they know the service credentials. To fully revoke access, make sure to rotate all relevant secrets, such as database passwords and API tokens.

{% note %}
At the moment, updating the password of the default database user requires assistance from the Scalingo support team. Once the password is changed, you must manually update the associated environment variable and restart the parent application for the new credentials to be used.
{% endnote %}
