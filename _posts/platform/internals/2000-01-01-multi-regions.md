---
title: Scalingo's Multi-Regions
nav: Multi-Regions
modified_at: 2019-06-25 00:00:00
tags: internals regions
index: 10
---

Scalingo is now available on multiple regions: the historical one based on
[Agora Calycé](https://www.agoracalyce.com) and a new one based on [3DS
Outscale](https://outscale.com), the cloud of Dassault Systèmes. Starting from
July 1st, 2019, existing customers can access both regions while new customers
will only see the Outscale Paris based region.

## Accessing one region or the other

### Using the web dashboard

When using the web dashboard at
[https://my.scalingo.com](https://my.scalingo.com), you will automatically be
redirected to the region you have access to. If your account has access to
multiple regions, a selection screen will be presented to let you chose which
region you want to use:

{% assign img_url = "https://cdn.scalingo.com/documentation/internals/screenshot_dashboard_regions_selection.png" %}
{% include mdl_img.html %}

You can also directly head to a region's dashboard. Here is a list of the
address for each region dashboard:

- Agora Calycé Paris:
  [https://my.agora-fr1.scalingo.com](https://my.agora-fr1.scalingo.com),
- 3DS Outscale Paris:
  [https://my.osc-fr1.scalingo.com](https://my.osc-fr1.scalingo.com).

### Using the CLI

If you use the CLI to manage your app, all commands now have the flag `--region`
to specify the region you want to use. The region can also be globally set once
with `scalingo config --region <region name>` or by defining the environment
variable `SCALINGO_REGION`. The name of the region to use can be found with:

```bash
$ scalingo regions
+-----------+------------------+------------------------------------+
|   NAME    |     DISPLAY      |            API ENDPOINT            |
+-----------+------------------+------------------------------------+
| agora-fr1 | Paris - Agora    | https://api.agora-fr1.scalingo.com |
| osc-fr1   | Paris - Outscale | https://api.osc-fr1.scalingo.com   |
+-----------+------------------+------------------------------------+
```
