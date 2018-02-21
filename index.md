---
layout: default
title: Documentation Center
date: 2015-09-09 00:00:00
---

<div class="h1">Getting Started on Scalingo</div>

<p class="mb-5">
  No server to manage, nor operating system, just git push your code, we take care of everything from there. And voilà, 2 minutes later, your website is online.
</p>

<div class="h2">Learn about building, deploying and scaling with</div>

<div class="row">
  {% for item in site.highlighted.technologies %}
  <div class="col-12 col-md-3 col-lg-4">
    <div class="mdc-card mb-5">
      <div class="card-body">
        <div class="d-flex">
          <h3 class="mdc-typography--title mb-0">
            {{ item.name }}
          </h3>
          <div class="logo ml-auto">
            <svg aria-hidden="true" role="img" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 512 512">
              <use xlink:href="#{{ item.name | slugify }}"></use>
            </svg>
          </div>
        </div>
      </div>
      <div class="mdc-card__actions">
        <div class="mdc-card__action-buttons">
          <a href="{{ item.url }}" class="mdc-button mdc-card__action mdc-card__action--button mdc-theme--text-primary-on-background">
            View details
          </a>
        </div>
      </div>
    </div>
  </div>
  {% endfor %}
</div>

<div class="h2">Learn about using built-in databases and addons</div>

<div class="row">
  {% for item in site.highlighted.addons %}
  <div class="col-12 col-md-3 col-lg-4">
    <div class="mdc-card mb-5">
      <div class="card-body">
        <div class="d-flex">
          <h3 class="mdc-typography--title mb-0">
            Scalingo
            <br/>
            {{ item.name }}
          </h3>
          <div class="logo ml-auto">
            <svg aria-hidden="true" role="img" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 512 512">
              <use xlink:href="#{{ item.name | slugify | prepend:'scalingo-' }}"></use>
            </svg>
          </div>
        </div>
      </div>
      <div class="mdc-card__actions">
        <div class="mdc-card__action-buttons">
          <a href="{{ item.url }}" class="mdc-button mdc-card__action mdc-card__action--button mdc-theme--text-primary-on-background">
            View details
          </a>
        </div>
      </div>
    </div>
  </div>
  {% endfor %}
</div>

<div class="row">
  <div class="col-12 col-md-6">
    <div class="mdc-card mt-5">
      <div class="card-body">
        <h3 class="mdc-typography--title mb-0">First steps on Scalingo</h3>
      </div>
    </div>
  </div>
  <div class="col-12 col-md-6">
    <div class="mdc-card mt-5">
      <div class="card-body">
        <div class="d-flex">
          <h3 class="mdc-typography--title mb-0">Last modified articles</h3>
          <a href="/feed.xml" class="ml-auto">
            <svg aria-hidden="true" role="img" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 512 512">
              <use xlink:href="#rss"></use>
            </svg>
          </a>
        </div>
      </div>
      <div class="card-body pt-0">
        <ul class='list-unstyled mb-0'>
          {% assign recent_posts = site.posts | sort: 'modified_at' | reverse %}
          {% for post in recent_posts limit:8 %}
          <li>
            <a href="{{ post.url }}">{{ post.title }}</a>
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
