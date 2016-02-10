---
title: Configure Mongoid
modified_at: 2014-10-17 00:00:00
categories: languages ruby
tags: ruby mongoid mongodb
---

You need to create the file `config/mongoid.yml` in order to configure Mongoid.

```yaml
development:
  sessions:
    default:
      database: my-ruby-app
      hosts:
        - localhost:27017
production:
  sessions:
    default:
      uri: <%= ENV['SCALINGO_MONGO_URL'] %>
```

If you want to modify connection options or the connections pooling, you can
find all the information in the [official
documentation](http://mongoid.org/en/mongoid/docs/installation.html)

