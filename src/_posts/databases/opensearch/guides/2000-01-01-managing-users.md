---
title: Managing Users and Roles of Your Scalingo for OpenSearch® Addon
nav: Managing Users and Roles
modified_at: 2025-04-28 12:00:00
tags: databases opensearch addon
index: 1
---


Each Scalingo for OpenSearch® addon comes with a [default database user](#understanding-reserved-user).

{% note %}
**We currently don't support managing roles and users of OpenSearch® addons**.
Consequently, creating additional users and roles or deleting users and roles
is currently not possible. This feature will be integrated in a future
release.\
Thanks for your understanding <3
{% endnote %}


## Managing Users

### Understanding Reserved User

When provisioning a new Scalingo for OpenSearch® addon, the platform creates a
default user with a random name and password. It also grants this default user
read and write permissions on the database.

{% note %}
This default user is ***reserved*** and thus:
- can't be renamed, nor removed,
- its password can't be updated
{% endnote %}
