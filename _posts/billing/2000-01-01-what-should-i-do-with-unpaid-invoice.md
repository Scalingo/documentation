---
title: What should I do with unpaid invoices
modified_at: 2017-01-05 00:00:00
category: billing
tags: billing invoicing
---

## Issue

Invoices are tagged **unpaid** in your [billing page](https://my.scalingo.com/billing).

## Solution

An invoice from the previous month consumption in the platform is generated
monthly. It sums up all the resources you have used on Scalingo, it includes:

* Application containers runtime
* Application addons

If you bought prepaid-credit with PayPal and that you have not enough credit to
pay the invoice, the invoice will be considered **unpaid** and you have to add
more credit.

If you added a payment card, the platform tries to charge it when the invoice
is generated. If the operation fails, the invoice will be considered
**unpaid**. The charge operation is then retried everyday for 5 days in
case it was a temporary problem.

In both cases, if an invoice is unpaid for **5 days** your account will be
suspended, you have to either add prepaid credit or change the payment card
during this period. The newly added payment method will directly be used to pay
the unpaid invoice.
