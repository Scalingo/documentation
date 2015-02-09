---
title: NodeJS
category: languages
date: 09/02/2015
tags: programming, dev, nodejs, language
---

# Support

NodeJS is supported by Scalingo, furthermore, custom support has been added
to manage the [__meteor__](/languages/nodejs/meteor.html) framework.

* [Getting Started with NodeJS](/languages/nodejs/getting-started-with-nodejs.html)
* [Getting Started with Meteor](/languages/nodejs/getting-started-with-meteor.html)

## Buildpack

[NodeJS Buildpack](https://github.com/Scalingo/appsdeck-buildpack-nodejs)

## Standard node applications

### Detection

The file `package.json` should be present at the root of the project.

### Compilation

The dependencies of your project are installed according to the
`package.json` content using `npm`.

### Application Start

What we use in order of priority

1. `Procfile` at the root of your project
2. The field `.scripts.start` defined in your `package.json` 
3. We start `server.js` if present.

## Meteor application

### Detection

The directory `.meteor` should be present at the root of your project

### Compilation

There are different way to install dependencies in your `meteor` project.

#### Meteor ≤ v0.8

* [meteorite](https://github.com/oortcloud/meteorite/): your have to add
`smart.json` and `smart.lock` to your repository.
* [npm](https://www.npmjs.org/): you can use any standard nodejs module
in your project: [Guide](https://meteorhacks.com/complete-npm-integration-for-meteor.html)

#### Meteor ≥ v0.9

Methods from v0.8 still work when using v0.9 but have been deprecated, you
should consider migrating your application.

* Using meteor embedded dependency management (with `meteor add` and `meteor update`)
* `npm` using [meteorhacks:npm](https://github.com/meteorhacks/npm) package.

#### Demeteorizer

[`demeteorizer`](https://github.com/onmodulus/demeteorizer) is used to deploy your
meteor applications. It uses `meteor build|bundle` to package your meteor application,
then generate the correct `package.json` in order to install the modules with
`npm`.

Dependencies defined in the `packages.json` (with an 's') are detected by the
npm module then injected in the final `package.json`. Then `npm` is able to
install all the dependencies of your app.

### Application start

As `demeteorizer` changes the structure of your app, it generates automatically
a `Procfile` to start your application.

Generated Procfile:

```yml
web: cd demeteorized && npm start
```

If your wish to write your own `Procfile` don't forget to keep this line for your
`web` process, otherwise your application may not boot.
