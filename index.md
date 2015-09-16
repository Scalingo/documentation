---
layout: default
title: index
date: 2015-09-09 00:00:00
---

<h1>Scalingo {{ site.title }}</h1>
<div class='row'>
  <div class='col-xs-12 col-sm-6'>
    <!-- <div class='well'> -->
      <h2>Getting started</h2>
      <ul class='list-unstyled'>
      {% assign posts = (site.categories.getting-started | sort: 'index', 'last') %}
      {% for post in posts %}
        <li>
          <a href="{{ post.url }}">{{ post.title }}</a>
        </li>
      {% endfor %}
      </ul>
    <!-- </div> -->
  </div>
  <div class='col-xs-12 col-sm-6'>
    <!-- <div class='well'> -->
      <h2>Databases</h2>
      <ul class='list-unstyled'>
      {% assign posts = (site.categories.databases | sort: 'index', 'last') %}
      {% for post in posts %}
        <li>
          <a href="{{ post.url }}">{{ post.title }}</a>
        </li>
      {% endfor %}
      </ul>
    <!-- </div> -->
  </div>
</div>
<div class='row'>
  <div class='col-xs-12 col-sm-6'>
    <!-- <div class='well'> -->
      <h2>Platform Internals</h2>
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
    <!-- </div> -->
  </div>
  <div class='col-xs-12 col-sm-6'>
    <!-- <div class='well'> -->
      <h2>Language documentation</h2>
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
    <!-- </div> -->
  </div>
</div>
