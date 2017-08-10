---
title:  When my app doesn't work
modified_at: 2017-08-09 14:00:00
category: getting-started
tags: application
order: 2
---

# When my app doesn't work
> “Never trust a computer you can’t throw out a window.”
> (Steve Wozniak)

We know that how it's painful to have issues on production.

## The procedure

We will try to help with few advices

### Find the problem

1. Have you check your tests units ?

2. Does it run locally ?

3. Have you check the log on your [dashboard](https://my.scalingo.com/apps) ?

### Solve it

1. Have you check our [documentation](doc.scalingo.com) ? It possible that's your problem is already solved

2. Have you search on the internet ? Perhaps, someone had solved it.

3. Contact us in our plateform support on our [dashboard](https://my.scalingo.com/apps) or send us an [email](support@scalingo.com), it will be a pleasure to help you.

## Frequently Asked Questions

### My app is crashed but it runs fine locally and no errors are displayed on logs
Have you check the memory usage of your application ?

Check the metrics, it commons to have some problem due to a leak of memory from an application or the size of the container.
