---
title: Free Trial
modified_at: 2025-12-08 00:00:00
tags: billing free trial
index: 20
---

## Free trial

When you create an account on [Scalingo](https://scalingo.com), you are given a
free trial period to test the platform.

As long as you don't want to go out of the limit of the free trial, you don't
have to give us your billing details nor payment methods.

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

In addition, you can add as many other addons as you want, as long as they have free plans available.

### How to break out of the free trial?

You may want to leave the free trial period earlier to start using the platform to
its full potential. To do so, you need to enter a payment method on the
[web dashboard](https://dashboard.scalingo.com/billing). Once done, you can forcefully
leave the trial period by clicking the `Stop free trial` button. Your billing now
starts and limits are gone.

### What happens at the end of the free trial?

3 days and 1 days before the end of the free trial, you will receive an email
to notify you of the remaining days under the free trial.

**If you don't enter your payment details at the end of the free trial, your
application will be automatically downscaled to 0 container and its addons will
be paused.**

Moreover, a set of restrictions will be applied automatically on **your**
application. Consequently, you won't be able to:
- create a new application;
- scale your application;
- create, update or resume your addons;
- launch new deployments;
- run a one-off from your application;
- run scheduled tasks (cron jobs).

These restrictions don't apply on applications for which you are a collaborator
as long as these applications are owned by a paying customer.

As soon as you enter payment details, the restrictions will be lifted, you
will be able to scale your application back up and resume its addons. These
operations must be done **manually**.

{% warning %}
After a period of thirty (30) days, if no order is made by the client owning the apps, the resources will be deleted from the platform.
{% endwarning %}

[postgresql-link]: {% post_url databases/postgresql/about/2000-01-01-overview %}
[mysql-link]: {% post_url databases/mysql/about/2000-01-01-overview %}
[redis-link]: {% post_url databases/redis/2000-01-01-start %}
