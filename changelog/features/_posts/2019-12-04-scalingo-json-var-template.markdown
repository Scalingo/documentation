---
modified_at:	2019-12-04 10:00:00
title:	'JSON Manifest: Generate env from template'
---

You can now use the `template` generator to defined environment variable in the `scalingo.json` file.

Documentation: [https://developers.scalingo.com/scalingo-json-schema/index](https://developers.scalingo.com/scalingo-json-schema/index)

```json
{
  "env": {
    "MY_VARIABLE":  {
     "generator": "template",
     "template": "pr-%PR_NUMBER%"
    }
  }
}
```

The different template tokens are:

- `APP`: Name of the current review app
- `PARENT_APP`: Name of the parent app
- `PR_NUMBER` Number of the Pull Request (GitHub) or Merge Request (Gitlab)
