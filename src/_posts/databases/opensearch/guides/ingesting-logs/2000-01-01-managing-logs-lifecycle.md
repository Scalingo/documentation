---
title: Managing Logs Lifecycle
nav: Managing Logs Lifecycle
modified_at: 2025-05-19 12:00:00
tags: opensearch logs lifecycle
index: 50
---


Managing the 



{% assign img_url = "https://cdn.scalingo.com/documentation/diagram_documentation_logs_lifecycle.png" %}
{% include mdl_img.html %}

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
              "min_index_age": "10d",
              "min_primary_shard_size": "30gb"
            }
          }
        ],
        "transitions": [
            { "state_name": "cold" }
        ]
      },
      {
        "name": "cold",
        "actions": [
          { 
            "replica_count": {
              "number_of_replicas": 1
            }
          },
          {
            "allocation": {
              "require": {
                "temp": "warm"
              }
            }
          }
        ],
        "transitions": [
          {
            "state_name": "delete",
            "conditions": { "min_index_age": "2y" }
          }
        ]
      },
      {
        "name": "delete",
        "actions": [
          { "delete": {} }
        ]
      }
    ]
  }
}
```
