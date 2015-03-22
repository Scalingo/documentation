---
title: Custom NPM modules with Meteor
category: languages
date: 22/03/2015
tags: programming, dev, nodejs, language, meteor, npm
---

# Custom NPM modules with Meteor

## Initialization

### Install the package meteorhacks:npm

```
$ meteor add meteorhacks:npm
                                              
Changes to your project's package version selections:
                                              
meteorhacks:async  added, version 1.0.0       
meteorhacks:npm    added, version 1.2.2
```

### Run the project to initialize the module

```
$ meteor
[[[[[ ~/path/to/app ]]]]]                 

=> Started proxy.                             
=> Started MongoDB.                           
   Loading plugin `initializing-npm-supp...  |

-> creating `packages.json` for the first time.
-> add your npm modules to `packages.json`

=> Creating container package for npm modules

-> npm support has been initialized.
-> please start your app again.
```

### Re-run the project to define the version
```
$ meteor
[[[[[ ~/path/to/app ]]]]]                 

=> Started proxy.                             
=> Started MongoDB.                           
                                              
Changes to your project's package version selections:
                                              
npm-container  added, version 1.0.0           

=> Started your app.                          

=> App running at: http://localhost:3000/
```

At that point your application is initialized to install and deploy custom
NPM modules by adding them to the `packages.json` file at the root of your
project.

## Deployment

Once the application has been initalized, different steps are required to
ensure the application will be deployed correctly.

* Add  the `npm-container` package to your project

```
$ echo 'npm-container' >> .meteor/packages
```

* Check in in your GIT repository all the generated files.

```
$ git add -f packages/npm-container .meteor/packages .meteor/versions packages.json
$ git commit -m "Add NPM package handling"
```

That's it, all the required files are staged for commit:

```
$ git push scalingo master
```

## Common errors:

### NPM support has been initialized

#### Complete message

```
  => Creating container package for npm modules
  
  -> npm support has been initialized.
  -> please start your app again.
  This command has been deprecated in favor of 'meteor build', which allows you
  to build for multiple platforms and outputs a directory instead of a single
  tarball. See 'meteor help build'for more information.
  meteor bundle generation complete.
  Finding dependencies...

fs.js:666
  return binding.readdir(pathModule._makeLong(path));
                 ^
```

#### Solution

Ensure that all the steps in the [deployment](#deployment) part have been done,
this error is directly linked the an oblivion of checking in
`packages/npm-container` to the GIT repository and adding `npm-container` in
the `.meteor/packages` file.

### Unknown package: npm-container

#### Complete message

```
Could not resolve the specified constraints for this project:
Error: unknown package: npm-container
```

#### Solution

This error is due to the fact that the package `npm-container` is present in
the `.meteor/packages` file but that the directory `packages/npm-container` has
not been added correctly to the GIT repository, please ensure this point.
