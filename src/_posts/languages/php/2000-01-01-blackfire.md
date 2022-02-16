---
title: Setup Blackfire Agent on Scalingo
nav: Blackfire on Scalingo
modified_at: 2019-06-25 00:00:00
tags: php blackfire performance monitoring
index: 110
---

Blackfire is a SaaS solution to automate test about performance on PHP
application. You can refer to the [official website](https://blackfire.io) for
more information.

## Using Blackfire on Scalingo

Blackfire is part of Scalingo [PHP
buildpack](https://github.com/Scalingo/php-buildpack). To install the Blackfire
agent on your application, define both environment variables:

```
BLACKFIRE_SERVER_ID
BLACKFIRE_SERVER_TOKEN
```

The content of these variables is in Blackfire dashboard.

After defining these variables, redeploy your application for the changes to
take effect.
