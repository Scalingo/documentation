---
layout: default
title: index
date: 2015-09-09 00:00:00
---

<div class='row'>
  <div class='col-xs-12 col-sm-6'>
    <div class='well'>
      <h2>
        <a href='{% post_url /getting-started/2015-06-02-first-steps %}'>Getting started</a>
      </h2>
      <ul class='list-unstyled'>
      {% assign posts = (site.categories.getting-started | sort: 'index', 'last') %}
      {% for post in posts %}
        <li>
          <a href="{{ post.url }}">{{ post.title }}</a>
        </li>
      {% endfor %}
      </ul>
    </div>
  </div>
  <div class='col-xs-12 col-sm-6'>
    <div class='well'>
      <h2>
        <a href='{% post_url /databases/2014-11-24-intro-databases %}'>Databases</a>
      </h2>
      <ul class='list-unstyled'>
      {% assign posts = (site.categories.databases | sort: 'index', 'last') %}
      {% for post in posts %}
        <li>
          <a href="{{ post.url }}">{{ post.title }}</a>
        </li>
      {% endfor %}
      </ul>
    </div>
  </div>
</div>
<div class='row'>
  <div class='col-xs-12 col-sm-6'>
    <div class='well'>
      <h2>
        <a href='{% post_url /internals/2015-03-22-intro-internals %}'>Platform Internals</a>
      </h2>
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
  <div class='col-xs-12 col-sm-6'>
    <div class='well'>
      <h2>
        <a href='{% post_url /languages/2014-09-23-intro-languages %}'>Language documentation</a>
      </h2>
      <ul class='list-unstyled'>
      {% assign posts = (site.categories.languages | sort: 'index', 'last') %}
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
</div>
<div class='row'>
  <div class='col-xs-12 col-sm-6'>
    <div class='well'>
      <h2>Recent Activity</h2>
      <ul class='list-unstyled'>
      {% for post in site.posts limit:10 %}
        <li>
          <a href="{{ post.url }}">{{ post.title }}</a>
        </li>
        <span class="last-article-date pull-right">
          {{ post.date | date_to_string}}
        </span>
      {% endfor %}
      </ul>
    </div>
  </div>
</div>
