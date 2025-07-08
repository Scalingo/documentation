---
nav: Navigating the Account Dashboard
title: Navigating the Scalingo Account Dashboard
modified_at: 2025-07-02 12:00:00
index: 20
---


The **account dashboard** provides a central place to manage your Scalingo
account, including personal details such as username, full name, location,
password, etc.

To access the account dashboard, locate the rounded button with your account
initials on the top right corner of our [dashboard][dashboard-account], and
click it. Then select **User settings** from the dropdown menu.


## Basic Information

The [**Basic information**][dashboard-account] tab allows to:

- Update your username, fullname, location, company, and profile
- Subscribe to our newsletter or unsubscribe from it
- Access all legal and contractual documents applicable to your account,
  whether currently active or archived
- Set or update personal preferences (dashboard theme, dashboard lang, etc.)


## Authentication

The [**Authentication**][account-authorization] tab allows to:

- Change your e-mail address
- Update your account password
- Enable or disable two-factor authentication (2FA)
- Delete your Scalingo account


## SSH Keys

The [**SSH Keys**][account-keys] tab allows to:

- Add or remove the SSH keys associated to your Scalingo account

🛈 Learn more about [configuring your SSH key][ssh-keys] for your workstation.


## API Tokens

The [**API Tokens**][account-tokens] tab allows to:

- Generate new API tokens associated with your Scalingo account
- Renew your existing API tokens
- Revoke your API tokens

{% note %}
Reminder: API tokens inherit the exact permissions of your account for each
application or database. Currently, it is not possible to restrict the scope or
permissions of an individual token. For improved security, especially in larger
organizations, we recommend reviewing our [security best
practices][best-practices]
{% endnote %}

🛈 Have a look at our [API documentation][api] to learn more about API tokens.


## SCM Integrations

The [**SCM Integrations**][account-integrations] tab allows to:

- Connect or disconnect your account to SCM tools such as GitHub or GitLab

🛈 Learn more about [Source Code Management integrations][scm].


## Health Data (HDS)

The [**Health Data (HDS)**][account-hds] tab allows to:

- Access the latest HDS contractual documents related to health data hosting
- Add or update the designated healthcare point of contact for your
  HDS applications

{% note %}
Reminder: the point of contact must be reviewed at least every 12 months and
updated if necessary.
{% endnote %}

🛈 Learn more about the [HDS certification][hds]


## Referrals

The [**Referrals**][account-referrals] tab allows to:

- Get your referral link
- View some statistics related to your referrals (clicks, sign-ups, earnings)


[api]: https://developers.scalingo.com
[dashboard-account]: https://dashboard.scalingo.com/account
[account-authorization]: https://dashboard.scalingo.com/account/authorization
[account-keys]: https://dashboard.scalingo.com/account/keys
[account-tokens]: https://dashboard.scalingo.com/account/tokens
[account-integrations]: https://dashboard.scalingo.com/account/integrations
[account-hds]: https://dashboard.scalingo.com/account/hds
[account-referrals]: https://dashboard.scalingo.com/account/referrals

[ssh-keys]: {% post_url platform/getting-started/2000-01-01-first-steps %}#ssh-key-setup
[scm]: {% post_url platform/app/2000-01-01-scm-integration %}
[best-practices]: {% post_url platform/user-management/teamworking/2000-01-01-best-practices %}
[hds]: {% post_url compliance/2000-01-01-hds %}
