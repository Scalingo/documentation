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
          <h1 class="title-index">Take a look at our documentation</h1>
        </div>
        <div class="row languages">
          {% include languages.html %}
        </div>
        <div class="row">
          <div class="card-deck" style="width: 100%;">
            <div class="card">
              <div class="card-block">
                <h2 class="card-title">Getting started</h2>
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
            <div class="card">
              <div class="card-block">
                <h2 class="card-title">Recent activities</h2>
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
    </main>
  </body>
</html>

