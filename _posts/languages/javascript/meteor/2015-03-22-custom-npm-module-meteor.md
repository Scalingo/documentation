---
title: Custom NPM modules with Meteor
modified_at: 2015-03-22 00:00:00
category: languages
tags: nodejs meteor npm
permalink: /languages/javascript/nodejs/meteor/npm/
---

## Initialization

### Install the package meteorhacks:npm

{% highlight bash %}
$ meteor add meteorhacks:npm
                                              
Changes to your project's package version selections:
                                              
meteorhacks:async  added, version 1.0.0       
meteorhacks:npm    added, version 1.2.2
{% endhighlight %}

### Run the project to initialize the module

{% highlight bash %}
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
{% endhighlight %}

### Re-run the project to define the version
{% highlight bash %}
$ meteor
[[[[[ ~/path/to/app ]]]]]                 

=> Started proxy.                             
=> Started MongoDB.                           
                                              
Changes to your project's package version selections:
                                              
npm-container  added, version 1.0.0           

=> Started your app.                          

=> App running at: http://localhost:3000/
{% endhighlight %}

At that point your application is initialized to install and deploy custom
NPM modules by adding them to the `packages.json` file at the root of your
project.

## Deployment

Once the application has been initalized, different steps are required to
ensure the application will be deployed correctly.

* Add  the `npm-container` package to your project

{% highlight bash %}
$ echo 'npm-container' >> .meteor/packages
{% endhighlight %}

* Check in in your GIT repository all the generated files.

{% highlight bash %}
$ git add -f packages/npm-container .meteor/packages .meteor/versions packages.json
$ git commit -m "Add NPM package handling"
{% endhighlight %}

That's it, all the required files are staged for commit:

{% highlight bash %}
$ git push scalingo master
{% endhighlight %}

## Common errors:

### NPM support has been initialized

#### Complete message

{% highlight bash %}
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
{% endhighlight %}

#### Solution

Ensure that all the steps in the [deployment](#deployment) part have been done,
this error is directly linked the an oblivion of checking in
`packages/npm-container` to the GIT repository and adding `npm-container` in
the `.meteor/packages` file.

### Unknown package: npm-container

#### Complete message

{% highlight bash %}
Could not resolve the specified constraints for this project:
Error: unknown package: npm-container
{% endhighlight %}

#### Solution

This error is due to the fact that the package `npm-container` is present in
the `.meteor/packages` file but that the directory `packages/npm-container` has
not been added correctly to the GIT repository, please ensure this point.


### error: couldn't read npm version lock information

#### Complete message

{% highlight bash %}
=> Errors while initializing project: 

While building package npm-container: 
error: couldn't read npm version lock information
{% endhighlight %}

### Solution

This error happened when the internal files of `npm-container` are already defined
and that you've added or updated a npm package in your project. To fix this you have
to remove these data from your git repository

{% highlight bash %}
git rm -r --cached packages/npm-container/.npm
echo packages/npm-container/.npm >> .gitignore
git commit -m "remove internal data of npm-container from repository"
git push scalingo master
{% endhighlight %}

That should do the trick and your application will be deployed correctly.

