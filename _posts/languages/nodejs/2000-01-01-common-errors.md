---
title: Node.js Common Errors
nav: Common Errors
modified_at: 2020-06-12 00:00:00
tags: nodejs
index: 3
---

You may experience an error in your Node.js application that many customers
faced when first deploying such application on Scalingo. Here is a list of the
most common error messages.

## devDependencies Also Contain the Build Dependencies

The `devDependencies` section of the package.json file contains both development
dependencies and build dependencies. By default Scalingo deployments install the
dependencies from the `dependencies` section of the package.json file. It may
lead to error messages such as `ng: not found` or `nest: not found`. In such
situation, you have a couple of solutions:

- Install all `devDependencies` ([doc]({% post_url
    languages/nodejs/2000-01-01-start %}#install-devdependencies)).
- Move the `devDependencies` needed for the build into the `dependencies`
    section of the package.json file.
