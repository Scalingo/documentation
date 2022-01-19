---
layout: default_with_main_navigation
title: Documentation Center
description: "From the deployment of your app to complex scaling operations you'll find all the resources you need to understand and benefit from Scalingo's powerful Platform as a Service. All major languages are supported: Ruby, NodeJS, MeteorJS, Python, PHP, Java and more."
---

<div class="bg-sc-gray-5 flex flex-row">
  <div class="flex-grow p-10">
    <h1>Getting Started on Scalingo</h1>

    <p>
      No server to manage, nor operating system, just git push your code, we take care of everything from there.
    </p>
    <p>
      And voilà, 2 minutes later, your website is online.
    </p>
    <div>Searchbar</div>
  </div>
  <div>{% icon hi-five %}</div>
</div>

<div class="grid grid-cols-2 gap-6">
  <div>
    <div class="flex">
      <h2 class="flex-grow">Learn about building, deploying and scaling with</h2>
      {% include atoms/arrow_link.md title="See all" url="/languages" %}
    </div>
    <div class="grid grid-cols-3 gap-6">
      {% for item in site.highlighted.technologies %}
        {% include atoms/icon_card.md title=item.name url=item.url icon=item.icon %}
      {% endfor %}
    </div>
  </div>
  <div>
    <div class="flex">
      <h2 class="flex-grow">Learn about using built-in databases</h2>
      {% include atoms/arrow_link.md title="See all" url="/databases" %}
    </div>
    <div class="grid grid-cols-3 gap-6">
      {% for item in site.highlighted.databases %}
        {% include atoms/icon_card.md title=item.name url=item.url icon=item.icon %}
      {% endfor %}
    </div>
  </div>
</div>
