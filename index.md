---
layout: default
title: Appsdeck Documentation
---

<div class="container">

  <div class="row">
    <div class="col-lg-6 superblock">
      <div class="block">
        <h2>Internals</h2>
        <ul class="list-unstyled">
          {% for post in site.categories["internals"] %}
            <li><a href="{{ post.url }}">{{ post.title }}</a></li>
          {% endfor %}
        </ul>
      </div>
    </div>
    <div class="col-lg-6 superblock">
      <div class="block">
        <h2>Getting started</h2>
        <ul class="list-unstyled">
          {% for post in site.categories["getting-started"] %}
            <li><a href="{{ post.url }}">{{ post.title }}</a></li>
          {% endfor %}
        </ul>
      </div>
    </div>
  </div>
</div>
