---
title: Sending emails from your application
modified_at: 2016-07-22 00:00:00
category: app
tags: email smtp app
---

For various reasons (transactional, marketing, etc.) you might want to send
emails from your application. Scalingo does not provide an embedded email
server, we are not an email provider.  If you try to use the `sendmail`
executable, you will not find it.

However it's is totally possible to send email, thanks to an external SMTP
server.

## Use of an external SMTP server

As email sending is an entirely other job, we encourage you to use services
specialized into that. Here is a list containing a few actors on the market of
email as a service:

* [Mailjet](https://mailjet.com/)
* [Mandrill](https://www.mandrill.com/)
* [Sendgrid](https://sendgrid.com/)
* [Amazon SES](https://aws.amazon.com/ses/)

This list is not exclusive, but all of them will work perfectly with Scalingo.
In each case, create an account, register a new sending domain and sending
address, add the credentials in your app environment variables and use them.

## Port 25 disabled

SMTP servers are usually available on differents ports: 25 (SMTP), 465 (SMTPS),
587 (submission).  Port 25 is usually unencrypted are sometimes
unauthenticated. For this reason, such servers are often used as spam relay.

Our decision has been to **block the port 25**, but don't worry, all providers
listed above (and a lot of others) are using the port 587 when giving you the
server connection string.
