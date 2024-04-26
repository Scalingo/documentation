---
modified_at: 2023-04-26 15:00:00
title: "New Parameter for Domains: letsencrypt_enabled"
---

The Domain resource has been updated. The parameter `letsencrypt_enabled` allows
you to control either the platform will try or not to generate a Let's Encrypt
certificate. Default value is `true` if parameter is absent.

`POST https://$SCALINGO_API_URL/apps/:app_id/domains`
`PATCH https://$SCALINGO_API_URL/apps/:app_id/domains/:domain_id`

```
{
  "domain": {
    "name": "www.example.com",
    "letsencrypt_enabled": false
  }
}
```

More information in the [developers' documentation](https://developers.scalingo.com/domains).
