---
title: Free Trial
modified_at: 2026-07-17 00:00:00
tags: billing free trial
index: 20
---

## Free trial

When you create an account on [Scalingo](https://scalingo.com), you are given a
free trial period to test the platform.

To start the free trial, you must first configure your [billing profile][billing-profile]
and add a valid [payment method][payment-methods]. You are not charged while the free
trial is active.

### What can I do under the free trial?

You can have a **maximum of 1 application** using a **maximum of 5 containers**
(S or M size).

Review apps are considered as applications, so you can't create one while in
free trial.

Your test application can also use managed databases during the free trial.
For each of the eligible database engines listed below, you can provision **1 database instance on its smallest plan**:

- [Scalingo for PostgreSQL®][postgresql-link]
- [Scalingo for MySQL®][mysql-link]
- [Scalingo for Caching (Redis®)][redis-link]

You would like to test another engine or another plan? Contact us on the chat.


### How to leave the free trial early?

You may want to leave the free trial period earlier to start using the platform to
its full potential. To do so, open the
[web dashboard](https://dashboard.scalingo.com/billing) and click the
`Stop free trial` button. Your billing starts and the free trial limits are
removed.

### What happens at the end of the free trial?

3 days and 1 day before the end of the free trial, you will receive an email
to notify you of the remaining days under the free trial.

At the end of the free trial, the resources you created keep running and your
billing starts automatically with the payment method configured on your account.

{% warning %}
If you don't want to be charged after the free trial, you must delete your
applications, databases, and add-ons before the trial ends. Scalingo does not
automatically remove these resources at the end of the free trial.
{% endwarning %}

[billing-profile]: {% post_url platform/billing/2000-01-01-profile %}
[payment-methods]: {% post_url platform/billing/2000-01-01-payment-methods %}
[postgresql-link]: {% post_url databases/postgresql/about/2000-01-01-overview %}
[mysql-link]: {% post_url databases/mysql/about/2000-01-01-overview %}
[redis-link]: {% post_url databases/redis/2000-01-01-start %}
