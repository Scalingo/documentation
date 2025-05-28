---
title: Using OpenSearch® Plugins
nav: Using Plugins
modified_at: 2025-05-21 12:00:00
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

{% note %}
The following list is a work in progress.
{% endnote %}

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


[icu]: https://icu.unicode.org/
[morfologik]: https://github.com/morfologik/morfologik-stemming
[ingest-attachment]: https://docs.opensearch.org/docs/2.19/install-and-configure/additional-plugins/ingest-attachment-plugin/
[mapper-size]: https://docs.opensearch.org/docs/2.19/install-and-configure/additional-plugins/mapper-size-plugin/
