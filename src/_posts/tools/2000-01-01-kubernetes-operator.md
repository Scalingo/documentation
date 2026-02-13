---
title: Scalingo Operator for Kubernetes®
nav: Kubernetes Operator
modified_at: 2026-02-13 00:00:00
tags: tools kubernetes operator
index: 3
---

## Scalingo Operator

[Kubernetes](https://kubernetes.io/) is an open-source container orchestration platform used to deploy, scale and operate applications.

Scalingo maintains a [Kubernetes Operator](https://github.com/Scalingo/scalingo-operator) that lets you manage Scalingo Dedicated Resources instances directly from a Kubernetes cluster.

{% note %}
The Scalingo Kubernetes Operator is currently in alpha, and we are actively extending its capabilities.
{% endnote %}

### Get started

To start using the Scalingo operator:

1. Create a Scalingo [API tokens]({% post_url platform/user-management/scalingo-account/2000-01-01-navigating %}#api-tokens) from your account settings
2. Export your credentials as Kubernetes Secrets
3. [Deploy the Operator](https://github.com/Scalingo/scalingo-operator/releases) using the `install.yaml` file

For the complete list of resources, details and examples, see the operator [documentation page](https://github.com/Scalingo/scalingo-operator).
