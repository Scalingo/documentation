---
title: Transfer the ownership of an app
modified_at: 2016-12-09 00:00:00
tags: app transfer ownership
---

You may want to transfer an application to someone else. In this case you have to
invite this person as a collaborator of the application. Then you will be able to
transfer them the application.

This operation will not affect the application, nothing regarding the configuration
or the runtime of the app will be modified.

This operation is only achievable from the [Scalingo
dashboard](https://my.scalingo.com).

{% note %}
  The billing is done the last day of the month to the owner of the application at that date. Hence,
  transfering the ownership of an application the 4th of the month or the 30th at 11:59PM will not
  change anything. The owner at the date of billing is taken into account.
{% endnote %}

## Details of the operation

### Invite the future owner

1. Go in the collaborators tab
2. Invite the person you want to transfer the application to

### Accept the collaboration

*this step should be done by the user which has been invited*

1. Click on the validation link you've received by email, you'll have to login if you were unauthenticated.

The account is now collaborator of the application.

### Transfer to the new owner

1. Go in the 'Settings' tag
2. In the '*Transfer the application*' part, choose the collaborator which should receive the app
3. Validate the transfer

{% note %}
  *Note*: if you're handling both accounts, don't forget to log out between each step, otherwise the
  collaboration invitation won't be considered valid.
{% endnote %}
