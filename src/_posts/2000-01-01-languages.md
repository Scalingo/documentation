---
layout: default
title: Languages
index: 1
---

<div class="container mx-auto">
  <div class="bg-sc-gray-5 rounded-lg flex flex-row justify-between items-center">
    <div class="p-10">
      <h1 class="text-sc-title-1-1 text-sc-gray-1 font-bold">{{ page.title }}</h1>
      {% include atoms/filter.html %}
    </div>
    <div class="hidden lg:block lg:mx-10">{% icon lightbulb %}</div>
  </div>

  <h2 class="font-bold text-sc-gray-1 text-sc-title-4-2 mt-12">Table of contents</h2>
  <div class="grid  grid-cols-2 lg:grid-cols-5 gap-6 mt-4 mb-24">
    {% for item in site.languages %}
      <a data-card="{{ item.name }}" href="/languages/{{ item.url }}/start.html" class="filterable-card bg-sc-gray-5 rounded-lg hover:shadow-lg cursor-pointer">
        <div class="mb-9 mt-6 flex flex-col items-center">
          <span class="w-12 h-12">{% icon {{ item.logo }} %}</span>
          <span class="mt-4 font-medium text-sc-gray-1 text-sc-text-6">{{ item.name }}</span>
        </div>
      </a>
    {% endfor %}
  </div>
</div>
