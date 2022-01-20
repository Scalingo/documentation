---
layout: default_with_only_main
title: Command Line Tool
subnav_index: 2
description: Interact with Scalingo's Platform as a Service from your command line.
modified_at: 2015-09-09 00:00:00
oses:
  - Linux
  - MacOS
  - Windows
  - FreeBSD
  - OpenBSD
---

# {{ page.title }}

{{ page.description }}

## Installation

Just copy/paste the command below in your terminal and execute it.

<div class="page-content" markdown="1">
```console
curl -O https://cli-dl.scalingo.io/install && bash install
```
</div>

## Documentation and features

Read everything in our [Documentation Center](/platform/cli/features).

## Changelog

Complete changelog is available [here](/changelog).

## Supported operating systems

<ul class='list-inline mb-0'>
  {% for os in page.oses %}
    <li class='list-inline-item mr-3 my-3'>
      <div class="mdc-typography--title">
        {% icon {{ os | downcase }} %}
        {{ os }}
      </div>
    </li>
  {% endfor %}
</ul>

For each of these operating systems, you can download
[a precompiled binary](https://github.com/Scalingo/cli/releases).

The client is developed with Go. Therefore, there is no external dependency.
