---
modified_at: 2021-05-11 12:00:00
title: 'PHP - Add support for New Relic with PHP 8'
github: 'https://github.com/Scalingo/php-buildpack'
---

New Relic support with PHP 8 has been added.

To enable it, add the following requirement in your `composer.json`:

```
{
  "extra": {
    "paas": {
      "new-relic": "true"
    }
  }
}
```
