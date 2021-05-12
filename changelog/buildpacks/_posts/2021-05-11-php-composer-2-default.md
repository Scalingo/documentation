---
modified_at: 2021-05-11 10:00:00
title: 'PHP - Composer default version is 2.x'
github: 'https://github.com/Scalingo/php-buildpack'
---

Composer 1 is end of life since the 24th of October 2020. Starting today, Composer 2 is the new default for PHP applications. See [this announcement](https://blog.packagist.com/composer-2-0-is-now-available/#4-what-s-next) from Composer about the release of Composer 2.

If your application still requires Composer 1, you can select it by updating the `composer.json`:

```json
{
  "extra": {
    "paas": {
      "engines": {
        "composer": "1.x"
      }
    }
  }
}
```

More information in our [documentation page](https://doc.scalingo.com/languages/php/start#select-a-composer-version).
