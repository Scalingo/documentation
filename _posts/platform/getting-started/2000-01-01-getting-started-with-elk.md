---
title: Getting started with the ELK Stack on Scalingo
modified_at: 2018-10-05 14:21:00
tags: elk tutorial logstash elasticsearch kibana log
index: 11
---

The Elastic Stack (formerly known as the ELK Stack) is a powerful collection of
softwares that lets you collect data from any source using any format. It gives
you the tools to search, visualize and analyze it in real time.

This tutorial will show you how to deploy the ELK stack on Scalingo in under 5
minutes.

## What is the ELK Stack?

The ELK stack is based on three major components:

* Elasticsearch
* Logstash
* Kibana

**Elasticsearch** is a distributed full-text search engine, able to store JSON
document and index them efficiently, it is responsible for the storage of all
the incoming data.

**Logstash** is a data processing pipeline, any source sends data as input. It
is able to format and modify data on the fly before forwarding it to
the chosen destination (usually an Elasticsearch database).

**Kibana** is a powerful web-based data visualization tool providing
everything you need to explore your data and build useful and efficient
dashboards.

## Logstash

Let's start by bootstrapping the Logstash container. This instance will take
data from an authenticated input and send them to an Elasticsearch
database. This is the *EL* part in *ELK*.

To get started, you can use [our boilerplate](https://github.com/Scalingo/logstash-boilerplate):

```bash
$ git clone https://github.com/Scalingo/logstash-boilerplate
$ cd logstash-boilerplate
```

Next, create an application on Scalingo that will run our Logstash app:

```bash
$ scalingo create my-awesome-logstash --buildpack https://github.com/Scalingo/multi-buildpack.git
```

Add the Elasticsearch addon to this application:

```bash
$ scalingo --app my-awesome-logstash addons-add scalingo-elasticsearch elasticsearch-starter-1024
```

All the Elasticsearch plans are described [here](https://scalingo.com/addons/scalingo-elasticsearch).

Of course, not everyone should be able to send data to your Logstash instance, it should be
protected via HTTP basic auth. It is already handled in the boilerplate but the
environment variables `USER` and `PASSWORD` should be set first:

```bash
$ scalingo --app my-awesome-logstash env-set USER=my-awesome-logstash-user PASSWORD=iloveunicorns
```

Edit the `logstash.conf` file to change the index name of the Elasticsearch
output. The goal is to make it fit semantically to the data which will be
stored:

```
output {
  elasticsearch {
    [...]
    # OLD
    index => "change-me-%{+YYYY.MM.dd}"
    # NEW
    index => "unicorns-%{+YYYY.MM.dd}"
  }
}
```

Commit your changes

```bash
$ git add logstash.conf
$ git commit -m "Update the index name"
```

And you're all set, `git push scalingo master` and your Logstash instance
will be up and running!

You can now try to send some data to your Logstash instance:

```bash
$ curl --request POST 'http://my-awesome-logstash-user:iloveunicorns@my-awesome-logstash.osc-fr1.scalingo.io?name=Alanala' --data 'Hi!'
ok
```

It's time to verify all the indices that are stored in the Elasticsearch
database:

```bash
$ scalingo --app my-awesome-logstash run bash

> curl $SCALINGO_ELASTICSEARCH_URL/_cat/indices
yellow open unicorns-2018.01.26 _0XNpJKzQc2kjhTyxf4DnQ 5 1 1 0 6.6kb 6.6kb
```

Logstash has created the unicorn index which can now be requested:

```
> curl $SCALINGO_ELASTICSEARCH_URL/unicorns-2018.01.26/_search | json_pp
{
   "_shards" : {
    // [...]
   },
   // [...]
   "hits" : {
      "total" : 1,
      "max_score" : 1,
      "hits" : [
         {
            "_type" : "logs",
            "_score" : 1,
            "_source" : {
               "name" : "Alanala",
               "message" : "Hi!",
               "url" : "?name=Alanala",
               "@timestamp" : "2018-01-26T11:57:03.155Z"
               // [...]
            },
            // [...]
         }
      ]
   }
}
```

The result of the above search contains a document having with a field `name`
set to `Alenala` and a field `message` set to `Hi!`.


## Kibana

To deploy Kibana on Scalingo, you are invited to use our one-click button
over here: [![Deploy on
Scalingo](https://cdn.scalingo.com/deploy/button.svg)](https://my.scalingo.com/deploy?source=https://github.com/Scalingo/kibana-scalingo)

The `ELASTICSEARCH_URL` environment variable from the previously created
Logstash application should be used in the deployment process:

```
scalingo --app my-awesome-logstash env | grep SCALINGO_ELASTICSEARCH_URL
```

Then, a username and a password should be defined to configure Kibana authentication.

Once deployed, index patterns need to be configured. This is required to inform
Kibana about the indices of Elasticsearch it need to look at.

{% assign img_url = "https://cdn.scalingo.com/documentation/elk/index-creation.png"%}
{% include mdl_img.html %}

In this example, the `unicorns-*` pattern will be used.

Click on create and you're all set, the test input done in the previous section
should appear in the Discover tab of Kibana dashboard.

{% assign img_url = "https://cdn.scalingo.com/documentation/elk/success.png" %}
{% include mdl_img.html %}

## Send your application logs to your own ELK stack

One of the multiple usages of the ELK stack is log parsing, storing and
exploration. If you've set up your ELK stack for this, we have a beta feature
called **LOG DRAINS** that will automatically send every log line generated by
an application to an ELK stack. If you're interested by this kind of feature,
contact the Scalingo team via the in-chat support or via email at
[support@scalingo.com](mailto:support@scalingo.com).

When using this configuration, the application name and container index will be
passed in the http query and the message will be in the request body. To parse
this and create meaningful index, you can use the following configuration (if
your logs are JSON formatted):

```
input {
  http {
    port => "${PORT}"
    user => "${USER}"
    password => "${PASSWORD}"
  }
}

filter {
  grok {
    match => [ "[headers][request_uri]", "%{URIPARAM:url}" ]
    remove_field => ["headers"]
  }

  kv {
    source => "url"
    field_split => "&"
    trim_key => "?"
  }

  mutate {
    rename => {
      "appname" => "source"
      "hostname" => "container"
    }
    replace => {
      "host" => "%{source}-%{container}"
    }
  }

  json {
    source => "message"
    target => "msg"
  }
}

output {
  elasticsearch {
    hosts => "${ELASTICSEARCH_HOST}"
    user => "${ELASTICSEARCH_USER}"
    password => "${ELASTICSEARCH_PASSWORD}"
    index => "sc-apps-%{+YYYY.MM.dd}"
  }
}
```

This tutorial is based on an article published on [our
blog](https://scalingo.com/articles/2018/02/23/running-the-elk-stack-on-scalingo.html).
