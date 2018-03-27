# How to contribute

[*Scalingo Documentation Center*](http://doc.scalingo.com) relies on Jekyll and GitHub Pages to host, build and serve. You are welcome to contribute to this documentation by forking and sending pull requests.

## Adding a new article

To add a new article simply create a new markdown file in the `_posts` folder with the following file format: `yyyy-mm-dd-title.md` (*e.g. 1970-01-01-what-is-epoch.md*).
Please use the current date when creating the file.

The minimal *front matter* that you need to add is:

```
---
title: What is Epoch
modified_at: 1970-01-01 00:00:00
categories: unix
tags: time
---
```

Be aware that the `categories` will be used in the final URL. In the case of the previous *front matter*, the generated URL will be: `/unix/what-is-epoch.html`.

If you add a `permalink` that doesn't ends with `.html` in the *front matter* you have to append a trailing slash. Otherwise, the generated URL will not match the real accessible URL, which is troublesome for crawlers.

## Modifying an article

You are welcome to modify any article, but please remember to update `modified_at` before sending your pull request.

## Don'ts

Please do not use the `date` metadata as it will conflict with the date extracted from the file name. Instead, use `modified_at` to record when a modification is made to an article.

Please do not use first-level HTML/Markdown headers (*i.e. `<h1></h1>`*) as it will be pulled from the `title ` metadata.

__Blockquotes__ should be **only used for quotes**. If you'd like to incorporate a useful
note please use

Do not put `categories`, `category` or `permalink` in the Front Matter, everything is handled by the jekyll-dirname-generator plugin.

## Do's

If you want to write a useful note:

```
{% note %}
  My useful note here
{% endnote %}
```

If you want to write a warning note:

```
{% warning %}
  My warning note here
{% endwarning %}
```

If you want to insert a link to another blog post:

```html
<a href="{% post_url platform/internals/2000-01-01-routing %}">text of the link</a>
```

To insert an image, first upload it to our CDN, inside the documentation
folder. Give it a public permission `Grant public read access to this
object(s)`. Then, insert it with:

```liquid
{% assign img_url = "https://cdn.scalingo.com/documentation/screenshot_*" %}
{% include mdl_img.html %}
```

## Running locally

To install dependencies locally:

```
docker-compose run web bundle install
docker-compose run web yarn install
```

To build the static site and spin-up a file server:

```
docker-compose up
```

## Links

* [Scalingo Documentation Center](http://doc.scalingo.com)
* [Using Jekyll with Pages](https://help.github.com/articles/using-jekyll-with-pages/)
* [Jekyll](https://jekyllrb.com/)
