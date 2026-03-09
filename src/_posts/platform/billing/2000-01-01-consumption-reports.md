---
title: Monitoring Consumptions
modified_at: 2025-07-07 12:00:00
index: 40
---


## Viewing Consumptions

### Current Consumption

Scalingo allows you to follow your current consumption. **It's updated everyday
around midnight UTC**:

1. From your web browser, open your [dashboard][dashboard]
2. Select the **Consumption** tab
3. Make sure the selected **period** is the current month

{% assign img_url = "https://cdn.scalingo.com/documentation/screenshot_dashboard_consumption_reports.png" %}
{% include mdl_img.html %}

{% note %}
The amounts shown are frozen at the end of each billing period. A project or 
application transferred during the month is billed to its new owner, even if you 
can see its consumption for the period prior to its transfer.
{% endnote %}

### Past Consumptions

When a billing period is over and the invoice has been issued, you can explore
your consumption to identify the main cost drivers.

Please note that the consumption report document **is not an invoice**, but a
breakdown of your consumption **excluding VAT**. It doesn't consider the free
trial period nor any vouchers or credits.

1. From your web browser, open your [dashboard][dashboard]
2. Select the **Consumption** tab
3. Select the **period** you're interested in


## Grouping Consumption by App or Ressource

Consumption are grouped by **App** by default. This makes it easy to identify
which applications consume the most resources and represent the largest cost
center.

You can also group your consumption by **Resource** to identify which
represents the largest share of your invoice.


## Exporting Consumptions

We know how important it is for you to extract and integrate your data into
your own information system. These consumption reports can be quickly and
easily exported in CSV or JSON format.

{% note %}
Amounts in the CSV and JSON exports are given in Euro cents, excluding VAT.
{% endnote %}


[dashboard]: https://dashboard.scalingo.com
