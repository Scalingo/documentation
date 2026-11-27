---
title: Data Reversibility
modified_at: 2026-11-27 00:00:00
---

You can export your data and key configuration settings directly from your
Scalingo account at any time while you have access to the relevant services.
The self-service export tools included in your Scalingo plans and addons carry
no separate export fee. Scalingo does not charge a fee for switching providers.

For a custom export, contact [Scalingo support][support]. If you request
additional work, such as an export in a specific format, at a scheduled time, or
from a copy of your data, we may offer a paid service and share a quote in advance.

Export all your data and configuration settings before deleting your resources or
your Scalingo account. Deleting your account ends self-service access to your
data. After the contract ends, you can request the return of your data in writing
during the applicable retention period. See Article 10 of the [General Terms and
Conditions][gtc].

## Managed Application Runtime

You are responsible for keeping your application source code in your own source
control repository. Use that repository to retrieve the code you deploy to Scalingo.

On `osc-fr1`, you can download the Docker image built by Scalingo for a successful
deployment with the paid [Scalingo Docker Image addon][docker-image].

Use the Scalingo API or CLI to retrieve your application configuration and operational data.

| Data | How to retrieve it |
| ---- | ------------------ |
| Activity history | [List application events with the API][app-events]. |
| Recent application logs | [Retrieve logs with the CLI or download log archives][app-logs]. |
| Deployment logs | [Retrieve the output of a deployment with the API][deployment-logs]. |
| Recent application metrics | [Retrieve metrics with the API][app-metrics]. |
| Environment variables | [List variable names and values with the API][app-environment]. |

## Managed Database

Download a managed backup where available, or export directly from the database
with a tool for its engine. The available methods depend on the engine, plan,
and architecture model.

| Database engine | Export method |
| --------------- | ------------- |
| PostgreSQL® | Download a backup on [Shared Resources][postgresql-download]. Use `pg_dump` on [Shared Resources][postgresql-shared-dump] or [Dedicated Resources][postgresql-dedicated-dump]. |
| MySQL® | Download a backup on [Shared Resources][mysql-download]. Use `mysqldump` on [Shared Resources][mysql-shared-dump] or [Dedicated Resources][mysql-dedicated-dump]. |
| MongoDB® | [Download a managed backup][mongodb-download] or [export with `mongodump`][mongodb-dump]. |
| Redis® OSS (Scalingo for Caching) | [Download a managed backup][redis-download] or [export with `redis-cli --rdb`][redis-dump]. |
| Valkey® | Use [Valkey CLI][valkey-cli] to export data from the engine. `valkey-cli --rdb` requires access to replication commands. |
| InfluxDB® | [Download a managed backup from the database dashboard][influxdb-download]. |
| OpenSearch® and Elasticsearch® | [Export indexes with `elasticdump` or `multielasticdump`][opensearch-dump]. |

Use the Database API to retrieve [recent logs][database-logs] and [metrics][database-metrics].

[support]: https://scalingo.com/contact
[gtc]: https://scalingo.com/general-terms-and-conditions
[docker-image]: {% post_url addons/scalingo-docker-image/2000-01-01-start %}
[app-events]: https://developers.scalingo.com/events.html
[app-logs]: {% post_url platform/app/2000-01-01-logs %}
[deployment-logs]: https://developers.scalingo.com/deployments
[app-metrics]: https://developers.scalingo.com/apps#get-metrics-data-of-an-application
[app-environment]: https://developers.scalingo.com/environment
[postgresql-download]: {% post_url databases/postgresql/shared-resources/guides/2000-01-01-backing-up %}#downloading-a-scheduled-backup
[postgresql-shared-dump]: {% post_url databases/postgresql/shared-resources/guides/2000-01-01-backing-up %}#dumping-the-database
[postgresql-dedicated-dump]: {% post_url databases/postgresql/dedicated-resources/guides/2000-01-01-backing-up %}#dumping-the-database
[mysql-download]: {% post_url databases/mysql/shared-resources/guides/2000-01-01-backing-up %}#downloading-a-periodic-backup
[mysql-shared-dump]: {% post_url databases/mysql/shared-resources/guides/2000-01-01-backing-up %}#dumping-the-database
[mysql-dedicated-dump]: {% post_url databases/mysql/dedicated-resources/guides/2000-01-01-backing-up %}#dumping-the-database
[mongodb-download]: {% post_url databases/mongodb/2000-01-01-start %}#download-automated-backups
[mongodb-dump]: {% post_url databases/mongodb/2000-01-01-dump-restore %}
[redis-download]: {% post_url databases/redis/2000-01-01-start %}#downloading-a-backup
[redis-dump]: {% post_url databases/redis/2000-01-01-dump-restore %}
[valkey-cli]: https://valkey.io/topics/cli/#remote-backups-of-rdb-files
[influxdb-download]: {% post_url databases/influxdb/2000-01-01-dump-restore %}#restore-on-your-local-workstation
[opensearch-dump]: {% post_url databases/opensearch/guides/2000-01-01-backing-up %}#dumping-indexes
[database-logs]: https://developers.scalingo.com/databases/logs
[database-metrics]: https://developers.scalingo.com/databases/metrics
