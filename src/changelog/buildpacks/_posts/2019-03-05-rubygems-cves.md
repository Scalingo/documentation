---
modified_at:	2019-03-05 09:30:00
title:	'Ruby - Version 2.4.5, 2.5.3 and 2.6.1 patched against RubyGems CVEs'
---

[March 2019 RubyGems Security Advisory](https://blog.rubygems.org/2019/03/05/security-advisories-2019-03.html)

The following CVEs are patched:

* CVE-2019-8320
* CVE-2019-8321
* CVE-2019-8322
* CVE-2019-8323
* CVE-2019-8324
* CVE-2019-8325

Deploying this fix requires a deployment, to trigger
a deployment without code modification you can use:

```
git commit --allow-empty -m "Empty deployment to patch RubyGems"
git push scalingo master
```

If you're using an older version of Ruby,
RubyGems has not been patched and you need to
manually upgrade to one of those maintained
versions.
