---
title: Application external testing
nav: External testing
modified_at: 2022-03-15 00:00:00
tags: security pentest load-test procedures
---

## Testing my application that is running on Scalingo

### Can I run a load test on my application that is running on Scalingo?

You can run a load test / smoke test / endurance test on your application under the following conditions:

- Ask the support using support [at] scalingo.com or use the support chat
- You should communicate the metrics of your test to the support (number of connections...)
- The test should only be run during business hours (9AM to 12AM - 2PM to 6PM)
- The test should have specific start and end hours

{% include security_testing_warning.md %}

### I want to have a pentest on my application that is running on Scalingo, what do I do?

A pentest (or intrusion test) is a professional service that you hire to find vulnerabilities in your application.

Such service offer is governed by an agreement which engages all three parties involved: the customer, the pentesting company and Scalingo.
This document defines specifically the scope of the pentesting, its duration, and give several restrictions.

{% note %}
If your service provider does not have three-way agreement, we can provide you with one.
{% endnote %}

For example:

- Restriction to the application and databases of the user
- Should not disrupt the normal working of the platform
- No use of social engineering, physical intrusion...

#### Procedure to follow

1. Send the authorization document (signed by the customer and the pentesting
   service provider) to the Security Team at the address security [at]
   scalingo.com
2. We will reply within 7 business days to give you the authorization or suggest
   you another time period if there are already too many pentests scheduled at
   this date
3. Let your service provider do the job
4. If there are any items in the report that would be of interest to Scalingo,
   please send us the information so that we can act accordingly

{% include security_testing_warning.md %}
