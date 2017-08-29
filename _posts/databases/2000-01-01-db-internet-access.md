---
title: Database Reachable from Internet
modified_at: 2017-08-29 00:00:00
category: databases
tags: databases internet public access
---

## Context

By default, your database is only reachable from within the Scalingo data
center. If you want to access your database remotely (e.g. from your computer),
you can either [setup an SSH tunnel](/databases/tunnel.html) or make your
database accessible from the internet.

## Make the database reachable from anywhere

### Warning

Before activating this feature, we strongly suggest you to read carefully the
following paragraphs.

After making your database accessible from internet, anybody can try to connect
to it. Your database is protected by a login and a strong password so that only
you can actually connect to it.

Another drawback is that any communication between your computer and the server
is un-encrypted by default. You should make sure that TLS support is available
before activating this access to prevent anybody to be able to read the content
of your communication between your computer and the server.

### How to

Just head to your database dashboard and click on the toggle button to make it
reachable from internet.

TODO: add a screenshot
