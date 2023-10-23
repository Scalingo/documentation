---
title: Consumption Reports
modified_at: 2023-10-20 00:00:00
tags: billing consumption report
---

## Your consumption report

Scalingo lets you follow your consumption directly in your dashboard. Go to [https://dashboard.scalingo.com/consumption](https://dashboard.scalingo.com/consumption) and you'll see your consumption report for the current month.

{% assign img_url = "https://cdn.scalingo.com/documentation/screenshot_dashboard_consumption_reports.png" %}
{% include mdl_img.html %}

{% note %}
The amounts shown are frozen at the end of each billing period. An application transferred during the month is billed to its new owner, even if you can see its consumption for the period prior to its transfer.
{% endnote %}

## Current or past periods

This report shows the consumption of all your applications for the current billing period and is updated daily at midnight UTC.

When a billing period is over and the invoice is issued, you can explore your consumption to identify the main cost drivers.

Please note that the consumption report document **is not an invoice**, but a breakdown of your consumption **excluding VAT**. It does not take into account the free trial period or any vouchers or credits.

## Group consumption by app or ressource

Consumption are grouped by **App** by default. This makes it easy to identify the applications that consume the most resources and represent the largest cost centre.

You can also group your consumption by **Resource** to identify which represents the largest share of your invoice.

## Export as CSV or JSON

We know how important it is for you to extract and integrate your data into your own information system. These consumption reports can be quickly and easily exported in CSV or JSON format.

Please note that the amounts in the CSV and JSON exports are in Euro cents, excluding VAT.
