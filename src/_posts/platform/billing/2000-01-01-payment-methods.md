---
title: Payment Methods
nav: Payment Methods
modified_at: 2026-11-12 00:00:00
index: 10
---


Scalingo supports three payment methods:

- **Debit/Credit Card**\
  This is the easiest and most commonly used payment method.

- **Prepaid Credits**\
  We also support buying credits **via Paypal**.

- **SEPA**\
  Because of past abuses, SEPA payments are only available **under strict
  conditions**. Please note that **all conditions must be fulfilled to
  qualify**.

  - You **must** be located in the European Union
  - You **must** have **at least** 3 consecutive invoices with an amount higher
    or equal to 100€ successfully paid via another payment method

  If you think to qualify, please get in touch with our Support team to setup
  SEPA payments.


## Adding a Payment Method

{% include billing_context.md %}

Scalingo supports adding multiple payment methods. If you have multiple payment
methods setup, Scalingo only tries to charge the one you set as the preferred
one. The platform **does not** fallback on other payment methods in case of
failure.

### Adding a Debit/Credit Card

1. Open the [Dashboard][dashboard]
2. Open **Billing**, then select the **Billing profile** tab and complete the
   [billing profile][billing-profile] if you have not already done so
3. Select the **Payment methods** tab and click **Add card**
4. Enter your card information and click **Add**

### Adding Prepaid Credits

1. Open the [Dashboard][dashboard]
2. Open **Billing**, then select the **Billing profile** tab and complete the
   [billing profile][billing-profile] if you have not already done so
3. Select the **Balance** tab and click **Add credit via Paypal**
4. Enter the amount to add in euros (minimum €5) and click **Add**
5. Sign in to PayPal and confirm the payment


[dashboard]: https://dashboard.scalingo.com/

[billing-profile]: {% post_url platform/billing/2000-01-01-profile %}
