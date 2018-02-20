---
title: Getting Started with Django
modified_at: 2015-02-17 00:00:00
category: getting-started
tags: python django tutorial getting-started-tutorial
index: 3
permalink: /languages/python/getting-started-with-django/
---

{% include info_tutorial_requirements.md %}

## Initialize your application

```bash
# Create your project
mkdir my-project
cd my-project

# Create a virtualenv
virtualenv venv
source venv/bin/activate

# Install Django toolbelt
pip install django-toolbelt

# Initialize Django project, this command will
# create a manage.py file and a my-app directory
django-admin.py startproject my-app .
```

## Define the how to start your application

You have to create a file named `Procfile` at the root of the project
containing:

```yaml
web: gunicorn my-app.wsgi --log-file -
```

By default, the platform is looking for the web process type to start. The
previous command defines it and tells Gunicorn, the applicative HTTP server, to
display logs on `stdout` to fit the [12-factor](http://12factor.net/)
principles.

## Python app recognition and dependencies definition.

The platform will understand that your app is a __Python__ application if it
contains a `requirements.txt` file at the root of the project. To create it,
your have to run the following command:

```bash
pip freeze > requirements.txt
```

## Create your application and databases on Scalingo

<blockquote class="bg-info">
  You can also use our web dashboard to achieve this operation
</blockquote>

```bash
$ scalingo create my-app
```

* Go on the [dashboard](https://my.scalingo.com/apps) of your application.
* Select the __Addons__ category
* Choose the database you want to use

### PostgreSQL

Nothing to do

### MySQL

By default, only the PostgreSQL driver is installed, you need to replace
it by the MySQL driver.

```bash
pip uninstall psycopg2
pip install mysqlclient
pip freeze > requirement.txt
```

## Application configuration

The configuration of the application has to be done through the environment
variables, no credentials should be present statically in the code. It is
usually a bad practice.

The configuration file in our example is located at `my-app/settings.py`.

### Ensure that the base directory of the application is defined

<blockquote class="bg-info">
  This instruction may be already set according to your Django version
</blockquote>

Add (if not already set) the following definition after the top comment header
of the `my-app/settings.py` file:

```python
import os
BASE_DIR = os.path.dirname(os.path.dirname(__file__))
```

### Configure the Database access

Still in the `my-app/settings.py`, replace:

```python
DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.sqlite3',
        'NAME': os.path.join(BASE_DIR, 'db.sqlite3'),
    }
}
```

With:

```python
import dj_database_url

try:
  database_url = os.environ["DATABASE_URL"]
except KeyError:
  database_url = "file:///{}".format(os.path.join(BASE_DIR, 'db.sqlite3'))

DATABASES = { 'default': dj_database_url.config() }
```

This has no effect on the default behavior. If no `DATABASE_URL` has been set,
the application will fallback on your development backend, sqlite3. However, we
advise you to use the same database in development and in production to ensure
bug free migrations.

### Static file serving

`my-app/settings.py`:

```python
STATIC_ROOT = 'staticfiles'
STATIC_URL = '/static/'

STATICFILES_DIRS = (
    os.path.join(BASE_DIR, 'static'),
)
```

`my-app/wsgi.py`

Replace

```python
from django.core.wsgi import get_wsgi_application
application = get_wsgi_application()
```

With

```python
from django.core.wsgi import get_wsgi_application
from dj_static import Cling

application = Cling(get_wsgi_application())
```

`Cling` is part of the `dj_static` module and is designed to serve static files.

## Save your app with Git

### Setup `.gitignore`

You don't want to keep track of everything on your version control system. To
prevent such files to be added to Git, create the file `.gitignore` at the root
of your project with the following content:

```text
venv
*.pyc
staticfiles
```

### Commit your application

```bash
git init
git add .
git commit -m "Init Django application"
```

## Deploy your application

```bash
git remote add scalingo git@scalingo.com:<app_name>.git
git push scalingo master
```

## Access your application

```bash
…
Waiting for your application to boot...
<-- https://my-app.scalingo.io -->
```
