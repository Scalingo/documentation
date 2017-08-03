---
title: Documentation Center
date: 2015-09-09 00:00:00
---

<html>
  {% include head.html %}
  <body>
    <main>
      {% include nav.html %}
      <div class="container index">
        <div class="row">
          <div class="col-12">
            <div class="card">
              <div class="card-block">
                <div class="row">
                  <div class="col-12 col-sm-8 offset-sm-2">
                    <div class="search-block mt-5">
                      <span class="fa fa-search search-icon"></span>
                      <input type="text" class="form-control" id="search-input" placeholder="Search..." autofocus="true">
                    </div>
                  </div>
                </div>
                <div class="languages mt-5">
                  {% include languages.html %}
                </div>
                <div class="addons mt-5">
                  {% include addons.html %}
                </div>
              </div>
            </div>
          </div>
        </div>
        <div class="row">
          <div class="col-12 col-sm-6">
            <div class="card mt-4">
              <div class="card-block">
                <div class="row platform">
                  <div class="col-12">
                    <h1>Platform documentation main chapters</h1>
                    <div class="row">
                      <ul>
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
              </div>
            </div>
          </div>
          <div class="col-12 col-sm-6">
            <div class="card mt-4">
              <div class="card-block">
                <div class="row recent">
                  <div class="container">
                    <h1>Latest modified articles</h1>
                    <div class="row">
                      <ul>
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
            </div>
          </div>
        </div>
      </div>
{% include ga_tracker.html %}
{% include fb_pixel.html %}
    </main>
  </body>
</html>
