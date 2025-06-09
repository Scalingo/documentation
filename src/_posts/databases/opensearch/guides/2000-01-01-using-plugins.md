---
title: Using OpenSearch® Plugins
nav: Using Plugins
modified_at: 2025-06-06 12:00:00
tags: database opensearch addon plugins
index: 30
---


OpenSearch® comes with a set of plugins that enhance the core platform by
adding extra features and functionality.

Scalingo supports most plugins bundled with the standard OpenSearch®
distribution, and also includes a curated set of additional, commonly used
plugins. All these plugins are installed, enabled, and ready to use out of the
box.

{% note %}
- Access provided by Scalingo does not allow you to install, remove, or modify
  plugins. If you require a plugin that is not currently available, feel free
  to contact our support team.
- The `opensearch-security` plugin is **not** included. Some features related
  to authentication, authorization, and fine-grained access control are not
  available. Please refer to the official OpenSearch® documentation for
  details.
{% endnote %}


## Available Plugins

### Native Plugins

| Plugin Name                                             | Description                                                                          |
| ------------------------------------------------------- | ------------------------------------------------------------------------------------ |
| [`opensearch-alerting`][alerting]                       | Triggers near real-time alerts based on thresholds, conditions or anomalies          |
| [`opensearch-anomaly-detection`][anomaly-detection]     | Detects unusual patterns across logs or metrics using RCF machine learning algorithm |
| [`opensearch-asynchronous-search`][asynchronous-search] | Runs search requests in background                                                   |
| [`opensearch-custom-codecs`][custom-codecs]             | Determines how the index's stored fields are compressed and stored on disk           |
| [`opensearch-flow-framework`][flow-framework]           | Aims at streamlining the OpenSearch app development experience through a drag-and-drop designer |
| [`opensearch-geospatial`][geospatial]                   | Searches fields that contain points and shapes on a map or coordinate plane          |
| [`opensearch-index-management`][index-management]       | Automates log index lifecycle operations                                             |
| [`opensearch-job-scheduler`][job-scheduler]             | Builds schedules for common tasks performed on your addon                            |
| [`opensearch-knn`][knn]                                 | Creates vector indexes                                                               |
| [`opensearch-ltr`][ltr]                                 | Uses machine learning and behavioral data to fine-tune the relevance of documents    |
| [`opensearch-ml`][ml]                                   | Support for machine learning                                                         |
| [`opensearch-neural-search`][neural-search]             | Transforms text into vectors and facilitates vector search                           |
| [`opensearch-notifications`][notifications]             | Provides a central location for all of your notifications from OpenSearch plugins    |
| [`opensearch-notifications-core`][notifications]        | Core plugin powering the notifications system                                        |
| [`opensearch-observability`][observability]             | Core plugin powering all observability-related plugins                               |
| [`opensearch-reports-scheduler`][reports-scheduler]     | Allows OpenSearch Dashboards to create PNG, PDF, and CSV reports                     |
| [`opensearch-skills`][skills]                           | Provides tools for ml-common's agent framework                                       |
| [`opensearch-sql`][sql]                                 | Allows users to write queries using SQL rather than the OpenSearch DSL               |
| [`opensearch-system-templates`][system-templates]       | System templates for cluster configuration                                           |
| [`query-insights`][queryinsights]                       | Provides comprehensive insights into search query execution                          |

### Additional Plugins

| Plugin Name                              | Description                                       |
| ---------------------------------------- | --------------------------------------------------|
| `analysis-icu`                           | Integrates [ICU][icu] analysis module             |
| `analysis-kuromoji`                      | Integrates Lucene's kuromoji analysis module      |
| `analysis-nori`                          | Integrates Lucene's nori analysis module          |
| `analysis-phonenumber`                   | Provides analyzers and tokenizers for parsing phone numbers |
| `analysis-phonetic`                      | Provides token filters which convert tokens to their phonetic representation |
| `analysis-smartcn`                       | Integrates Lucene's smart chinese analysis module |
| `analysis-stempel`                       | Integrates Lucene's Stempel analysis module for Polish |
| `analysis-ukrainian`                     | Integrates Lucene's Ukranian [Morfologik][morfologik] analyzer  |
| [`ingest-attachment`][ingest-attachment] | Extracts content and other information from files |
| `mapper-annotated-text`                  | Provides ability to index text that is a combination of free-text and special markup |
| `mapper-murmur3`                         | Provides ability to compute hash of field values at index-time and store them in the index |
| [`mapper-size`][mapper-size]             | Enables the use of the `_size` field in OpenSearch indexes |


[alerting]: https://docs.opensearch.org/docs/2.19/observing-your-data/alerting/index/
[anomaly-detection]: https://docs.opensearch.org/docs/2.19/observing-your-data/ad/index/
[asynchronous-search]: https://docs.opensearch.org/docs/2.19/search-plugins/async/index/
[custom-codecs]: https://docs.opensearch.org/docs/2.19/im-plugin/index-codecs/
[flow-framework]: https://github.com/opensearch-project/flow-framework
[geospatial]: https://docs.opensearch.org/docs/2.19/query-dsl/geo-and-xy/index/
[index-management]: https://docs.opensearch.org/docs/2.19/dashboards/im-dashboards/index/
[job-scheduler]: https://docs.opensearch.org/docs/2.19/monitoring-your-cluster/job-scheduler/index/
[knn]: https://docs.opensearch.org/docs/2.19/vector-search/creating-vector-index/
[ltr]: https://docs.opensearch.org/docs/2.19/search-plugins/ltr/index/
[ml]: https://docs.opensearch.org/docs/2.19/ml-commons-plugin/
[neural-search]: https://docs.opensearch.org/docs/2.19/vector-search/ai-search/index/
[notifications]: https://docs.opensearch.org/docs/2.19/observing-your-data/notifications/index/
[observability]: https://docs.opensearch.org/docs/2.19/observing-your-data/
[reports-scheduler]: https://docs.opensearch.org/docs/2.19/reporting/report-dashboard-index/
[skills]: https://github.com/opensearch-project/skills
[sql]: https://docs.opensearch.org/docs/2.19/search-plugins/sql/index/
[system-templates]: https://github.com/opensearch-project/opensearch-system-templates
[query-insights]: https://docs.opensearch.org/docs/2.19/observing-your-data/query-insights/index/

[icu]: https://icu.unicode.org/
[morfologik]: https://github.com/morfologik/morfologik-stemming
[ingest-attachment]: https://docs.opensearch.org/docs/2.19/install-and-configure/additional-plugins/ingest-attachment-plugin/
[mapper-size]: https://docs.opensearch.org/docs/2.19/install-and-configure/additional-plugins/mapper-size-plugin/
