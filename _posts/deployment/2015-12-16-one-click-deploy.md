---
title: One Click Deploy
modified_at: 2015-12-16 11:40:00
category: platform
tags: deployment one-click app
order: 5
permalink: /deployment/
---

If you want to give people the opportunity to deploy your project instantly on Scalingo, you can setup a deploy button on your github project or even on your website. A `scalingo.json` file is needed at the root of your github project in order to generate the deployment page.

At the moment, **only public projects hosted on Github are supported**.

## Display a one-click deploy button

To do so, you will need to add a link to `https://my.scalingo.com/deploy?source=https://github.com/<Your account>/<Your project>`.

By default it will deploy the branch `master` of your project, but you can eventually specify the branch you want to deploy by adding a '#' followed by the branch itself, like shown below:

`https://my.scalingo.com/deploy?source=https://github.com/<Your account>/<Your project>#custom_branch`

* Markdown implementation (README.md)

```text
[![Deploy on Scalingo](https://cdn.scalingo.com/deploy/button.svg)](https://my.scalingo.com/deploy?source=https://github.com/<Your account>/<Your project>#custom_branch)
```

Example: [![Deploy on Scalingo](https://cdn.scalingo.com/deploy/button.svg)](https://my.scalingo.com/deploy?source=https://github.com/Scalingo/sample-go-martini)

* Html implementation

```html
<a href="https://my.scalingo.com/deploy?source=https://github.com/<Your account>/<Your project>#custom_branch">
   <img src="https://cdn.scalingo.com/deploy/button.svg" alt="Deploy on Scalingo" data-canonical-src="https://cdn.scalingo.com/deploy/button.svg" style="max-width:100%;">
</a>
```

Example:
<a href="https://my.scalingo.com/deploy?source=https://github.com/Scalingo/sample-go-martini/">
   <img src="https://cdn.scalingo.com/deploy/button.svg" alt="Deploy on Scalingo" data-canonical-src="https://cdn.scalingo.com/deploy/button.svg" style="max-width:100%;">
</a>

## Example manifest scalingo.json

```json
{
  "name": "Sample Go Martini",
  "description": "Sample web application using the Go framework Martini",
  "logo": "https://scalingo.com/logo.svg",
  "repository": "https://github.com/Scalingo/sample-go-martini",
  "website": "https://scalingo.com",
  "env": {
    "VAR_TEST_1": {
      "description": "test variable number 1",
      "value": "1"
    },
    "VAR_SECRET_1": {
      "description": "generated variable 1",
      "generator": "secret"
    }
  },
  "addons": ["scalingo-redis"]
}
```

You can find everything about the `scalingo.json` file on our [API dedicated page](http://developers.scalingo.com/scalingo-json-schema/).
