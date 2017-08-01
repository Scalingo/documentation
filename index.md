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
	{% assign posts = site.categories.getting-started | sort: 'index', 'last' %}
	{% for post in posts %}
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
	{% assign posts = site.categories.languages | sort: 'title' | sort: 'index', 'last' %}
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
    <div class="mdl-card__title" id="databases">
      <h2 class="mdl-card__title-text">Databases</h2>
    </div>
    <div class="mdl-card__supporting-text">
      <ul class="list-unstyled">
	{% assign posts = site.categories.databases | sort: 'index', 'last' %}
	{% for post in posts %}
	<li>
          <a href="{{ post.url }}">{{ post.title }}</a>
	</li>
	{% endfor %}
      </ul>
    </div>
  </div>
  <div class="mdl-card mdl-shadow--2dp mdl-cell mdl-cell--6-col">
    <div class="mdl-card__title" id="platform-internals">
      <h2 class="mdl-card__title-text">Platform Internals</h2>
    </div>
    <div class="mdl-card__supporting-text">
      <ul class="list-unstyled">
	{% assign posts = site.categories.internals | sort: 'index', 'last' %}
	{% for post in posts %}
	<li>
          <a href="{{ post.url }}">{{ post.title }}</a>
	</li>
	{% endfor %}
	{% assign posts = site.categories.app | sort: 'index', 'last' %}
	{% for post in posts %}
	<li>
          <a href="{{ post.url }}">{{ post.title }}</a>
	</li>
	{% endfor %}
      </ul>
    </div>
  </div>
</div>
