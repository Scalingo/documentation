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

To start using the Scalingo operator in your Kubernetes cluster:

1. [Deploy the Operator](https://github.com/Scalingo/scalingo-operator/releases) in your Kubernetes cluster using the `install.yaml` file
2. Create a Scalingo [API tokens]({% post_url platform/user-management/scalingo-account/2000-01-01-navigating %}#api-tokens) from your account settings
3. [Put the token in Kubernetes secret](https://github.com/Scalingo/scalingo-operator/blob/main/config/samples/databases_v1alpha1_postgresql.yaml)
4. Create your dedicated database custom resource, based on this [example](https://github.com/Scalingo/scalingo-operator/blob/main/config/samples/databases_v1alpha1_postgresql.yaml)
5. Apply the custom resource to deploy the dedicated database

For the complete list of resources, details and examples, see the operator [documentation page](https://github.com/Scalingo/scalingo-operator).
