---
modified_at: 2020-10-01 10:00:00
title: 'PHP - Support of native extention: intl (Internationalization)'
github: 'https://github.com/Scalingo/php-buildpack'
---

The native PHP extension for internationalization is now available.

* [intl documentation](https://www.php.net/manual/en/book.intl.php)

Enable it like another extension in your `composer.json`:

```
{
  [...]
  "require": {
    "ext-intl": "*",
    [...]
  }
}
```
