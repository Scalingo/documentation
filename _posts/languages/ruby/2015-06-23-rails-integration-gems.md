---
title: Rails integration to the platform
modified_at: 2015-06-23 00:00:00
categories: languages ruby
tags: ruby application server rails
---

To completely integrate Ruby on Rails to the Scalingo platform, it has to
respect the [12-factor](http://12factor.net). These rules define how a web
application should ideally behaves. Scalingo is built around these principles
and you should respect them to be sure that your application will run correctly
on the platform.

## Required features

Two features are not enabled by default with Ruby on Rails:

* Logging on the standard output
* Serving static assets

Don't worry there is a gem for that:

```text
gem 'rails_12factor'
```

Add it to your `Gemfile` and your application will behave as expected.

## Logging on the standard output

The `rails_12factor` gem includes two gems, one of them is
`rails_stdout_logging`. Thanks to it, the application won't write the logs to
the `log/production.log` file but directly on the standard output.

### Why writing the logs to the standard output

It is a requirement to let the platform aggregate them and let you browse your
application logs in the dashboard or with Scalingo's command line interface.

## Serving static assets

The second gem included in `rails_12factor` is `rails_serve_static_asset`. It
includes a middleware provided by `sprocket` to serve static files located in
the `/public` directory of your project.

In a more traditional way to host a Ruby on Rails application, assets would not
be served by the application server, but by a proxy web server (Apache/Nginx
for instance), but you don't need that on Scalingo.

<aside class="note">
  Protip: use CDN to host your assets, it will spare your containers which will be used for more useful requests.
</aside>

