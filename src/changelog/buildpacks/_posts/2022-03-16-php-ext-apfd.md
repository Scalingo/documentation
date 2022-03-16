---
modified_at: 2022-03-16 10:00:00
title: 'PHP - Support of extention: apfd'
github: 'https://github.com/Scalingo/php-buildpack'
---

The PHP extension apfd is now available. It fixes a 10 years old [PHP bug](https://bugs.php.net/bug.php?id=55815) where data sent via PUT request is not parsed by PHP at all.

* [apfd documentation](https://mdref.m6w6.name/apfd)

Enable it like another extension in your `composer.json`:

```
{
  [...]
  "require": {
    "ext-apfd": "*",
    [...]
  }
}
```
