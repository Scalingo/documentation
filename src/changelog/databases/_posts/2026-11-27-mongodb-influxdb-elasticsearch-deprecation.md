---
modified_at: 2026-11-27 00:00:00
title: 'Deprecation of Scalingo for MongoDB®, Scalingo for InfluxDB®, and Scalingo for Elasticsearch®'
---

We are deprecating Scalingo for MongoDB®, Scalingo for InfluxDB®, and Scalingo
for Elasticsearch®.

Starting November 27, 2026, you can provision one of these services through
self-service only if you already own an application that uses that service.

**Existing instances continue to run. Scalingo continues to manage and support
them.**

{% warning %}
These services run older database versions that no longer receive fixes from
their vendors. We recommend migrating to a fully supported solution that
receives regular updates.
{% endwarning %}

For new deployments, use [Scalingo for OpenSearch®][opensearch] for search and
analytics. For time-series workloads, consider PostgreSQL® with the
[TimescaleDB® extension][timescaledb].

If you still need access to one of these services, contact Scalingo Support.
We review access requests on a case-by-case basis.

[opensearch]: {% post_url databases/opensearch/about/2000-01-01-overview %}
[timescaledb]: {% post_url databases/postgresql/extensions/2000-01-01-timescaledb %}
