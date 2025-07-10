---
title: Application External Testing
nav: External Testing
modified_at: 2025-07-09 00:00:00
tags: security pentest load-test procedures
---

## Testing my application that is running on Scalingo

### Can I run a load test on my application that is running on Scalingo?

You can run a load test / smoke test / endurance test on your application under the following conditions:

1. Ask the support using [support@scalingo.com](mailto:support@scalingo.com) or use the support chat
2. Your request should include the following information:
  - The application name on Scalingo,
  - The Scalingo region where the application is hosted,
  - The source IPs of the requests,
  - The target public URLs that will be used,
  - Number of requests per minute,
  - Size of the payload of each request,
  - Time slot in which the load test is planned. Note that the test should only be run during business hours - 09:00 to 12:00 and 14:00 to 18:00 (CET/CEST, Europe/Paris timezone). The test must have a specific start and end time.
  - Please include any information you think may be useful to assess your request.
3. We will reply within 7 business days to give you the authorization or suggest you another time period

{% include security_testing_warning.md %}

### I want to have a pentest on my application that is running on Scalingo, what do I do?

A pentest (or intrusion test) is a professional service that you hire to find vulnerabilities in your application.

Such service offer is governed by an agreement which engages all three parties involved: the customer, the pentesting company and Scalingo.
This document defines specifically the scope of the pentesting, its duration, and give several restrictions.

{% note %}
By default, and to speed up requests, **Scalingo will offer you its audit agreement template**. The document will be systematically transferred to you for review and approval before signature.

If you or your service provider prefer to use your own audit agreement template, it is possible to transfer it to us. IIt will then be evaluated internally by our competent departments. Additional time may be required to process the request fully.
{% endnote %}

For example:

- Restriction to the application and databases of the user
- Should not disrupt the normal working of the platform
- No use of social engineering, physical intrusion...

#### You need to use your own agreement: procedure to follow

1. Send the authorization document (signed by the customer and the pentesting
   service provider) to the Security Team at the address [security@scalingo.com](mailto:security@scalingo.com)
2. We will reply within 7 business days to either grant authorization or propose 
   an alternative timeframe if the requested date conflicts with other scheduled
   this date or if the agreement document is requesting mandatory updates
3. Let your service provider do the job
4. If there are any items in the report that would be of interest to Scalingo,
   please send us the information so that we can act accordingly

{% include security_testing_warning.md %}
