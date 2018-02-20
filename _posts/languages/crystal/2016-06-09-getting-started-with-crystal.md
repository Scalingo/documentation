---
title: Getting Started with Crystal
modified_at: 2016-06-09 00:00:00
category: getting-started
tags: crystal tutorial getting-started-tutorial
index: 13
permalink: /languages/crystal/getting-started-with-crystal/
---

{% include info_tutorial_requirements.md %}

## Initialize your application

```bash
$ crystal init app my-app
$ cd my-app
```

The `shard.yml` file declares the name of the project in his `name` field. This name will be used by
Scalingo to determine the main source file to compile: `./src/<NAME>.cr`. In this example, it will be
`./src/my-app.cr`.


## Write a base server file

The main file of this sample application is `src/my-app.cr`:

```ruby
require "http/server"

bind = "0.0.0.0"
port = 8080

server = HTTP::Server.new(bind, port) do |context|
  context.response.content_type = "text/plain"
  context.response << "Hello world, got #{context.request.path}"
end

puts "Listening on http://#{bind}:#{port}"
server.listen
```

To launch the web server type :

```bash
$ crystal src/my-app.cr
```

## Modify it for Scalingo

Here your server listen on `0.0.0.0:8080` but Scalingo need to configure the listening port in order
to deploy your app.

You must add a `--port` flag to set a custom listening port.

The `src/my-app.cr` file now looks like:

```ruby
require "http/server"
require "option_parser"

bind = "0.0.0.0"
port = 8080

OptionParser.parse! do |opts|
  opts.on("-p PORT", "--port PORT", "define port to run server") do |opt|
    port = opt.to_i
  end
end

server = HTTP::Server.new(bind, port) do |context|
  context.response.content_type = "text/plain"
  context.response << "Hello world, got #{context.request.path}"
end

puts "Listening on http://#{bind}:#{port}"
server.listen
```

## Commit your application

```bash
git init
git add .
git commit -m "Base Crystal application"
```

## Create your application on Scalingo and deploy

### Create your application

```bash
$ scalingo create my-app
```

### Specify a custom buildpack

Crystal is not natively supported by Scalingo. To deploy a Crystal code you should use a custom
buildpack.

```bash
$ scalingo --app my-app env-set BUILDPACK_URL=https://github.com/crystal-lang/heroku-buildpack-crystal.git
```

### Send your application to Scalingo
```bash
git push scalingo master
```

## Access your application

```bash
…
Waiting for your application to boot...
<-- https://my-app.scalingo.io -->
```


## Live demo

This application is currently running on Scalingo [here](http://sample-crystal.scalingo.io/).
