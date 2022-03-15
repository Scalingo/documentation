---
title: Application external testing
nav: External testing
modified_at: 2022-03-15 00:00:00
tags: security pentest load-test procedures
---

## Testing my application that is running on Scalingo

### Can I run a load test on my application that is running on Scalingo?

You can run a load test / smoke test / endurance test on your application under the following conditions :

- Ask the support using support [at] scalingo.com or use the support chat
- You should communicate the metrics of your test to the support (number of connections...)
- The test should only be run during business hours
- The test should have specific start and end hours

{% note %}
If you do not follow this procedure you are at risk of getting your client IP
address banned, your application put under surveillance and/or your account
closed.
{% endnote %}

### I want to have a pentest on my application that is running on Scalingo, what do I do?

A pentest (or intrusion test) is a professional service that you hire to find vulnerabilities in your application.

We are used to communicate with those people and speak the same language :)

Intrustion tests are authorized under the following conditions :

- You should communicate us an authorization document that will be signed by:
  - the application owner
  - the pentesting company
  - Scalingo
- Send the document to the Security team at the address security [at] scalingo.com


{% note %}
If you do not follow this procedure, the intrusion testing will
trigger our alerting system and you may get the client network IP address
banned, your application put under surveillance and/or your account closed.
{% endnote %}