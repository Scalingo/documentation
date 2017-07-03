---
title: Access your Elasticsearch search engine
modified_at: 2014-11-25 00:00:00
categor: databases
tags: elasticsearch databases
index: 2
permalink: /databases/elasticsearch/access/
---

{% include info_command_line_tool.md %}

The difference between this data storage engine and the others is that Elasticsearch
communicates over HTTP, so you can use any tool built for that, you don't have to use
an official client. The most common command line tool is `curl`, the following example
is using it.

## Use `scalingo run`

```bash
scalingo -a <application name> run curl http://<user>:<password>@<host>:<port>
```

### Example

If my application's name is 'example' and it has the environment variable
`SCALINGO_ELASTICSEARCH_URL = "http://example-123:H_grwjqBteMMrVye442Zw6@example-123.elasticsearch.dbs.scalingo.com:30000/example-123"`

You can run:

```bash
$ scalingo -a example run curl $SCALINGO_ELASTICSEARCH_URL
{
  "status" : 200,
  "name" : "the Tomorrow Man Zarrko",
  "version" : {
    "number" : "1.3.4",
    "build_hash" : "a70f3ccb52200f8f2c87e9c370c6597448eb3e45",
    "build_timestamp" : "2014-09-30T09:07:17Z",
    "build_snapshot" : false,
    "lucene_version" : "4.9"
  },
  "tagline" : "You Know, for Search"
}
```
