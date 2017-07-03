---
layout: default
title: Documentation Center
date: 2015-09-09 00:00:00
---

<div class="mdl-grid">
  <div class="mdl-card mdl-shadow--2dp mdl-cell mdl-cell--6-col">
    <div class="mdl-card__title" id="getting-started">
      <h2 class="mdl-card__title-text">Getting started</h2>
    </div>
    <div class="mdl-card__supporting-text">
      <ul class="list-unstyled">
	{% assign posts = (site.categories.getting-started | sort: 'index', 'last') %}
	{% for post in posts limit:10 %}
	<li>
          <a href="{{ post.url }}">{{ post.title }}</a>
	</li>
	{% endfor %}
      </ul>
    </div>
  </div>
  <div class="mdl-card mdl-shadow--2dp mdl-cell mdl-cell--6-col">
    <div class="mdl-card__title" id="language-documentation">
      <h2 class="mdl-card__title-text">Recent activities</h2>
    </div>
    <div class="mdl-card__supporting-text">
      <ul class="list-unstyled">
	{% assign recent_posts = (site.posts | sort: 'modified_at' | reverse) %}
  {% for post in recent_posts limit:10 %}
	<li>
          <a href="{{ post.url }}">{{ post.title }}</a>
	</li>
	{% endfor %}
      </ul>
    </div>
  </div>
  <div class="mdl-card mdl-shadow--2dp mdl-cell mdl-cell--6-col">
    <div class="mdl-card__title" id="language-documentation">
      <h2 class="mdl-card__title-text">Language documentation</h2>
    </div>
    <div class="mdl-card__supporting-text">
      <ul class="list-unstyled">
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
  <div class="mdl-card mdl-shadow--2dp mdl-cell mdl-cell--6-col">
    <div class="mdl-card__title" id="platform-internals">
      <h2 class="mdl-card__title-text">The most seen</h2>
    </div>
    <div class="mdl-card__supporting-text">
      <ul class="list-unstyled">
	{% assign posts = (site.categories.app | sort: 'index', 'last') %}
	{% for post in posts limit:11 %}
	<li>
          <a href="{{ post.url }}">{{ post.title }}</a>
	</li>
	{% endfor %}
      </ul>
    </div>
  </div>
</div>
