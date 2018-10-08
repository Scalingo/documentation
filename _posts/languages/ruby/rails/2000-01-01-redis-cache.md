---
title: Redis as Cache Engine
modified_at: 2018-10-08 00:00:00
tags: ruby rails databases redis cache
---

The Redis database is often use for cache purpose. Hence you might need to clear its content after
each deployment. One solution could be to empty it in a [postdeploy hook]({% post_url
platform/app/2000-01-01-postdeploy-hook %}). Another solution can be to prefix the cache key with
the build deployment ID.

The deployment ID is available in the `SOURCE_VERSION` during the build phase and
`CONTAINER_VERSION` at runtime. More information about these [variables]({% post_url
platform/app/2000-01-01-environment %}).

With Ruby on Rails, configuring such cache is done using this single line:

```rails
config.cache_store = :redis_store, "#{ ENV['SCALINGO_REDIS_URL'] }/0/cache:#{ ENV['SOURCE_VERSION'] || ENV['CONTAINER_VERSION'] }", {expires_in: 1.hour}
```
