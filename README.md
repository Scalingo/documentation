# How to contribute

[*Scalingo Documentation Center*](http://doc.scalingo.com) relies on Jekyll. You are welcome to contribute to this documentation by forking and sending pull requests.

## Adding a new article

To add a new article simply create a new markdown file in the `_posts` folder with the following file format: `yyyy-mm-dd-title.md` (*e.g. 1970-01-01-what-is-epoch.md*).
Please use the current date when creating the file.

The minimal *front matter* that you need to add is:

```
---
title: What is Epoch
modified_at: 2021-11-23 00:00:00
---
```

Optional tag :

- `nav: [string]` set another url than the one generated from the title
- `index: [integer]` change the position of the page in his folder in the side menu

## Modifying an article

You are welcome to modify any article, but please remember to update `modified_at` before sending your pull request.

## Don'ts

Please do not use the `date` metadata as it will conflict with the date extracted from the file name. Instead, use `modified_at` to record when a modification is made to an article.

Please do not use first-level HTML/Markdown headers (*i.e. `<h1></h1>`*) as it will be pulled from the `title ` metadata.

__Blockquotes__ should be **only used for quotes**.

Do not put `categories`, `category` or `permalink` in the *front matter*, everything is handled by the jekyll-dirname-generator plugin.

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

If you want to insert a link to another documentation article:

```markdown
[text of the link]({% post_url platform/internals/2000-01-01-routing %})
```

To insert an image, first upload it to our CDN, inside the documentation
folder. Give it a public permission `Grant public read access to this
object(s)`. Then, insert it with:

```liquid
{% assign img_url = "https://cdn.scalingo.com/documentation/screenshot_*" %}
{% include mdl_img.html %}
```

## Running Locally

To install dependencies locally:

```
docker compose run --rm web bundle install
docker compose run --rm web yarn install --ignore-engines
```

To build the static site and spin-up a file server:

```
docker compose up
```

And visit http://localhost:4300

If you want to serve the doc like in production (through the rack stack), generate the site first (see above) and then:

```
docker compose -f docker compose-prod.yml up
```

This will run puma in parallel and serve the site at http://localhost:4302

### Changelog, Samples and New Section

For a reason I ignore and I don't want to spend time understanding, we need to manually re-build the pages when adding a new changelog entry or a new section.
This is done with:

```
docker compose exec web bundle exec jekyll build
```

### Dev tool

To help debug responsive layout issues add this tool in the default layout, it will show the current Tailwind screen & size in every pages.

```
  {% include organisms/responsive_tool.html %}
```

## Links

* [Scalingo Documentation Center](http://doc.scalingo.com)
