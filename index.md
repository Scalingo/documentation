---
title: Documentation Center
modified_at: 2017-07-06 00:00:00
---

<html>
  {% include head.html %}
  <body>
    <main>
      {% include header.html %}
      <div class="container index">
        <div class="row">
          <div class="search-block">
            <div class="search-form">
              <span class="fa fa-search search-icon"></span>
              <input type="text" class="form-control" id="search-input" placeholder="Search" autofocus="true">
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
          <div class="col-12">
            <h3>Useful categories for your application</h3>
            <div class="row">
              <ul class="column">
                {% assign posts = site.categories.platform | sort:'order' %}
                {% for post in posts %}
                  <li>
                    <a href="{{ post.url }}">
                      <span class="fa fa-angle-right"></span>{{ post.title }}
                    </a>
                  </li>
                {% endfor %}
              </ul>
            </div>
          </div>
        </div>
        <div class="row recent">
          <div class="container">
            <h3>Latest modified articles</h3>
            <div class="row">
              <ul class="column">
                {% assign recent_posts = site.posts | sort: 'modified_at' | reverse %}
                {% for post in recent_posts limit:12 %}
                  <li>
                    <a href="{{ post.url }}">
                      <span class="fa fa-angle-right"></span>{{ post.title }}
                    </a>
                    <small class="text-muted">
                      {{ post.modified_at | date_to_string }}
                    </small>
                  </li>
                {% endfor %}
              </ul>
            </div>
          </div>
        </div>
      </div>
    </main>
  </body>
</html>

