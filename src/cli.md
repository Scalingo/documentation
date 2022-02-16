---
layout: default_with_main_article
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

<h1 class="text-sc-gray-1 text-sc-title-1 font-bold mb-12">{{ page.title }}</h1>

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

<ul class='flex flex-row flex-wrap list-unstyled gap-x-8'>
  {% for os in page.oses %}
    <li class='flex flex-row'>
      <div class="flex flex-row items-center">
        <span class="h-5 w-5 mr-2">{% icon {{ os | downcase }} %}</span>
        {{ os }}
      </div>
    </li>
  {% endfor %}
</ul>

For each of these operating systems, you can download
[a precompiled binary](https://github.com/Scalingo/cli/releases).

The client is developed with Go. Therefore, there is no external dependency.
