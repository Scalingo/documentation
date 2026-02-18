---
title: Curator
is_series: true
series: Deploying an Elastic Stack
series_index: 4
modified_at: 2025-08-13
---

**Curator** is a tool that helps curating and managing Elasticsearch®'s indices.
It is especially useful to manage indices lifecycles so that old logs are
automatically removed from your database.


## Deploying

{% note %}
The following instructions are mainly given as examples, in the specific
context described on [the Overview page][elk-overview].\\
Please adjust to fit your needs.
{% endnote %}

1. Curator is written in Python. Consequently, the first step consists of
   adding the Python buildpack to the `.buildpacks` file present in your
   Logstash repository. The file must end up like this ([order is
   important!][multi-buildpack-order]):

   ```text
   https://github.com/Scalingo/buildpack-jvm-common
   https://github.com/Scalingo/python-buildpack
   https://github.com/Scalingo/logstash-buildpack
   ```

2. To instruct the Python buildpack to install Curator and its dependencies,
   create a file named `Pipfile` at the root of your project and add a
   `packages` section to it, with the following dependency:

   ```text
   [packages]
   elasticsearch-curator = "7.0.1"
   ```

   Don't forget to generate the `Pipfile.lock` file and to commit your changes:

   ```bash
   pipenv lock
   git add Pipfile Pipfile.lock
   git commit -m "Add Curator requirements"
   ```

3. To configure the connection to the Elasticsearch database, create a file
   named `curator.yml` with the following content:

   ```yaml
   ---
   client:
     hosts:
       - ${ELASTICSEARCH_HOST}:${ELASTICSEARCH_PORT}
         username: ${ELASTICSEARCH_AUTH_USERNAME}
         password: ${ELASTICSEARCH_AUTH_PASSWORD}

   logging:
     loglevel: INFO
     logfile:
     logformat: default
   ```

   Commit your changes:

   ```bash
   git add curator.yml
   git commit -m "Add Curator configuration"
   ```

4. To configure the database indices lifecycles, create a file named
   `log-clean.yml` with your instructions. The example below asks Curator to
   consider indices prefixed by `LOGS_INDICES_PREFIX` and to remove those older
   than `LOGS_RETENTION_DAYS` days:

   ```yaml
   actions:
     1:
       action: delete_indices
       description: Delete old log indices
       options:
         ignore_empty_list: True
         disable_action: False
       filters:
         - filtertype: pattern
           kind: prefix
           value: ${LOGS_INDICES_PREFIX}
         - filtertype: age
           source: name
           direction: older
           timestring: '%Y.%m.%d'
           unit: days
           unit_count: ${LOGS_RETENTION_DAYS}
   ```

   Don't forger to commit your changes:

   ```bash
   git add log-clean.yml
   git commit -m "Add Curator policies"
   ```

5. Curator is not a daemon, it is designed as a one-off process. To be able
   to run it on Scalingo on a regular basis, we advise to leverage our
   [Scheduler][scheduler].

   At the root of your Logstash repository, create a file named `cron.json` to
   setup the recurring task. The following example starts curator everyday at
   03:00 (3 AM) and 15:00 (3 PM):

   ```json
   {
     "jobs": [
       {
         "command": "0 3,15 * * * curator --config curator.yml log-clean.yml"
       }
     ]
   }
   ```

   Commit your changes:

   ```bash
   git add cron.json
   git commit -m "Add Curator cron job"
   ```

6. The configuration files mention several environment variables. Let's
   identify them and their values:

   - `LOGS_RETENTION_DAYS`: retention period of logs, expressed in days.
   - `LOGS_INDICES_PREFIX`: indices prefix that helps identify logs affected by
     the policy. If you are following our guides, the value should be
     `unicorns-`
   - `ELASTICSEARCH_HOST`\
     `ELASTICSEARCH_PORT`\
     `ELASTICSEARCH_AUTH_USERNAME`\
     `ELASTICSEARCH_AUTH_PASSWORD` must be retrieved from the value of the
     existing `ELASTICSEARCH_URL`. To do so, remember that it is made of
     several components separated one from each other by a delimiter, like so:

     ```text
     http://<user>:<password>@<host>:<port>
     ```

     The very last steps depends on the method chosen to deploy the Logstash
     instance.

### Using the Command Line

1. Make sure you have followed [the first steps](#deploying)

2. Create the required environment variables:

   ```bash
   scalingo --app my-logstash env-set LOGS_RETENTION_DAYS=10
   scalingo --app my-logstash env-set LOGS_INDICES_PREFIX="unicorns-"
   scalingo --app my-logstash env-set ELASTICSEARCH_HOST=...
   scalingo --app my-logstash env-set ELASTICSEARCH_PORT=...
   scalingo --app my-logstash env-set ELASTICSEARCH_AUTH_USERNAME=...
   scalingo --app my-logstash env-set ELASTICSEARCH_AUTH_PASSWORD=...
   ```
3. Push the updated code to trigger a new deployment:

   ```bash
   git push scalingo master
   ```

### Using the Terraform Provider

1. Make sure you have followed [the first steps](#deploying)

2. Edit the `scalingo_app` resource in your Terraform file to add the
   environment variables, like so:

   ```terraform
   resource "scalingo_app" "my-logstash" {
     [...]

     environment = {
       [...]
       LOGS_RETENTION_DAYS = 10,
       LOGS_INDICES_PREFIX = "unicorns-"

       ELASTICSEARCH_HOST  = "..."
       ELASTICSEARCH_PORT  = "..."
       ELASTICSEARCH_AUTH_USERNAME = "..."
       ELASTICSEARCH_AUTH_PASSWORD = "..."
     }
   }
   ```

3. Run `terraform plan` and check if the result looks good

4. If so, run `terraform apply`

5. Once Terraform is done, trigger a new deployment:
   1. Head to your [dashboard]
   2. Click on your Logstash application
   3. Click on the **Deploy** tab
   4. Click on **Manual deployment** in the left menu
   5. Click the **Trigger deployment** button


## Updating

{% note %}
- When using Curator with a Scalingo for Elasticsearch® addon, and as long as
  we are [stuck with this constraint][elk-contraint], we strongly recommend to
  stick with version `7.0.1` of Curator.
- However, you are free to deploy a specific version of your choice.
{% endnote %}

### Using the Command Line

1. In your Logstash repository, edit the `requirements.txt` file to specify the
   version you want to deploy:

   ```txt
   elasticsearch-curator==8.0.15
   ```

2. Don't forget to commit the change:

   ```bash
   git add requirements.txt
   git commit -m "Update Curator to 8.0.15"
   ```

3. Trigger a new deployment:

   ```bash
   git push scalingo master
   ```

### Using the Terraform Provider

1. In your Logstash repository, edit the `requirements.txt` file to specify the
   version you want to deploy:

   ```txt
   elasticsearch-curator==8.0.15
   ```

2. Commit the change and push it to your remote repository:

   ```bash
   git add requirements.txt
   git commit -m "Update Curator to 8.0.15"
   git push origin master
   ```

3. Trigger a new manual deployment if it's not automated:

   1. Head to your [dashboard]
   2. Click on your Logstash application
   3. Click on the **Deploy** tab
   4. Click on **Manual deployment** in the left menu
   5. Click the **Trigger deployment** button


## Customizing

### Configuring

Curator can use a [configuration file][elastic-config-file]. This file is
mostly used to configure the Elasticsearch® database connection (URL,
credentials, ...), as well as the logging settings. This file is written in
YAML. In our previous examples, it's named `curator.yml`.

Curator also requires an [action file][elastic-action-file]. This file
describes the list of actions Curator will run along with their options. This
file is written in YAML. In our previous examples, it's named `log-clean.yml`.

### Environment

Curator is able to use environment variable references in both the
configuration file and the action file. This allows to set values that need to
be configurable at runtime. This makes it very convenient to customize your
Curator deployment, since you can create as many environment variables as you
want.

To do this, use the following syntax in your YAML files:

```yaml
${MY_ENV_VAR}
```

It's also possible to set a default value to use when the environment variable
is not defined (otherwise, Curator falls back to a value of `None`):

```yaml
${MY_ENV_VAR:default_value}
```


[elastic-config-file]: https://www.elastic.co/guide/en/elasticsearch/client/curator/current/configfile.html
[elastic-action-file]: https://www.elastic.co/guide/en/elasticsearch/client/curator/current/actionfile.html

[dashboard]: https://dashboard.scalingo.com/apps/

[elk-overview]: {% post_url platform/getting-started/getting-started-with-elk/2000-01-01-overview %}
[elk-constraint]: {% post_url platform/getting-started/getting-started-with-elk/2000-01-01-overview %}#planning-your-deployment
[scheduler]: {% post_url platform/app/task-scheduling/2000-01-01-scalingo-scheduler %}
[multi-buildpack-order]: {% post_url platform/deployment/buildpacks/2000-01-01-multi %}#does-the-buildpack-order-matter
