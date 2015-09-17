---
layout: default
title: Documentation Center
date: 2015-09-09 00:00:00
---

<div class='row'>
  <div class='col-xs-12 col-sm-6'>
    <h2 class="homepage">Getting started</h2>
    <ul class='list-unstyled'>
    {% assign posts = (site.categories.getting-started | sort: 'index', 'last') %}
    {% for post in posts %}
      <li>
        <a href="{{ post.url }}">{{ post.title }}</a>
      </li>
    {% endfor %}
    </ul>
  </div>
  <div class='col-xs-12 col-sm-6'>
  <h2 class="homepage">Language documentation</h2>
    <ul class='list-unstyled'>
    {% assign posts = (site.categories.languages | sort: 'title' | sort: 'index', 'last') %}
    {% for post in posts %}
      {% if post.show_in_toc %}
      <li>
        <a href="{{ post.url }}">{{ post.title }}</a>
      </li>
      {% endif %}
    {% endfor %}
    </ul>
  </div>
</div>
<div class='row' style="margin-top: 15px">
  <div class='col-xs-12 col-sm-6'>
    <h2 class="homepage">Databases</h2>
      <ul class='list-unstyled'>
      {% assign posts = (site.categories.databases | sort: 'index', 'last') %}
      {% for post in posts %}
        <li>
          <a href="{{ post.url }}">{{ post.title }}</a>
        </li>
      {% endfor %}
      </ul>
  </div>
  <div class='col-xs-12 col-sm-6'>
    <h2 class="homepage">Platform Internals</h2>
    <ul class='list-unstyled'>
    {% assign posts = (site.categories.internals | sort: 'index', 'last') %}
    {% for post in posts %}
      <li>
        <a href="{{ post.url }}">{{ post.title }}</a>
      </li>
    {% endfor %}
    {% assign posts = (site.categories.app | sort: 'index', 'last') %}
    {% for post in posts %}
      <li>
        <a href="{{ post.url }}">{{ post.title }}</a>
      </li>
    {% endfor %}
    </ul>
  </div>
</div>
