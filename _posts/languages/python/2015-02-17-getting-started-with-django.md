---
title: Getting Started with Django
modified_at: 2015-02-17 00:00:00
category: getting-started
tags: python, django, tutorial,
---

# Getting started with Django

{% include info_tutorial_requirements.md %}

## Initialize your application

{% highlight bash %}
# Create your project
mkdir myproject
cd myproject

# Create a virtualenv
virtualenv venv
source venv/bin/activate

# Install django toolbelt
pip install django-toolbelt

# Initialize django project, this command will
# create a manage.py file and a myapp directory
django-admin.py startproject myapp .
{% endhighlight %}

## Define the how to start your application

You have to create a file named `Procfile` at the root of the project.

{% highlight yaml %}
web: gunicorn myapp.wsgi --log-file -
{% endhighlight %}

By default, the platform is looking for the web process type to start,
the previous command defines it and tell gunicorn, the applicative HTTP
server to display logs on `stdout` to fit the [12 factor](http://12factor.net/)
principles.

## Python app recognition and dependencies definition.

The platform will understand that your app is a __Python__ application if
it contains a `requirements.txt` file. To create it, your have to run the
following command:

{% highlight bash %}
pip freeze > requirements.txt
{% endhighlight %}

## Create your application and databases on Scalingo

<blockquote class="info">
  You can also use our web dashboard to achieve this operation
</blockquote>

{% highlight bash %}
$ scalingo create django-app
{% endhighlight %}

* Go on the [dashboard](https://my.scalingo.com/apps) of your application.
* Select the __Addons__ category
* Choose the database you want to use

### PostgreSQL

Nothing to do

### MySQL

By default, only the PostgreSQL driver is installed, you need to replace
it by the MySQL driver.

{% highlight bash %}
pip uninstall psycopg2
pip install mysqlclient
pip freeze > requirement.tt
{% endhighlight %}

## Application configuration

The configuration of the application has to be done throught the environment
variables, no credentials should be present statically in the code, it is usually
a bad practice.

The configuration file in our example is located at `myapp/settings.py`.

### Ensure that the base directory of the application is defined

<blockquote class="info">
  This instruction may be already set according to your Django version
</blockquote>

Add (if not already set) the following definition after the top comment header of
the `myapp/settings.py` file:

{% highlight python %}
import os
BASE_DIR = os.path.dirname(os.path.dirname(__file__))
{% endhighlight %}

### Configure the Database access

Replace:

{% highlight python %}
DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.sqlite3',
        'NAME': os.path.join(BASE_DIR, 'db.sqlite3'),
    }
}
{% endhighlight %}

With:

{% highlight python %}
import dj_database_url

try:
  database_url = os.environ["DATABASE_URL"]
except KeyError:
  database_url = "file:///{}".format(os.path.join(BASE_DIR, 'db.sqlite3'))

DATABASES = { 'default': dj_database_url.config() }
{% endhighlight %}

This has no effect on the default behaviour, if no `DATABASE_URL` has been set,
the application will fallback on your development backend, sqlite3. However,
we advise you to use the same database in development and in production to ensure
bugfree migrations.

### Static file serving

`myapp/settings.py`:

{% highlight python %}
STATIC_ROOT = 'staticfiles'
STATIC_URL = '/static/'

STATICFILES_DIRS = (
    os.path.join(BASE_DIR, 'static'),
)
{% endhighlight %}

`myapp/wsgi.py`

Replace

{% highlight python %}
from django.core.wsgi import get_wsgi_application
application = get_wsgi_application()
{% endhighlight %}

With

{% highlight python %}
from django.core.wsgi import get_wsgi_application
from dj_static import Cling

application = Cling(get_wsgi_application())
{% endhighlight %}

`Cling` is part of the `dj_static` module and is designed to serve static files.

## Save your app with GIT

### Setup Gitignore

You don't want to save everything, create the file `.gitignore` at the root of
your project with the following content:

{% highlight text %}
venv
*.pyc
staticfiles
{% endhighlight %}

### Commit your application

{% highlight bash %}
git init
git add .
git commit -m "Init Django application"
{% endhighlight %}

## Deploy your application

{% highlight bash %}
git remote add scalingo git@scalingo.com:<app_name>.git
git push scalingo master
{% endhighlight %}

## Access your application

{% highlight bash %}
…
Waiting for your application to boot...
<-- https://django-app.scalingo.io -->
{% endhighlight %}
