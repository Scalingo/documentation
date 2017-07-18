---
layout: default
title: Documentation Center
date: 2017-07-06 00:00:00
---


<div class="container">
  <div class="row">
    <h1 class="title-index">Take a look at our documentation</h1>
  </div>
  <div class="row languages">
    <div class="col-12 col-sm-6">
      <div class="row">
        <div class="col-6">
          <div class="thumbnail">
            <a href="/languages/ruby">
              <img src="https://cdn.scalingo.com/homepage/assets/technologies/svg/ruby-5fee0b87880eba1d6660458587381ceb9a6bb124f4d7a6581f7ef15c6ee172c1.svg" alt="Ruby" />
              <h4 class="caption">Ruby</h4>
            </a>
          </div>
          <div class="thumbnail">
            <a href="/languages/nodejs">
              <img src="https://cdn.scalingo.com/homepage/assets/technologies/svg/nodejs-a93e5754cc2c9cb881ba25ea4a86a26be1612faa299299adf9a169908f4fb984.svg" alt="Nodejs" />
              <h4 class="caption">NodeJS</h4>
            </a>
          </div>
          <div class="thumbnail">
            <a href="/languages/crystal">
              <img src="https://crystal-lang.org/images/icon.png" alt="Crystal" />
              <h4 class="caption">Crystal</h4>
            </a>
          </div>
          <div class="thumbnail">
            <a href="/languages/haskell">
              <img src="https://metova.com/wp-content/uploads/2016/01/Haskell-Logo1-300x212.png" alt="Haskell" />
              <h4 class="caption">Haskell</h4>
            </a>
          </div>
        </div>
        <div class="col-6">
          <div class="thumbnail">
            <a href="/languages/meteor">
              <img src="https://cdn.scalingo.com/homepage/assets/technologies/svg/meteorjs-0d73e71498cf98d6728f15faa5a50c09d5bb2b0fdc6d39fd140e0d7c7c4107fd.svg" alt="Meteorjs" />
              <h4 class="caption">MeteorJS</h4>
            </a>
          </div>
          <div class="thumbnail">
            <a href="/languages/php">
              <img src="https://cdn.scalingo.com/homepage/assets/technologies/svg/php-2d71f5f01eca45da137e01d2b6cb337d56becb8d89be6076bbe821ff75431cee.svg" alt="Php" />
              <h4 class="caption">PHP</h4>
            </a>
          </div>
          <div class="thumbnail">
            <a href="/languages/erlang">
              <img src="https://upload.wikimedia.org/wikipedia/commons/thumb/0/04/Erlang_logo.svg/876px-Erlang_logo.svg.png" alt="Erlang" />
              <h4 class="caption">Erlang</h4>
            </a>
          </div>
          <div class="thumbnail">
            <a href="/languages/javascript">
              <img src="http://codeslo.com/wp-content/uploads/2017/05/javascript-cup.png" alt="Javascript" />
              <h4 class="caption">Javascript</h4>
            </a>
          </div>
        </div>
      </div>
    </div>
    <div class="col-12 col-sm-6">
      <div class="row">
        <div class="col-6">
          <div class="thumbnail">
            <a href="/languages/python">
              <img src="https://cdn.scalingo.com/homepage/assets/technologies/svg/python-1fe87a79349e43b3de74d6c82476bae6038516d8af7d157c6717367d3966dd4e.svg" alt="Python" />
              <h4 class="caption">Python</h4>
            </a>
          </div>
          <div class="thumbnail">
            <a href="/languages/java">
              <img src="https://cdn.scalingo.com/homepage/assets/technologies/svg/java-6f1ab3742b8bfa5c7395ad202534ddcf1dd837ef4b7a757fc8f4493915187147.svg" alt="Java" />
              <h4 class="caption">Java</h4>
            </a>
          </div>
          <div class="thumbnail">
            <a href="/languages/go">
              <img src="https://cdn.scalingo.com/homepage/assets/technologies/svg/go-5495fcdd380aac80f6708324a9786d5de34a11269858157c7aba144e291464c8.svg" alt="Go" />
              <h4 class="caption">Go</h4>
            </a>
          </div>
        </div>
        <div class="col-6">
          <div class="thumbnail">
            <a href="/languages/scala">
              <img src="https://cdn.scalingo.com/homepage/assets/technologies/svg/scala-dae35d06cb8f5c45f2f0707af815cb16d261281119f4f72c4982e98930743716.svg" alt="Scala" />
              <h4 class="caption">Scala</h4>
            </a>
          </div>
          <div class="thumbnail">
            <a href="/languages/clojure">
              <img src="https://cdn.scalingo.com/homepage/assets/technologies/svg/clojure-6c3983a5616989b60b5dcd2aa4cab0c2fa6c475335730dd6d9f48bc490455383.svg" alt="Clojure" />
              <h4 class="caption">Clojure</h4>
            </a>
          </div>
          <div class="thumbnail">
            <a href="/languages/groovy">
              <img src="https://cdn.scalingo.com/homepage/assets/technologies/svg/groovy-0ed0753bfd69245ae5e00dcd87db63d6a41c951ef1a535872c7d4744c8073b7d.svg" alt="Groovy" />
              <h4 class="caption">Groovy</h4>
            </a>
          </div>
        </div>
      </div>
    </div>
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
