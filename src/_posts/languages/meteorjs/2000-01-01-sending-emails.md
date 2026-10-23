---
title: Sending emails with Meteor
modified_at: 2026-10-23 00:00:00
category: languages
tags: nodejs meteor tutorial emails
permalink: /languages/javascript/meteor/sending-emails-with-meteor/
---

## Setup of MAIL\_URL

Meteor is automatically reading the address of the email server it will send
emails from the environment variable `MAIL_URL`. The URL has the following
structure:

```bash
smtp://user:password@host:port
```

To add the environment variable, run the following command or add it through
[your dashboard](https://dashboard.scalingo.com/).

```bash
scalingo env-set MAIL_URL=<smtp_url>
```

For instructions on sending emails, see the
[official Meteor documentation](https://docs.meteor.com/api/email.html).

## Use of an external SMTP server

Scalingo is not an email server provider, as this is an entirely other job we
encourage you to use services specialized into that. Here is a list containing
a few actors on the market of email as a service:

* [Mailjet](https://mailjet.com/)
* [Mandrill](https://www.mandrill.com/)
* [Sendgrid](https://sendgrid.com/)
* [Amazon SES](https://aws.amazon.com/ses/)

This list is not exclusive, but all of them will work perfectly with Scalingo.
In each case, create an account, register a new sending domain and sending
address and build the `MAIL_URL` from the credentials given by the provider.
