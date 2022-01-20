---
layout: default_with_main_navigation
title: Documentation Center
description: "From the deployment of your app to complex scaling operations you'll find all the resources you need to understand and benefit from Scalingo's powerful Platform as a Service. All major languages are supported: Ruby, NodeJS, MeteorJS, Python, PHP, Java and more."
---
<div class="w-full max-w-sc-content-1532 text-sc-gray-1">
  <div class="bg-sc-gray-5 flex flex-row mb-12">
    <div class="flex-grow p-10">
      <h1 class="mb-4 text-sc-title-1 font-bold">Getting Started on Scalingo</h1>

      <p class="leading-10">
        No server to manage, nor operating system, just git push your code, we take care of everything from there.
        <br/>
        And voilà, 2 minutes later, your website is online.
      </p>
      <div>Searchbar</div>
    </div>
    <div>{% icon hi-five %}</div>
  </div>
  <div class="grid grid-cols-1 md:grid-cols-2 xl:grid-cols-3 gap-6 mb-12">
    {% for post_url in site.highlighted.first_steps %}
      {% assign post = site.posts | where:'url', post_url | first %}
      {% include atoms/line_card.md title=post.title url=post_url %}
    {% endfor %}
  </div>
  <div class="grid grid-cols-1 xl:grid-cols-2 gap-6 mb-12">
    <div>
      <div class="md:flex mb-4">
        <h2 class="flex-grow">Learn about building, deploying and scaling with</h2>
        {% include atoms/arrow_link.md title="See all" url="/languages" %}
      </div>
      <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
        {% for item in site.highlighted.technologies %}
          {% include atoms/icon_card.md title=item.name url=item.url icon=item.icon %}
        {% endfor %}
      </div>
    </div>
    <div>
      <div class="md:flex mb-4">
        <h2 class="flex-grow">Learn about using built-in databases</h2>
        {% include atoms/arrow_link.md title="See all" url="/databases" %}
      </div>
      <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
        {% for item in site.highlighted.databases %}
          {% include atoms/icon_card.md title=item.name url=item.url icon=item.icon %}
        {% endfor %}
      </div>
    </div>
  </div>
  <div class="grid grid-cols-1 xl:grid-cols-2 gap-6">
    <div>
      <div class="flex mb-4">
        <h2>Popular articles</h2>
      </div>
      <div class="flex flex-col gap-2">
        {% for post_url in site.highlighted.popular %}
          {% assign post = site.posts | where:'url', post_url | first %}
          <a href="{{ post_url }}">
            <div class="bg-sc-gray-5 w-full p-6 flex items-center group rounded transition hover:shadow-lg">
              <div class="flex-grow group-hover:text-sc-blue-1">{{ post.title }}</div>
              <div class="group-hover:translate-x-1 duration-200 ease-out">{% icon arrow_right %}</div>
            </div>
          </a>
        {% endfor %}
      </div>
    </div>
    <div>
      <div class="flex mb-4 items-center">
        <h2>Last modified articles</h2>
        <a class="ml-4" href="/feed.xml">{% icon rss %}</a>
      </div>
      <div class="flex flex-col gap-2">
        {% assign recent_posts = site.posts | sort: 'modified_at' | reverse %}
        {% for post in recent_posts limit:6 %}
          {% if post.categories contains 'changelog' %}
            <a href="{{ post.id | slugify | prepend: "/changelog#" }}">
          {% else %}
            <a href="{{ post.url }}">
          {% endif %}
            <div class="bg-sc-gray-5 w-full p-6 flex items-center group roundedtransition hover:shadow-lg">
              <div class="flex-grow group-hover:text-sc-blue-1">{{ post.title }}</div>
              <div class="text-sc-gray-2 mr-6">{{ post.modified_at | date_to_string }}</div>
              <div class="group-hover:translate-x-1 duration-200 ease-out">{% icon arrow_right %}</div>
            </div>
          </a>
        {% endfor %}
      </div>
    </div>
  </div>
</div>
