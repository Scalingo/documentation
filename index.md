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
          <h3>Some useful links about our platform</h3>
          <div class="col-12">
            <div class="row">
              <ul>
                {% assign posts = site.categories.platform | sort:'order' %}
                {% for post in posts %}
                  <li>
                    <span class="fa fa-angle-right"></span>
                    <a href="{{ post.url }}">{{ post.title }}</a>
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

