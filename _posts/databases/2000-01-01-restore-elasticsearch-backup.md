---
title: Restore locally an Elasticsearch backups
modified_at: 2016-04-27 00:00:00
category: databases
tags: elasticsearch backups databases
---

## Download the backup file

Go to your database dashboard, in the *Backups* tab and download the last dump
you want to restore locally.

The archive is a **.tar.gz** containing a dump of your database which has been
done with [Elasticsearch
Knapsack](https://github.com/jprante/elasticsearch-knapsack)

This is a plugin to handle dump and restore of Elasticsearch data, you need to install
it locally, please follow instructions on the *README* of the project.

## Restoring backup

**Knapsack** is expecting to find a file named `_all.tar.gz` in the directory `path.logs`
of Elasticsearch. This parameter can be set in your Elasticsearch configuration file, otherwise
it will be equivalent to `/`

Rename the downloaded file to `_all.tar.gz` and move it to the `path.logs` file of your installation:

```bash
$ mv 20160101010000-db-1234.tar.gz /_all.tar.gz
```

Then run the following curl command to trigger Knapsack importation:

```bash
$ curl -X POST http://localhost:9200/_import -d ''
{"running":true,"state":{"mode":"import","started":"2016-04-27T09:38:41.202Z","path":"file:///_all.tar.gz","node_name":"Miguel Espinosa"}}
```

That's it the importation has started, you can follow it by running a request against the state endpoint:

```bash
└> curl '172.17.0.2:9200/_import/state' -d ''
{"count":2,"states":[{"mode":"import","started":"2016-04-27T09:38:41.202Z","path":"file:///_all.tar.gz","node_name":"Miguel Espinosa"},{"mode":"import","started":"2016-04-27T09:40:11.889Z","path":"file:///_all.tar.gz","node_name":"Miguel Espinosa"}]}%   
```

Once ended, you'll have all your data locally.
