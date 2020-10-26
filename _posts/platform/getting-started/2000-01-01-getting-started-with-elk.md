---
title: Getting started with the ELK Stack on Scalingo
modified_at: 2020-10-26 00:00:00
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
$ scalingo create my-awesome-logstash
```

Add the Elasticsearch addon to this application:

```bash
$ scalingo --app my-awesome-logstash addons-add elasticsearch elasticsearch-starter-1024
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
$ curl --request POST 'https://my-awesome-logstash-user:iloveunicorns@my-awesome-logstash.osc-fr1.scalingo.io?name=Alanala' --data 'Hi!'
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
Scalingo](https://cdn.scalingo.com/deploy/button.svg)](https://my.osc-fr1.scalingo.com/deploy?source=https%3A%2F%2Fgithub.com%2FScalingo%2Fkibana-scalingo)

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
exploration. If you've set up your ELK stack for this, we have a feature called
**log drains** that will automatically send every log line generated by an
application to an ELK stack. Here is [how to add a log drain]({% post_url
platform/app/2000-01-01-log-drain %}) to your application.

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

## Curator

### Installing Curator

Since logs are only relevant for a short period of time, it is current
practice to remove logs that are too old to be relevant. This is done to
reduce the load on the database and limit the disk usage.

This is where
[Curator](https://www.elastic.co/guide/en/elasticsearch/client/curator/5.8/index.html)
is needed. This project is designed to let you manage your indices life cycle.

Curator is written in Python. In order to install its dependencies, you
can modify the `.buildpacks` file to also contain the Python buildpack. The
`.buildpacks` file should have the following content:

```
https://github.com/Scalingo/buildpack-jvm-common.git
https://github.com/Scalingo/python-buildpack.git
https://github.com/Scalingo/logstash-buildpack.git
```

In order to instruct the Python buildpack to install Curator and its
dependencies, create a file named `requirements.txt` at the root of your
project:

```
PyYAML==5.3.1
elasticsearch-curator==5.8.0
```


Curator is not a deamon, it is designed as a one-off process. To be able
to run it on Scalingo you need to write a Bash script that executes
Curator regularly.
Create a file named `curator.sh` with the following content:

```bash
#!/bin/bash
set -ex

while true; do
  echo "Running Curator"
  curator --config curator.yml log-clean.yml
  # Run Curator every 12h
  sleep 43200
done
```

Finally you need to instruct Scalingo to start Curator.
This can be achieved by adding the following line to your `Procfile`:

```yaml
curator: ./curator.sh
```

### Configuration

All the hard stuff is now done.

Next step is to configure Curator. First you need to configure how Curator
connects to your database:

```
---
client:
  hosts:
    - ${ELASTICSEARCH_HOST}
  http_auth: ${ELASTICSEARCH_AUTH}
logging:
  loglevel: INFO
  logfile:
  logformat: default
```

Curator cannot use the `ELASTICSEARCH_URL` environment variable. You
need to define two other environment variables on your app, duplicating
`ELASTICSEARCH_URL` content.
Hence if your `ELASTICSEARCH_URL` variable is set to
`http://user:password@host:port`, you need to define 2 environment variables:

```
ELASTICSEARCH_HOST=host:port
ELASTICSEARCH_AUTH=user:password
```

The last step is to configure your indices life cycle. This is based on your
indices names.
Create a file named `log-clean.yml`. This configuration parses the indices
names stored in Elasticsearch and removes the ones that are too old.

```yaml
actions:
  1:
    action: delete_indices
    description: Delete old log indices
    options:
      ignore_empty_list: True
      disable_action: False
    filters:
    - filtertype: pattern
      kind: prefix
      value: ${LOGS_INDICES_PREFIX}
    - filtertype: age
      source: name
      direction: older
      timestring: '%Y.%m.%d'
      unit: days
      unit_count: ${LOGS_RETENTION_DAYS}
```

You now need to add two environment variables:

```
LOGS_INDICES_PREFIX=sc-apps
LOGS_RETENTION_DAYS=10
```

The first environment variable is `LOGS_INDICES_PREFIX`. It configures the
index pattern that should be affected by this policy. Setting this variable
to `sc-apps` prevent Curator from deleting the other indices that are stored
in the same database.

The second environment variable is `LOGS_RETENTION_DAYS`. It configures
the retention time of your logs (in days). Setting this variable to `10`,
Curator will delete an index if it is 10+ days old.

That's all folks!

This tutorial is based on an article published on [our
blog](https://scalingo.com/articles/2018/02/23/running-the-elk-stack-on-scalingo.html).
