---
layout: default_with_main_navigation
title: Documentation Center
subnav_index: 0
description: "From the deployment of your app to complex scaling operations you'll find all the resources you need to understand and benefit from Scalingo's powerful Platform as a Service. All major languages are supported: Ruby, NodeJS, MeteorJS, Python, PHP, Java and more."
modified_at: 2015-09-09 00:00:00
---

<h1>Getting Started on Scalingo</h1>

<p class="mb-5">
  No server to manage, nor operating system, just git push your code, we take care of everything from there. And voilà, 2 minutes later, your website is online.
</p>

<h2>Learn about building, deploying and scaling with</h2>

<div class="row">
  {% for item in site.highlighted.technologies %}
  <div class="col-12 col-md-6 col-lg-4">
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

<div class="row">
  <div class="col-12 col-md-6 col-lg-4">
    <div class="mb-5">
      <a href="/languages" class="mdc-button">View all</a>
    </div>
  </div>
</div>

<h2>Learn about using built-in databases</h2>

<div class="row">
  {% for item in site.highlighted.databases %}
  <div class="col-12 col-md-6 col-lg-4">
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

<h2>Addons for specific needs</h2>

<div class="row">
  {% for item in site.highlighted.addons %}
  <div class="col-12 col-md-6 col-lg-4">
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
      <div class="card-body pt-0">
        <div class="d-flex flex-column">
        {% for page_url in site.highlighted.first_steps %}
          {% assign apage = site.posts | where:'url', page_url | first %}
          <a href="{{ page_url }}">{{apage.title}}</a>
        {% endfor %}
        </div>
      </div>
    </div>
  </div>
  <div class="col-12 col-md-6">
    <div class="mdc-card mt-5">
      <div class="card-body">
        <div class="d-flex">
          <h3 class="mdc-typography--title mb-0">Last modified articles</h3>
          <a href="/feed.xml" class="ml-auto">
            <i class="material-icons rss">rss_feed</i>
          </a>
        </div>
      </div>
      <div class="card-body pt-0">
        {% assign recent_posts = site.posts | sort: 'modified_at' | reverse %}
        {% for post in recent_posts limit:10 %}
        <div class="d-flex justify-content-between">
          {% if post.categories contains 'changelog' %}
            <a href="{{ post.id | slugify | prepend: "/changelog#" }}" class="text-truncate">{{ post.title }}</a>
          {% else %}
            <a href="{{ post.url }}" class="text-truncate">{{ post.title }}</a>
          {% endif %}
          <small class="text-muted text-nowrap pl-1" style="position:relative;bottom:-4px;">
            {{ post.modified_at | date_to_string }}
          </small>
        </div>
        {% endfor %}
      </div>
    </div>
  </div>
</div>
