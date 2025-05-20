---
title: Managing Logs Lifecycle
nav: Managing Logs Lifecycle
modified_at: 2025-05-19 12:00:00
tags: opensearch logs lifecycle
index: 50
---


Managing the lifecycle of your logs is crucial for several reasons, especially
when dealing with large or production-grade systems. Logs can indeed grow quite
rapidly over time. Without an appropriate lifecycle management, they can
consume significant storage space, which leads to degraded performances, and
slow operations. Rotating and archiving old logs ensures the visualization
tools only access recent and relevant logs, keeping search and information
retrieval fast and efficient.

Managing the lifecycle of your logs can also help you comply with regulations
and legal obligations (e.g. GDPR, HIPAA, etc.). The automated process can help
retain and delete logs depending on their age, allowing you to stay compliant.

All these elements are also true when storing logs in an OpenSearch® database.
Hopefully, OpenSearch® features [all the necessary][ism] to implement a logs
lifecycle policy.

The following example implements a log management policy based on three states:
`hot`, `cold` and `delete`. The policy initially stores the index in an `hot`
state. After 10 days of retention, the index is moved to another state called
`cold`, where the number of replicas is lowered to 1. The index and its content
are still available for long-term access. Once the index is two years old, it's
finally moved to the `delete` state, and OpenSearch® deletes it permanently.

Here a small schema describing the policy:

{% assign img_url = "https://cdn.scalingo.com/documentation/diagram_documentation_logs_lifecycle.png" %}
{% include mdl_img.html %}

And the HTTP request creating it:

```json
PUT _plugins/_ism/policies/logs_policy
{
  "policy": {
    "description": "Logs Lifecycle Management (hot, cold, delete)",
    "schema_version": 1,
    "ism_template": {
      "index_patterns": ["log*"],
      "priority": 100
    },
    "default_state": "hot",
    "states": [
      {
        "name": "hot",
        "actions": [
          {
            "rollover": {
              "min_index_age": "5d",
            }
          }
        ],
        "transitions": [
          {
            "state_name": "cold",
            "conditions": {
              "min_rollover_age": "10d"
            }
          }
        ]
      },
      {
        "name": "cold",
        "actions": [
          {
            "replica_count": {
              "number_of_replicas": 1
            }
          }
        ],
        "transitions": [
          {
            "state_name": "delete",
            "conditions": {
              "min_index_age": "2y"
            }
          }
        ]
      },
      {
        "name": "delete",
        "actions": [
          {
            "delete": {}
          }
        ]
      }
    ]
  }
}
```


[ism]: {% post_url databases/opensearch/guides/2000-01-01-managing-indexes %}#implementing-index-state-management
