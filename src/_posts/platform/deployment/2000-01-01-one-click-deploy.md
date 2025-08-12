---
title: One Click Deploy
modified_at: 2015-12-16 11:40:00
tags: app deployment one-click
index: 9
---

If you want to give people the opportunity to deploy your project instantly on
Scalingo, you can setup a deploy button on your GitHub project or even on your
website. A `scalingo.json` file is required at the root of your GitHub project in
order to generate the deployment page.

At the moment, **only public projects hosted on GitHub are supported**.

## Display a one-click deploy button

To do so, you will need to add a link to `https://dashboard.scalingo.com/create/app?source=https://github.com/<Your account>/<Your project>`.

By default it will deploy the branch `master` of your project, but you can optionally specify the branch you want to deploy by adding a '#' followed by the branch itself, like shown below:

```
https://dashboard.scalingo.com/create/app?source=https://github.com/<Your account>/<Your project>#custom_branch
```

* Markdown implementation (README.md)

```text
[![Deploy on Scalingo](https://cdn.scalingo.com/deploy/button.svg)](https://dashboard.scalingo.com/create/app?source=https://github.com/<Your account>/<Your project>#custom_branch)
```

Example: [![Deploy on Scalingo](https://cdn.scalingo.com/deploy/button.svg)](https://dashboard.scalingo.com/create/app?source=https://github.com/Scalingo/sample-go-martini)

* HTML implementation

```html
<a href="https://dashboard.scalingo.com/create/app?source=https://github.com/<Your account>/<Your project>#custom_branch">
   <img src="https://cdn.scalingo.com/deploy/button.svg" alt="Deploy on Scalingo" data-canonical-src="https://cdn.scalingo.com/deploy/button.svg" style="max-width:100%;">
</a>
```

Example:
<a href="https://dashboard.scalingo.com/create/app?source=https://github.com/Scalingo/sample-go-martini/">
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
  "addons": ["redis"]
}
```

You can find everything about the `scalingo.json` file on our [API dedicated page](https://developers.scalingo.com/scalingo-json-schema/).

## Update the Application

To update your application to the latest version of your code, you can use an archive. GitHub is giving you access to an archive with this URL:

```
https://github.com/<Your account>/<Your project>/archive/refs/heads/master.tar.gz
```

To deploy it, you simply have to run this command

```
scalingo --app my-app deploy https://github.com/<Your account>/<Your project>/archive/refs/heads/master.tar.gz
```
