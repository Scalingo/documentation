---
title: Documentation Center
date: 2017-07-06 00:00:00
---

<html>
  {% include head.html %}
  <body>
    <main>
      {% include header.html %}
      <div class="container main-content">
        <div class="row">
          <div class="search-index">
            <div class="search-form">
              <input type="text" class="form-control" id="search-input" placeholder="Search the documentation" autofocus="true">
            </div>
          </div>
        </div>
        <div class="row languages">
          {% include languages.html %}
        </div>
        <div class="row addons">
          {% include addons.html %}
        </div>
        <div class="row platform">
          <h3>Our platform</h3>
          <div class="col-12">
            <div class="row">
              {% assign posts = site.categories.platform | sort: 'index', 'last' %}
              {% for post in posts %}
                <div class="thumbnail">
                  <a href="{{ post.url }}">
                    <h4 class="caption">{{ post.title }}</h4>
                  </a>
                </div>
              {% endfor %}
            </div>
          </div>
        </div>
      </div>
    </main>
  </body>
</html>

