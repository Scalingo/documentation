---
title: Common Mistakes when Deploying Ruby Apps
nav: Common Deployment Mistakes
modified_at: 2020-09-23 10:00:00
tags: ruby
---

### Incorrect binstubs - bad shebang line

A "binstub" is an abbreviation for "binary stub". It consists in a small script
generated automatically most of the time by `bundler` or other gems used in
your project. Usually, they are placed into the `bin/` directory of your
application.

The shebang of a script like a binstub is its first line, usually starting with

```
#!/usr/bin/env <executable>
```

A sign that a binstub with an invalid shebang has been added in your project is
if one of the following error is appearing when building or running your app:

```
"Your Ruby version is 2.5.1, but your Gemfile specified 2.6.6"
```

```
"Activating bundler (>= 0.a) failed ... Could not find 'bundler' (>= 0.a)"
```

```
You have already activated bundler 1.17.2, but your Gemfile requires bundler 1.17.3
```

Check the first line of the binstubs of your project, it might happen that the
shebang was modified to another value to specify a ruby version

```
#!/usr/bin/env ruby2.5
```

This method is invalid for ruby scripts, it should always look like:

```
#!/usr/bin/env ruby
```
