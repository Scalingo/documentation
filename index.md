---
layout: default
title: Documentation Center
date: 2017-07-06 00:00:00
---

<h2 class="doc-center">
  <a href="/">Documentation Center </a>
  <a href="/feed.xml" >
    <i class="fa fa-rss side-bar-rss"></i>
  </a>
</h2>

<div class="container">
  <div class="row">
    <div class="col-xs-6 col-sm-4">
      <div class="card">
        <div class="card-block">
          <h4 class="card-title">Getting started</h4>
          <p class="card-text">
            <ul class="list-unstyled">
              {% assign posts = site.categories.getting-started | sort: 'index', 'last' %}
              {% for post in posts limit:12 %}
                <li>
                  <a href="{{ post.url }}">{{ post.title }}</a>
                </li>
              {% endfor %}
            </ul>
          </p>
        </div>
      </div>
    </div>
    <div class="col-xs-6 col-sm-4">
      <div class="card">
        <div class="card-block">
          <h4 class="card-title">Recent activities</h4>
          <p class="card-text">
            <ul class="list-unstyled">
              {% assign posts = site.posts | sort: 'modified_at' | reverse %}
              {% for post in posts limit:12 %}
                <li>
                  <a href="{{ post.url }}">{{ post.title }}</a>
                </li>
              {% endfor %}
            </ul>
          </p>
        </div>
      </div>
    </div>
  </div>
</div>

<div class="container">
  <div class="row">
    <div class="col-xs-6 col-sm-4">
      <div class="card">
        <div class="card-block">
          <h4 class="card-title">Language documentation</h4>
          <p class="card-text">
            <ul class="list-unstyled">
              {% assign posts = site.categories.languages | sort: 'title' | sort: 'index', 'last' %}
              {% for post in posts limit:12 %}
                <li>
                  <a href="{{ post.url }}">{{ post.title }}</a>
                </li>
              {% endfor %}
            </ul>
          </p>
        </div>
      </div>
    </div>
    <div class="col-xs-6 col-sm-4">
      <div class="card">
        <div class="card-block">
          <h4 class="card-title">The most seen</h4>
          <p class="card-text">
            <ul class="list-unstyled">
              {% assign posts = site.categories.app | sort: 'title' | sort: 'index', 'last' %}
              {% for post in posts limit:12 %}
                <li>
                  <a href="{{ post.url }}">{{ post.title }}</a>
                </li>
              {% endfor %}
            </ul>
          </p>
        </div>
      </div>
    </div>
  </div>
</div>
