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
          {% include search.html %}
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
        <div class="row recent">
          <h3>Latest written articles</h3>
          <div class="col-12">
            <div class="row">
              <ul>
                {% assign recent_posts = site.posts | sort: 'modified_at' | reverse %}
                {% for post in recent_posts limit:12 %}
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

