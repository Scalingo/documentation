---
title: Sending emails with Meteor
modified_at: 2015-11-09 00:00:00
category: meteor
tags: tutorial nodejs meteor emails languages
---

## Setup of MAIL\_URL

Meteor is automatically reading the address of the email server it
will send emails from the environment variable `MAIL_URL`. The URL
has the following structure:

```bash
smtp://user:password@host:port
```

To add the environment variable, run the following command or add it through
[your dashboard](https://my.scalingo.com)

```bash
scalingo env-set MAIL_URL=<smtp_url>
```

More information in [the official Meteor documentation](http://docs.meteor.com/#/full/email)

## Snippet to send an email with Meteor

```javascript
recipient = "user@example.com"
Email.send({
  from: process.env.EMAIL_FROM,
  to: recipient,
  subject: "Test email to " + recipient,
  text: "Hello " + recipient + "\n\nThis is a simple test email\n"
});
```

Automatically Meteor will use the `MAIL_URL` server address and send the email.

## Use of an external SMTP server

Scalingo is not an email server provider, as this is an entirely other job we encourage
you to use services specialized into that. Here is a list containing a few actors on the
market of email as a service:

* [Mailjet](https://mailjet.com/)
* [Mandrill](https://www.mandrill.com/)
* [Sendgrid](https://sendgrid.com/)
* [Amazon SES](https://aws.amazon.com/ses/)

This list is not exclusive, but all of them will work perfectly with Scalingo. In each case,
create an account, register a new sending domain and sending address and build the `MAIL_URL`
from the credentials given by the provider.
