---
title: Python
category: languages
date: 05/04/2015
tags: programming, dev, python, language
---

# Python

The python Language is supported

## Detection

To ensure our deployment system considers your application as a Python application,
a file `requirements.txt` should be present at the root of your project, defining
the dependencies of your app.

## Versions

Python 2 and Python 3 are both completely supported, you can specify the runtime version in th
`runtime.txt` file at the root of your repository.

Example of `runtime.txt` which would install python 3.4.1:

```
3.4.1
```

## Frameworks

We handle most of the common frameworks. Obviously, Django is among them. You just need ton
configure your application to bind the port defined by the environment variable `$PORT`

* [Getting Started with Django](/languages/python/getting-started-with-django.html)

## Buildpack

[Link to Python Buildpack](https://github.com/Scalingo/heroku-buildpack-python)
