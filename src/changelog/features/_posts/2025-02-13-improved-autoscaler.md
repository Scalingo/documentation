---
modified_at: 2025-02-13 06:00:00
title: 'Autoscaling Improvements - Enhanced responsiveness to traffic variations'
---

We have improved the [Autoscaler]({% post_url platform/app/2000-01-01-autoscaler %}) feature to enhance responsiveness and resource efficiency.  


What’s new?
- **UI Update**: simplified configuration for easier setup
- **Faster adjustments**: improved reaction time when using the **"RPM per container"** metric
- **Documentation update**: more detailed guidance for using the Autoscaler via the Dashboard, CLI, and Terraform


When using the **RPM per container** metric, the Autoscaler can now **add multiple containers per decision round**, significantly improving scaling speed. The maximum container limit is still enforced.  


[Read the updated documentation]({% post_url platform/app/2000-01-01-autoscaler %})
