---
title: Logstash
is_series: true
series: Deploying an Elastic Stack
series_index: 2
modified_at: 2026-02-23
---

**Logstash** is a data processing pipeline, able to take multiple sources of
data as input. It allows to format and modify data on the fly before forwarding
them to the chosen destination.


## Planning your Deployment

- We are currently stuck with an important [constraint][elk-constraint] related
  to Elasticsearch®. Scalingo provides a version of Logstash that is compatible
  with this constraint **in the `es7-compat` branch** of the
  [logstash-scalingo] repository. By default, this branch allows to deploy the
  latest version of Logstash compatible with Elasticsearch `7.10.2`.

- Sizing Logstash vastly depends on your use-case and the amount of data
  processed. We usually recommend to start with an L container, and adjust
  later depending on the metrics of your Logstash instance.


## Deploying

### Using the Command Line

We maintain a repository called [logstash-scalingo] on GitHub to help you
deploy Logstash on Scalingo. Here are the few additional steps you will have to
follow:

1. Clone the `es7-compat` branch of our repository:

   ```bash
   git clone -b es7-compat --single-branch https://github.com/Scalingo/logstash-scalingo.git
   cd logstash-scalingo
   ```

2. Update your `es7-compat` branch name to `master` or `main`:

   ```bash
   git branch -m master
   ```

3. Create the application on Scalingo:

   ```bash
   scalingo create my-logstash
   ```

   Notice that our Command Line automatically detects the git repository, and
   adds a git remote to Scalingo:

   ```bash
   git remote -v

   origin   https://github.com/Scalingo/logstash-scalingo (fetch)
   origin   https://github.com/Scalingo/logstash-scalingo (push)
   scalingo git@ssh.osc-fr1.scalingo.com:my-logstash.git (fetch)
   scalingo git@ssh.osc-fr1.scalingo.com:my-logstash.git (push)
   ```

4. Scale the container to an L size:

   ```
   scalingo --app my-logstash scale web:1:L
   ```

5. Provision a Scalingo for Elasticsearch® Starter 512 addon:

   ```bash
   scalingo --app my-logstash addons-add elasticsearch elasticsearch-starter-512
   ```

6. Edit the `logstash.conf` file to change the index name of the Elasticsearch®
   output. The goal is to make it fit semantically to the data being ingested:

   ```
   output {
     elasticsearch {
       [...]
       # OLD
       index => "change-me-%{+YYYY.MM.dd}"
       # NEW
       index => "unicorns-%{+YYYY.MM.dd}"
     }
   }
   ```

   Don't forget to commit your changes:

   ```bash
   git add logstash.conf
   git commit -m "Update the index name"
   ```

7. Create a few environment variables to protect your Logstash instance via
   HTTP basic auth (not everyone should be able to send data to your
   instance!):

   ```bash
   scalingo --app my-logstash env-set USER=logstash-username
   scalingo --app my-logstash env-set PASSWORD=logstash-password
   ```

8. Everything's ready, deploy to Scalingo:

   ```bash
   git push scalingo master
   ```

### Using the Terraform Provider

1. Start by forking our [Logstash repository][logstash-scalingo]

2. Place the following block in your Terraform file to create the app:

   ```terraform
   resource "scalingo_app" "my-logstash" {
     name        = "my-logstash"
     force_https = true

     environment = {
       USER     = "<logstash-username>"
       PASSWORD = "<logstash-password>"
     }
   }
   ```

3. Link the app to your forked repository:

   ```terraform
   data "scalingo_scm_integration" "github" {
     scm_type = "github"
   }

   resource "scalingo_scm_repo_link" "default" {
     auth_integration_uuid = data.scalingo_scm_integration.github.id
     app                   = scalingo_app.my-logstash.id
     source                = "https://github.com/<username>/logstash-scalingo"
     branch                = "es7-compat"
   }
   ```

4. Provision a Scalingo for Elasticsearch® addon and attach it to your app:

   ```terraform
   resource "scalingo_addon" "my-logstash-elasticsearch" {
     app         = scalingo_app.my-logstash.id
     provider_id = "elasticsearch"
     plan        = "elasticsearch-starter-512"
   }
   ```

5. (optional) Instruct the platform to run the `web` process type in a single
   L container:

   ```terraform
   resource "scalingo_container_type" "web" {
     app    = scalingo_app.my-logstash.id
     name   = "web"
     size   = "L"
     amount = 1
   }
   ```

6. Edit the `logstash.conf` file to change the index name of the Elasticsearch®
   output. The goal is to make it fit semantically to the data being ingested:

   ```
   output {
     elasticsearch {
       [...]
       # OLD
       index => "change-me-%{+YYYY.MM.dd}"
       # NEW
       index => "unicorns-%{+YYYY.MM.dd}"
     }
   }
   ```

   Don't forget to commit your changes:

   ```bash
   git add logstash.conf
   git commit -m "Update the index name"
   git push
   ```

7. Run `terraform plan` and check if the result looks good

8. If so, run `terraform apply`

9. Once Terraform is done, your Logstash instance is provisioned and ready to
   be deployed. This requires an extra manual step:
   1. Head to your [dashboard]
   2. Click on your Logstash application
   3. Click on the **Deploy** tab
   4. Click on **Manual deployment** in the left menu
   5. Click the **Trigger deployment** button
   6. After a few seconds, your Logstash instance is finally up and running!


## Testing

1. Once your Logstash is up and running, you can try to send some data to it:

   ```bash
   curl --request POST 'https://<logstash-username>:<logstash-password>@my-logstash.osc-fr1.scalingo.io?name=whatever' --data 'Hello World!'
   ok
   ```

2. Check the indices that are stored in the Elasticsearch® database:

   ```bash
   scalingo --app my-logstash run bash

   > curl $SCALINGO_ELASTICSEARCH_URL/_cat/indices
   yellow open unicorns-2024.06.04 _0XNpJKzQc2kjhTyxf4DnQ 5 1 1 0 6.6kb 6.6kb
   ```

3. Logstash has created the `unicorns` index which can now be requested:

   ```bash
   > curl $SCALINGO_ELASTICSEARCH_URL/unicorns-2024.06.04/_search | json_pp
   {
      "_shards" : {
        // [...]
      },
      // [...]
      "hits" : {
        "total" : 1,
        "max_score" : 1,
        "hits" : [
          {
            "_type" : "logs",
            "_score" : 1,
            "_source" : {
               "name" : "whatever",
               "message" : "Hello World!",
               "url" : "?name=whatever",
               "@timestamp" : "2024-06-04T11:57:03.155Z"
               // [...]
            },
            // [...]
          }
        ]
      }
    }
    ```

   The result of the above search confirms that the index contains a document
   having a field `name` set to `whatever` and a field `message` set to
   `Hello World!`.


## Updating

Scalingo maintains compatibility with the Elasticsearch® instances we provide
in the `es7-compat` branch of our [logstash-scalingo] repository.

Consequently, updating Logstash consists in pulling the changes from the
`es7-compat` branch:

1. From your Logstash repository:
   ```bash
   git pull origin es7-compat
   ```

{% note %}
You can use the dedicated [environment variable](#environment) to deploy a
specific version of your choice.\\
Please note that **we do not** give any guarantee if you chose to do so.\\
This may require some adjustments, not work at all, or even end up with data
loss!
{% endnote %}

### Using the Command Line

1. Make sure you've successfully followed [the first steps](#updating)
2. Send the updated version to Scalingo:
   ```bash
   git push scalingo master
   ```

### Using the Terraform Provider

1. Make sure you’ve successfully followed [the first steps](#updating)
2. Push the changes to your repository:
   ```bash
   git push origin master
   ```

3. Head to your [dashboard]
4. Click on your Logstash application
5. Click on the **Deploy** tab
6. Click on **Manual deployment** in the left menu
7. Click the **Trigger deployment** button
8. After a few seconds, your updated Logstash instance is ready!


## Customizing

### Configuring

The repository we provide help deploy your Logstash instance comes with a
directory named `config`. All the files contained in this directory are copied
in the Logstash configuration directory at runtime, allowing you to precisely
customize your instance.

For example, if you'd want to modify the logging behavior of Logstash, you
could edit the `config/log4j2.yml` file.

### Interfacing with Log Drains

**[Log drains][log-drains]** are a Scalingo feature that, once activated,
automatically sends every log line generated by an application to the
configured destinations.

To make a log drain forward logs to a Logstash instance, use the **elk** type
of log drain:

```bash
scalingo --app my-app log-drains-add --type elk --url <logstash_url>
```

With `logstash_url` being the URL of your Lostash app.

The elk log drain sends the log entries over HTTP, with a `content-type` header
set to `plain/text`.\\
The application name (`appname`) and the container name (`hostname`) are passed
as query parameters and the log entry itself is in the request body.

Our [logstash-scalingo] repository contains a few basic examples of
configuration, known to work with our log drain. Feel free to adjust to your
needs.

### Environment

The following environment variable(s) can be leveraged to customize your
deployment:

- **`USER`**\\
  Logstash administrator account name.\\
  **mandatory**

- **`PASSWORD`**\\
  Logstash administrator password.\\
  **mandatory**

- **`LOGSTASH_PLUGINS`**\\
  Comma separated [list of plugins][logstash-plugins] to install.\\
  Defaults to not being set.

- **`LOGSTASH_VERSION`**\\
  Version of Logstash to deploy.\\
  Unless specified, buildpack deploys version `7.17.29`.\\
  Defaults to not being set.


[logstash-scalingo]: https://github.com/Scalingo/logstash-scalingo/tree/es7-compat
[logstash-plugins]: https://github.com/logstash-plugins

[dashboard]: https://dashboard.scalingo.com/apps/

[log-drains]: {% post_url platform/app/2000-01-01-log-drain %}

[elk-constraint]: {% link _tutorials/elk/overview.md %}#planning-your-deployment
