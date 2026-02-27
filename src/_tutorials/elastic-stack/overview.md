---
title: Overview
category: analytics
products:
  - Scalingo for Elasticsearch®
  - Multi-buildpack
logo: elastic-stack
is_series: true
series: Deploying an Elastic Stack
series_index: 1
modified_at: 2026-02-23
---

The Elastic Stack (formerly known as the ELK Stack) is a powerful collection of
softwares that lets you collect data from any source using any format. It gives
you tools to search, visualize and analyze these data in real time.

The Elastick Stack is based on three major components: **Elasticsearch**®,
**Logstash** and **Kibana**.

Here is a diagram showing the main principles of the stack architecture:

{% assign img_url = "https://cdn.scalingo.com/documentation/diagram_documentation_elk_stack.svg" %}
{% include mdl_img.html %}


## Planning your Deployment

- Because most of the time, logs are only relevant for a short period of time,
  it is generally a good idea to archive or remove them after this short period
  to keep indices as light and fast as possible.

  To cover this need, we suggest to add a fourth component named **Curator** to
  your Elastic Stack.

- Logstash and Kibana both require their own container(s). We will consequently
  need two apps.

- We will deploy Elasticsearch as an addon attached to Logstash.

- We will deploy Curator alongside Logstash, in the same container.

- Logstash requires quite a lot of RAM to run properly. We recommend to deploy
  at least one L container to host it.

- Choosing the appropriate Elasticsearch plan strongly depends on your needs.
  In this guide, we will start with the smallest plan we provide: a Starter
  512M plan.

  Note that Elasticsearch can become quite greedy memory-wise: indexing,
  aggregating, and heavy read workloads with caching enabled can have a
  significant impact on your database performances. To reduce the JVM heap
  pressure, and to lower the need of garbage collection, you may want to switch
  for a more powerful plan.

{% warning %}
Due to [Elasticsearch license change][elastic-license], we are currently unable
to provide versions of Elasticsearch higher than `7.10.2`.\\
Consequently, and according to the [compatibility matrix][elastic-compat]
provided by Elastic.co, we strongly advise to stick to these versions:

| App      | Min. Version | Max. Version | Default  |
| -------- | -----------: | -----------: | -------: |
| Logstash | `6.8.0`      | `7.17.29`    | `7.17.29` |
| Kibana   | `7.10.0`     | `7.10.2`     | `7.10.2` |
| Curator  | `7.0.0`      | `7.0.1`      | `7.0.1`  |

Using our repos guaranteed that these constraints are respected.
{% endwarning %}


## Deploying

Please refer to our dedicated pages:

- To [deploy Elasticsearch® and Logstash][deploy-logstash]
- To [deploy Kibana][deploy-kibana]
- To [deploy Curator][deploy-curator]
- To learn more about [Elasticsearch® by Scalingo][elasticsearch]


*[ELK]: Elasticsearch Logstash Kibana
*[JVM]: Java Virtual Machine

[elastic-license]: https://www.elastic.co/fr/pricing/faq/licensing
[elastic-compat]: https://www.elastic.co/fr/support/matrix#matrix_compatibility

[deploy-logstash]: {% link _tutorials/elastic-stack/logstash.md %}
[deploy-kibana]: {% link _tutorials/elastic-stack/kibana.md %}
[deploy-curator]: {% link _tutorials/elastic-stack/curator.md %}

[elasticsearch]: {% post_url databases/elasticsearch/2000-01-01-start %}

