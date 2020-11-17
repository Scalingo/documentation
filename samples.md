---
layout: default_with_only_main
title: Samples
subnav_index: 1
description: Here is a list of samples built with various technologies than you can deploy by yourself and take inspiration of.
modified_at: 2015-09-09 00:00:00
---

<h1>{{ page.title }}</h1>
<p class="mb-5">{{ page.description }}</p>

<div class="row">
  {% for item in site.samples %}
    <div class="col-12 col-md-3 col-lg-4">
      <div class="mdc-card mb-5">
        <div class="card-body">
          <div class="d-flex">
            <h3 class="mdc-typography--title mb-0">
              {{ item.name }}
            </h3>
            <div class="logo ml-auto">
              <svg aria-hidden="true" role="img" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 512 512">
                <use xlink:href="#{{ item.logo }}"></use>
              </svg>
            </div>
          </div>
        </div>
        <div class="mdc-card__actions">
          <div class="mdc-card__action-buttons">
            <a href="https://{{ item.url }}.is-easy-on-scalingo.com" class="mdc-button mdc-card__action mdc-card__action--button mdc-theme--text-primary-on-background">
              View app
            </a>
          </div>
          <div class="mdc-card__action-buttons">
            <a href="https://github.com/Scalingo/sample-{{ item.url }}" class="mdc-button mdc-card__action mdc-card__action--button mdc-theme--text-primary-on-background">
              View source
            </a>
          </div>
        </div>
      </div>
    </div>
  {% endfor %}
</div>
