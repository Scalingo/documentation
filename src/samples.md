---
layout: default
title: Samples
subnav_index: 1
description: Here is a list of samples built with various technologies than you can deploy by yourself and take inspiration of.
modified_at: 2015-09-09 00:00:00
---

<div class="max-w-sc-content-1532 container mx-auto">


<div class="bg-sc-gray-5 rounded-lg mt-6 p-10">
  <h1 class="text-sc-title-1-1 text-sc-gray-1 font-bold">{{ page.title }} 2</h1>
  <p class="mt-4">{{ page.description }}</p>
</div>

<div class="grid grid-cols-5 gap-6 mt-6 mb-24">
  {% for item in site.samples %}
    <div class="bg-sc-gray-5 rounded-lg hover:shadow-lg">
        <div class="mb-9 mt-6 flex flex-col items-center">
          <span class="w-12 h-12">{% icon {{ item.logo }} %}</span>
          <span class="mt-4 font-medium text-sc-gray-1 text-sc-text-6">{{ item.name }}</span>
        </div>      
        <div class="flex flex-row divide-x divide-sc-gray-3 text-sc-text-5 font-medium border-t border-sc-gray-3">
          <a href="https://github.com/Scalingo/sample-{{ item.url }}" class="w-1/2 py-6 text-center text-sc-gray-1 hover:text-sc-blue-1">
              Source
            </a>
            <a href="https://{{ item.url }}.is-easy-on-scalingo.com" class="w-1/2 py-6 text-center text-sc-gray-1 hover:text-sc-blue-1">
              App
            </a>
        </div>
    </div>
  {% endfor %}
</div>

</div>