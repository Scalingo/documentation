---
title:	'Logo URL in addon provider resource'
---

Details at [http://developers.scalingo.com#changelog](http://developers.scalingo.com#changelog)

The addon provider contained in the addon resource now contains the `logo_url` of the provider

```
{
  "addon": {
    // ...
    "addon_provider": {
      "id": "scalingo-redis",
      "name": "Scalingo Redis",
      "logo_url": "//storage.sbg1.cloud.ovh.net/v1/AUTH_be65d32d71a6435589a419eac98613f2/scalingo/redis.png"
    }
  }
}
```
