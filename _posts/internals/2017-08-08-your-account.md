---
title: Manage your Account
modified_at: 2018-01-26 00:00:00
category: platform
tags: account
order: 6
---

The configuration of your account is done using the
[dashboard](https://my.scalingo.com). The following sections are reachable from
the top right menu:

## Profile [<i class="fa fa-external-link"></i>](https://my.scalingo.com/profile)

Personal information can be managed from this page. It includes changing
username/email/password as well as configuring Scalingo's newsletter
subscription.

On this page, the API token associated to your account is available. This
token let you authenticate to our API if you need to build tools to manage the
platform in a programmable way. Have a look at our [API
documentation](https://developers.scalingo.com) to learn how to use it.

Account deletion is located here. The action is possible only once your account
does not own any application anymore, make sure to delete them all first.

## SSH Keys [<i class="fa fa-external-link"></i>](https://my.scalingo.com/keys)

SSH keys serve as a means of identifying yourself to Scalingo's git server.
Each time a deployment is triggered using the `git push` command, your account
need to be authenticated with one of your SSH Keys.

[Learn how to configure your SSH key for your operating system]({% post_url getting-started/2015-06-02-first-steps %})

## Billing [<i class="fa fa-external-link"></i>](https://my.scalingo.com/billing)

Configure your payment methods in this section. The platform support 3 methods:

* Debit/Credit card payments: the beginning of each month, the platform charges
on the cards what has been consumed the month before.

* Prepaid credit bought with PayPal: buy credit in advance and we'll use them to pay
the invoices. Payment fallback on the bank card if there is not enough credit to
pay an invoice.

* SEPA payment: for customers located in the European Union, SEPA debit can be used to pay
invoices, an electronic SEPA mandate is generated during the setup process.

Payment history can also be found on this page, including links to download
your past invoices.

## Referrals [<i class="fa fa-external-link"></i>](https://my.scalingo.com/referrals)

Scalingo embeds a referral program: recommend us and share your referral link,
you'll get discounts worth of 20% of the invoices amount received by the people
you've invited, each month during 12 months.

## Timeline [<i class="fa fa-external-link"></i>](https://my.scalingo.com/timeline)

All the activities attached to your account are present in this view. It
gathers events you have done to your account applications, owned or as
collaborators, and those related to your account directly (i.e. Add/Remove SSH
Key). Events achieved by application collaborators are not present here, go to
the application's timeline to get them.
