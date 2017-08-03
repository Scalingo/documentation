---
title: The X-Request-ID header
modified_at: 2017-06-08 00:00:00
category: management
tags: header internals reverse-proxy routing http
order: 50
---

The request ID represented in the HTTP header `X-Request-ID` let you to link
all the log lines which are common to a single web request.

## Definition of the `X-Request-ID` header

A unique request ID, represented by a UUID, is generated at each HTTP request
received by the platform routing servers. It is added to the request which is
passed to your application containers. The header is called `X-Request-ID`.

If the `X-Request-ID` header is already defined by the client, it won't be
overriden except if it doesn't respect the following format:

* 20-128 alphanumerical characters and the symbols `+`, `=`, `/` and `-`.

## Usage in your application

### Ruby on Rails

Rails is aware of the `X-Request-ID` header, you just have to configure the logger
to use it. Modify your `config/environment/production.rb` configuration file:

Before Rails 5.0

```ruby
config.log_tags = [ :uuid ]
```

After Rails 5.0:

```ruby
config.log_tags = [ :request_id ]
```

Then redeploy your application and you should see the IDs appearing for each request:

```
2017-05-31 18:42:30 [web-1] [7c129eb1-c479-47bb-9c73-d263e2673026] Started GET "/v1/apps/sample-go-martini/containers" for 62.99.220.106 at 2017-05-31 16:42:30 +0000
2017-05-31 18:42:30 [web-1] [7c129eb1-c479-47bb-9c73-d263e2673026] Processing by App::ContainersController#index as JSON
2017-05-31 18:42:30 [web-1] [7c129eb1-c479-47bb-9c73-d263e2673026]   Parameters: {"app_id"=>"sample-go-martini"}
2017-05-31 18:42:30 [web-1] [7c129eb1-c479-47bb-9c73-d263e2673026] Completed 200 OK in 8ms (Views: 1.1ms)
2017-05-31 18:42:30 [web-2] [7742c954-7534-4e76-8828-9e548908958d] Started GET "/v1/apps/sample-go-martini/containers" for 62.99.220.106 at 2017-05-31 16:42:30 +0000
2017-05-31 18:42:30 [web-2] [7742c954-7534-4e76-8828-9e548908958d] Processing by App::ContainersController#index as JSON
2017-05-31 18:42:30 [web-2] [7742c954-7534-4e76-8828-9e548908958d]   Parameters: {"app_id"=>"sample-go-martini"}
2017-05-31 18:42:30 [web-1] [9caa8d15-7851-41b0-91c4-512b34f20ea4] Started GET "/v1/apps/sample-go-martini/containers" for 62.99.220.106 at 2017-05-31 16:42:30 +0000
2017-05-31 18:42:30 [web-1] [9caa8d15-7851-41b0-91c4-512b34f20ea4] Processing by App::ContainersController#index as JSON
2017-05-31 18:42:30 [web-1] [9caa8d15-7851-41b0-91c4-512b34f20ea4]   Parameters: {"app_id"=>"sample-go-martini"}
2017-05-31 18:42:30 [web-2] [7742c954-7534-4e76-8828-9e548908958d] Completed 200 OK in 7ms (Views: 1.1ms)
2017-05-31 18:42:30 [web-1] [9caa8d15-7851-41b0-91c4-512b34f20ea4] Completed 200 OK in 7ms (Views: 0.9ms)
```

### Node.JS

The header will appear in the request object usually named `req` and you can access it the following way:

```javascript
req.headers['x-request-id']
```

If you're using the package `logfmt` it will be handled by default with its `requestLogger` middleware:

```javascript
app.use(logfmt.requestLogger({immediate: true}, logfmt.commonFormatter))
```

### Other languages

Each language should be able the header as it's a standard HTTP header. Don't hesitate to reach us
if you need help getting the header information.
