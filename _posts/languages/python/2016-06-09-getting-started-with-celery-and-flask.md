---
title: Tutorial Celery and Flask
modified_at: 2016-06-09 00:00:00
category: python
tags: celery flask redis tutorial getting-started-tutorial
index: 15
---


{% include info_tutorial_requirements.md %}

## Initialize your application

```bash
$ mkdir celery-flask-app
$ cd celery-flask-app
$ pip install virtualenv
$ virtualenv venv
$ . venv/bin/activate
```

## Application infrastructure

Our goal is to create two applications communicating via redis using the Celery platform:
  * The Celery app that will provide a custom hello task
  * The Flask app that will provide a web server that will send a task to the Celery app and display the answer in a web page.

The redis connection URL will be send using the `REDIS_URL` environment variable.

## Create a Celery server

### Install celery

```bash
pip install celery
pip install redis
```

### Defining a custom task

task.py

```python
import celery
import os

app = celery.Celery('scalingo-sample')


app.conf.update(BROKER_URL=os.environ['REDIS_URL'],
                CELERY_RESULT_BACKEND=os.environ['REDIS_URL'])
@app.task
def hello(name):
    return "Hello "+name
```

## Create a Flask server

### Install Flask

```bash
pip install Flask
```

### Creating a custom web server

app.py

```python
import os
from flask import Flask
from flask import render_template
from flask import request

app = Flask(__name__)

@app.route("/")
def hello():
    return render_template('index.html')

if __name__ == "__main__":
    port = int(os.environ.get("PORT", 5000))
    app.run(host='0.0.0.0', port=port)
```

templates/index.html

```html
<!DOCTYPE html>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
	<title>Celery Flask Application</title>
</head>
<body>
<h1>Greetings from Scalingo</h1>
</body>
</html>
```

### Communication between Celery and Flask

In order to have some communication between Flask and Celery, we will provide a form that will take user input, send it to Celery, get the Celery response and display it on the Web page.

app.py

```python
import os
from flask import Flask
from flask import render_template
from flask import request

import task

app = Flask(__name__)

@app.route("/")
def hello():
    name = request.args.get('name', 'John doe')
    result = task.hello.delay(name)
    result.wait()
    return render_template('index.html', celery=result)

if __name__ == "__main__":
    port = int(os.environ.get("PORT", 5000))
    app.run(host='0.0.0.0', port=port)
```

templates/index.html

```html
<!DOCTYPE html>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
	<title>Celery Flask Application</title>
</head>
<body>
  <h1>Greetings from Scalingo</h1>
  {% raw %}
  <h2> Celery returned: {{ celery.result }} </h2>
  {% endraw %}

  <form method="GET" action="/">
    <label for="name"> Enter your name : </label>
    <input type="text" name="name"/>
    <input type="submit"/>
  </form>
</body>
</html>
```

## Define how to start your application

Procfile

```yaml
worker: celery worker --app=task.app
web: python app.py
```

## Freeze all your dependencies
```bash
$ pip freeze > requirements.txt
```

## Commit your application
```bash
$ git init
$ echo "venv/" >> .gitignore
$ echo "*.pyc" >> .gitignore
$ git add .
$ git commit -m "Base Celery and flask application"
```

## Create your application on Scalingo

```bash
$ scalingo create flask-celery-app
```

## Add a redis addon to your app
```bash
$ scalingo -a flask-celery-app addons-add scalingo-redis free
```

## Deploy your app

```bash
$ git push scalingo master
```

## Scaling your application

By default scalingo only launch your web application. You must manually start the worker container

```bash
$ scalingo -a flask-celery-app scale web:1 worker:1
```

## Live demo

This application is currently running on scalingo [here]( https://sample-python-celery.scalingo.io).
