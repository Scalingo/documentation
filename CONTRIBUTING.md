# How to contribute

[*Scalingo Documentation Center*](http://doc.scalingo.com) relies on Jekyll. You are welcome to contribute to this documentation by forking and sending pull requests.

## Repository structure

Jekyll reads its source files from `src/` because `_config.yml` sets `source: src`.

Main content is organized in:

- `src/_posts/` for documentation pages
- `src/_tutorials/` for tutorials
- `src/_tutorials_categories/` for tutorial categories
- `src/changelog/` for changelog entries
- `src/_includes/` for reusable Liquid partials
- `assets/` for source assets
- `src/assets/` for built assets

## Adding a new article

To add a new content page, create a new markdown file in the appropriate directory for that content type, using the following file format: `yyyy-mm-dd-title.md` (*e.g. 1970-01-01-what-is-epoch.md*).
Please use the current date when creating the file.
The date in the filename must be less than or equal to the current build date, otherwise the page may be excluded from the build output.

The minimal *front matter* that you need to add is:

```yml
---
title: What is Epoch
modified_at: 1970-01-01 00:00:00
---
```

Optional tags:

- `nav: [string]` set another url than the one generated from the title
- `index: [integer]` change the position of the page in his folder in the side menu
- `tags: [string]` add search and classification keywords
- `layout: [string]` use a specific page layout for special pages
- `description: [string]` add a short page description used by some landing pages
- `subnav_index: [integer]` set the position of a page in the sub-navigation
- `logo: [string]` define the icon or logo used by tutorial pages
- `products: [array]` list related Scalingo products for a tutorial
- `category: [string]` assign a tutorial to a tutorial category
- `permalink: [string]` define the public URL of tutorials and other special pages that require a stable path
- `is_series: [boolean]` mark a tutorial as part of a series
- `series: [string]` group tutorial pages under the same series name
- `series_index: [integer]` set the position of a page inside a tutorial series
- `oses: [array]` list supported operating systems on pages that display OS-specific icons
- `cvss: [object]` define CVSS metadata for security bulletins
- `github: [string]` link a changelog entry to the upstream GitHub repository

The exact set of supported tags depends on the content type and layout. When in doubt, copy the front matter structure from a nearby page of the same kind.

## Modifying an article

You are welcome to modify any article, but please remember to update `modified_at` before sending your pull request. In existing content, `modified_at` is typically set to `00:00:00`; prefer keeping that convention unless you have a reason to do otherwise.

When adding or editing content, prefer following the existing structure and naming conventions used by nearby files.

## Content conventions

Documentation pages use the kramdown Markdown flavor. Use standard Markdown
syntax by default, and refer to the [kramdown quick reference](https://kramdown.gettalong.org/quickref.html) when you need extra formatting options.

### Writing style

Use clear international English.

The target audience is technical, but not necessarily native English-speaking. Documentation should be easy to scan and actionable for an international developer or operator audience.

- Prefer short, direct sentences.
- Use technical terms when they are precise and expected by developers or operators.
- Avoid jargon when a simpler word is equally accurate.
- Avoid idioms, slang, humor, metaphors, and culture-specific expressions.
- Prefer active voice and concrete actions.
- Keep explanations concise, especially in troubleshooting pages.
- Define acronyms or product-specific concepts the first time they appear when the audience may not know them.
- Do not over-explain standard technical concepts, but link to canonical documentation when useful.
- Use consistent product and platform terms across pages.
- Preserve exact command names, log messages, error messages, environment variables, and configuration keys.

### Don'ts

Please do not use the `date` metadata as it will conflict with the date extracted from the file name. Instead, use `modified_at` to record when a modification is made to an article.

Please do not use first-level HTML/Markdown headers (*i.e. `<h1></h1>`*) as it will be pulled from the `title ` metadata.

__Blockquotes__ should be **only used for quotes**.

Do not put `categories` in the *front matter*. Avoid adding `category` or `permalink` to regular documentation pages in `src/_posts/` unless the content type already relies on them, such as tutorials or some legacy pages.

Do not manually edit generated files in `src/assets/` unless the task explicitly requires it. Prefer editing the source files in `assets/`.

### Do's

If you want to write a useful note:

```liquid
{% note %}
  My useful note here
{% endnote %}
```

If you want to write a warning note:

```liquid
{% warning %}
  My warning note here
{% endwarning %}
```

If you want to insert a link to another documentation article:

```markdown
[text of the link]({% post_url platform/internals/2000-01-01-routing %})
```

### Links

Prefer reference-style Markdown links when a page contains several links or when the target URL is long.

Example in content:

```markdown
Open your [account dashboard][dashboard].
Transfer ownership with [this guide][transfer-project-ownership].
```

Then define the links at the bottom of the page:

```markdown
[dashboard]: https://dashboard.scalingo.com/
[transfer-project-ownership]: {% post_url platform/projects/2000-01-01-manage-projects %}#transfer-project-ownership
```

This keeps the body of the page easier to read and makes link maintenance simpler.

For short, isolated links, inline Markdown links are still acceptable.

To insert an image, first upload it to our CDN, inside the documentation
folder. Give it a public permission `Grant public read access to this
object(s)`. Then, insert it with:

```liquid
{% assign img_url = "https://cdn.scalingo.com/documentation/screenshot_*" %}
{% include mdl_img.html %}
```

### Reusable content with Jekyll includes

When the same content must appear on several pages, create a Jekyll include
instead of duplicating the Markdown.

Put reusable content fragments in `src/_includes/`. The include file does not
need any special structure: write the Markdown directly, without front matter
or an additional wrapper.

Then include the fragment from each page:

```liquid
{% include api_endpoints.md %}
```

Keep includes focused on a small reusable fragment, such as a list, a warning,
or a shared paragraph. If the fragment needs an internal maintenance note, put
the note inside the include so contributors see it in the canonical source.

## Renaming a page

If you rename a page or change its path, check the root-level files that may contain hardcoded internal URLs or routing rules related to that page, especially:

- `_config.yml`
- `config.ru`
- `redirections.yml`

If the public URL changes, add a new redirect entry in the `301` section of `redirections.yml` in the same change.

Append new redirect entries at the end of the `301` section, immediately before the `obsolete` section. Do not insert them near similar redirects elsewhere in the file.

Do not modify existing redirect entries during a normal page move, even if they point to a page that is being moved again. Redirect chaining is acceptable.

Example:

```yml
"301":
  # Existing redirects above...

  - old: "/old/path"
    new: "/new/path"

obsolete:
  # Obsolete paths below...
```

## Running Locally

To install dependencies locally:

```sh
docker compose build --pull \
&& docker compose run --rm web bundle install \
&& docker compose run --rm web yarn install --ignore-engines \
&& docker compose run --rm web bundle exec jekyll build
```

To build the static site and spin-up a file server:

```sh
docker compose up
```

And visit http://localhost:4300

If you want to serve the doc like in production (through the rack stack), generate the site first (see above) and then:

```sh
docker compose -f docker compose-prod.yml up
```

This will run puma in parallel and serve the site at http://localhost:4302

### Manual rebuilds for changelog, samples, and new sections

For a reason I ignore and I don't want to spend time understanding, we need to manually re-build the pages when adding a new changelog entry or a new section.
This is done with:

```sh
docker compose exec web bundle exec jekyll build
```

### How to debug

#### Jekyll build

Using [debug.rb](https://github.com/ruby/debug) it's possible to add break points in Ruby code.
1. Prepend command `jekyll serve` by `rdbg -c -- `
2. Add a `binding.break` where you want to stop the execution

#### Theming (HTML/CSS)

To help debug responsive layout issues add this tool in the default layout, it will show the current Tailwind screen & size in every pages.

```liquid
  {% include organisms/responsive_tool.html %}
```

#### Force regeneration

Sometimes, the files regeneration (especially the assets) got lost.

In this case remove the `_site` folder via
```sh
docker compose run web rm -rf _site
```

## Validation

After content or configuration changes, run:

```sh
docker compose run --rm web bundle exec jekyll build
```

After asset changes, run:

```sh
docker compose run --rm web yarn build
docker compose run --rm web bundle exec jekyll build
```
