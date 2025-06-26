---
title: Manage your Account
modified_at: 2025-06-25 00:00:00
tags: account profile tokens delete
index: 2
---

Your personal Scalingo account enables you to create applications and databases, which are billed based on your resource usage on the associated payment method.

All account configuration is performed via the [Scalingo Dashboard](https://dashboard.scalingo.com). Access account settings from the top-right menu. The main sections include:

## Profile

[Dashboard Profile page](https://dashboard.scalingo.com/account)

Manage your personal details including username, full name, location, company information, and newsletter preferences.

You can also customize your experience by selecting your preferred interface language and theme (light or dark).

## Contracts

This section displays all legal agreements applicable to your account, whether currently active or archived.

## HDS

[HDS Profile page](https://dashboard.scalingo.com/account/hds)

If you host health data under the French HDS regulations and have signed the HDS annex, this page allows you to view the applicable HDS annexes and manage the designated healthcare data point of contact for your applications.

{% note %}  
Reminder: the point of contact information should be reviewed at least every 12 months and updated if necessary.   
{% endnote %}

## Authentication

[Dashboard Authentication page](https://dashboard.scalingo.com/account/authentication)

This page lets you update the email address associated with your account along with the password and 2FA.

If your account was created using “Sign up with GitHub”, you cannot set a password via this form as no current password exists. Instead, log out and use the [Forgot your password?](https://auth.scalingo.com/users/password/new) feature with your GitHub associated email.

## SSH Keys

[Dashboard SSH keys management page](https://dashboard.scalingo.com/account/keys)

SSH keys serve as a means of identifying yourself to Scalingo's git server. Each time a deployment is triggered using the `git push` command, your account needs to be authenticated with one of your SSH Keys.

[Learn how to configure your SSH key for your operating system]({% post_url platform/getting-started/2000-01-01-troubleshooting-ssh %})

## API Tokens

[Dashboard API Tokens](https://dashboard.scalingo.com/account/tokens)

This page lists the API tokens linked to your account. They allow you to authenticate with our API to build custom tools and interact with the platform in a programmable way.

{% note %}  
API tokens inherit the exact permissions of your account for each application or database. Currently, it is not possible to restrict the scope or permissions of an individual token.  
For improved security, especially in larger organizations, we recommend reviewing our [security best practices guide]({% post_url platform/user-management/2000-01-01-guides %}).  
{% endnote %}

Have a look at our [API documentation](https://developers.scalingo.com) to learn how to use them.

## Billing

[Dashboard Billing page](https://dashboard.scalingo.com/billing)

Configure your payment methods in this section. The platform supports 3 methods:

* Debit/Credit card payments: the beginning of each month, the platform charges on the cards what has been consumed the month before.  
* Prepaid credit bought with PayPal: buy credit in advance and we'll use them to pay the invoices. Payment fallback on the bank card if there is not enough credit to pay an invoice.  
* SEPA payment: for customers located in the European Union, SEPA debit can be used to pay invoices, an electronic SEPA mandate is generated during the setup process.

Payment history can also be found on this page, including links to download your past invoices.

An invoice from the previous month consumption in the platform is generated monthly. It sums up all the resources you have used on Scalingo, it includes:

* Application containers runtime  
* Application addons

If you bought prepaid-credit with PayPal and that you have not enough credit to pay the invoice, the invoice will be considered **unpaid** and you have to add more credit.

If you add a payment card, the platform tries to charge it when the invoice is generated. If the operation fails, the invoice will be considered **unpaid**. The charge operation is then retried automatically a few times before the account is suspended and the data deleted.

To resolve the issue, you can either add prepaid credit or update your payment method during this period. The new payment method will be charged right away to cover the unpaid invoice.

## Delete my account

To delete your account, you must first delete or transfer ownership of all your applications, and ensure all outstanding bills are settled.

Then go to the Delete your Scalingo account section on the [authentication](https://dashboard.scalingo.com/account/authentication) page and click Delete. A final confirmation will be requested by email.

Your account will be deactivated and marked for deletion.

This action will queue the removal of all your Scalingo account's data, including: Deployments, Activity, Aliases, Domains, Certificates and your Billing subscription