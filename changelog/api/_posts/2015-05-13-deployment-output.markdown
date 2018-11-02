---
title:	'Add hyperlink `output` to deployment'
---

Details at [http://developers.scalingo.com#changelog](http://developers.scalingo.com#changelog)

New object `links` in deployment JSON, including a `output` URL

```
{
   // ...
   "links": {
      "output": "https://api.scalingo.com/v1/apps/example-app/deployments/123e4567-e89b-12d3-a456-426655440000/output"
   }
}
```
