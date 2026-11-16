---
title: Creating a File-Scanning API with ClamAV
logo: clamav
category: security
products:
  - Projects
  - Private Networks
  - Application Firewall
kind: demo
permalink: /tutorials/clamav
modified_at: 2026-10-30
last_reviewed_at: 2026-10-30
---

**[ClamAV]** is a free, open-source antivirus engine designed to detect
malware, viruses, trojans, and other malicious threats in files. Widely used in
server environments, it provides a lightweight and flexible solution for
integrating malware detection into applications and automated workflows.

ClamAV can be used to scan individual files, directories, or documents uploaded
by users. One of its key strengths is its ability to act as a centralized
scanning service, allowing multiple applications to submit files for analysis
over a network. This makes it particularly useful for web applications,
file-sharing platforms, and document-processing pipelines.

While it is not intended to replace comprehensive endpoint protection
solutions, it excels at providing an additional layer of security for
applications handling untrusted files. Its open-source nature, straightforward
integration, and compatibility with Linux environments make it a practical
choice for applications deployed on platforms such as Scalingo.

{% note %}
**The main purpose of this demo is to showcase how to deploy ClamAV**. To make
the example a little more engaging and spark some inspiration, we've also
included a small application that interacts with ClamAV and demonstrates how it
can be integrated into a real-world use case.

Keep in mind that this application is purely illustrative. It's here to help
you explore the possibilities, rather than serve as a production-ready
solution.
{% endnote %}


## Planning your Deployment

- This project is built around two main components:

  The **ClamAV service** runs the `clamd` and `freshclam` daemons. `clamd`
  listens for incoming connections on TCP port `3310`. It receives files
  through ClamAV's native protocol, scans them for potential threats, and
  returns the scanning results.

  The **API** exposes an HTTP endpoint that allows clients to upload files for
  scanning. Upon receiving a file, the API forwards it to the ClamAV service
  for analysis, then returns the scanning results to the client in JSON format.
  It is written in Python using the Flask framework.

- Each component is deployed as part of a [Project][project], in the same
  [Private Network][private-networking]:

  - Running inside a Private Network allows `clamd` to bind any port, which
    simplifies the deployment.

  - By listening only on the private interface, we make sure ClamAV is not
    exposed to the Internet.

  - [Application Firewall][application-firewall] restricts the access to the
    API to a few specified IP addresses, ensuring a first layer of security.

{:#db-reload}
- ClamAV requires quite a lot of RAM because it loads the complete virus
  definition database into memory. This allows it to be fast. During a database
  reload, ClamAV's default behavior is to temporarily start a second scanning
  engine while scanning continues using the first engine. New scans are handled
  by the second engine, while the first one finishes its tasks. The first
  engine is removed as soon as all its scans have completed. \
  Consequently, when a database reload occurs, ClamAV uses roughly twice as
  much memory as during nominal operations because two databases are loaded at
  the same time. That's why we recommend to provision at least one 2XL
  container.


## Creating the Project

### Using the Command Line

1. From the command line, create a new [Project][project] to host the
   applications:
   ```bash
   scalingo projects-add clamav
   ```

2. Retrieve the project ID:
   ```bash
   scalingo projects
   ```

   The output should look like this:
   ```
    /!\  This command only displays projects where you are the owner
   ┌────────┬─────────┬──────────────────────────────────────────┬─────────────────┐
   │  NAME  │ DEFAULT │                    ID                    │ PRIVATE NETWORK │
   ├────────┼─────────┼──────────────────────────────────────────┼─────────────────┤
   │ clamav │ false   │ prj-32232e93-8c8a-4898-8a68-d10ff1e63f7a │ true            │
   ```

3. Identify the project you just created and keep its ID aside.

### Using the Terraform Provider

1. Place the following `scalingo_project` resource block in your Terraform
   file:
   ```tf
   resource "scalingo_project" "clamav-prj" {
     name    = "clamav"
     default = false
   }
   ```


## Deploying the ClamAV Service

### Using the Command Line

FIXME:
1. Fork our 

2. Create a new application **in the project**:
   ```bash
   scalingo create my-clamav --project-id <project_id>
   ```
   With `project_id` being the ID of the newly created project.

3. Let the platform know what buildpack it must use:
   ```bash
   scalingo --app my-clamav env-set BUILDPACK_URL=https://github.com/Scalingo/clamav-buildpack
   ```

4. Add a [`Procfile`][procfile] to your git repository, with the following
   content:
   ```yml
   clamav: /app/clamav/bin/start.sh clamd && /app/clamav/bin/start.sh freshclam
   ```

5. Ensure ClamaV listens on the private network interface:
   ```bash
   scalingo --app my-clamav env-set CLAMAV_TCP_ADDR=\$SCALINGO_PRIVATE_HOSTNAME
   ```

6. (optional) Chose a port for ClamAV to listen to:
   ```bash
   scalingo --app my-clamav env-set CLAMAV_TCP_PORT=3310
   ```

7. Instruct the platform to not try to start a `web` process type:
   ```bash
   scalingo --app my-clamav scale web:0:M
   ```

8. (recommended) Instruct the platform to run the `clamav` process type in one
   2XL container:
   ```bash
   scalingo --app my-clamav scale clamav:1:2XL
   ```

### Using the Terraform Provider

1. Fork our [ClamAV repository][clamav-scalingo]

2. Place the following `scalingo_app` resource block in your Terraform file:
   ```tf
   resource "scalingo_app" "clamav-app" {
     name           = "my-clamav"
     project_id     = scalingo_project.clamav-prj.id
     stack_id       = "scalingo-26"

     environment = {
       BUILDPACK_URL    = "https://github.com/Scalingo/clamav-buildpack",
       CLAMAV_VERSION   = "<version>",
       CLAMAV_TCP_ADDR  = FIXME(env('SCALINGO_PRIVATE_HOSTNAME')),
       CLAMAV_TCP_PORT  = 3301
     }
   }
   ```

3. Link the app to its repository:
   ```tf
   data "scalingo_scm_integration" "github" {
     scm_type = "github"
   }

   resource "scalingo_scm_repo_link" "clamav-repo" {
     auth_integration_uuid = data.scalingo_scm_integration.github.id
     app                   = scalingo_app.clamav-app.id
     source                = "https://github.com/<username>/clamav-scalingo"
     branch                = "master"
   }
   ```

4. Add a [`Procfile`][procfile] to your git repository, with the following
   content:
   ```yml
   clamav: FIXME
   ```
   This instructs the platform to start ClamAV in a [process type][procfile]
   named `clamav`, which, unlike `web`, can **not** be publicly exposed.

5. (optional) Instruct the platform to run the `clamav` process type in one 2XL
   container:
   ```tf
   resource "scalingo_container_type" "clamav-container" {
     app    = scalingo_app.clamav-app.id
     name   = "clamav"
     size   = "2XL"
     amount = 1
   }
   ```

6. Run `terraform plan` and check if the result looks good

7. If so, run `terraform apply`

8. Once Terraform is done, your ClamAV instance is ready to be deployed:
   1. Head to your [dashboard]
   2. Click on your ClamAV application
   3. Click on the Deploy tab
   4. Click on Manual deployment in the left menu
   5. Click the Trigger deployment button
   6. After a few seconds, your ClamAV instance is finally up and running!


## Deploying the API App

{% note %}
**This example app is intentionally minimal**. \\
For production use, configure file-size and scan limits consistently, validate
responses strictly, limit concurrent scans, and protect the endpoint with
authentication and rate limiting.
{% endnote %}


## Protecting the API App

### Using the Command Line

1. Add a rule to restrict access to the API to the specified IP range:
   ```bash
   scalingo --app my-clamav app-firewall-rule-add --cidr 203.0.113.42/28 --label "Access from Paris Office"
   ```

### Using the Terraform Provider

1. Add the following `scalingo_app_firewall_rule` resource block to your
   Terraform file:
   ```tf
   resource "scalingo_app_firewall_rule" "fw-paris-office" {
     app   = scalingo_app.clamav-app.id
     cidr  = "203.0.113.42/28"
     label = "Access from Paris Office"
   }
   ```


## Updating

## Customizing

### Environment

The ClamAV buildpack makes use of the following environment variables. They can
be leveraged to customize your deployment:

- `CLAMAV_VERSION` \\
  Version of ClamAV to deploy. \\
  Defaults to not being set, which falls back on the default version set in the
  [buildpack inventory file][buildpack-inventory].

- `CLAMAV_DATABASE_DIR` \\
  Path to the directory containing ClamAV's virus signature databases.\\
  Defaults to `/app/clamav/db`.

- `CLAMAV_DATABASE_MIRROR` \\
  Defaults to `database.clamav.net`.

- `CLAMAV_TCP_ADDR` \\
  IP address that ClamAV's `clamd` daemon binds to for TCP connections.\\
  Defaults to being unset, unless `CLAMAV_TCP_PORT` is set, in which case it
  defaults to `127.0.0.1`.

- `CLAMAV_TCP_PORT` \\
  TCP port on which ClamAV's `clamd` daemon listens for connections.\\
  Defaults to being unset, unless `CLAMAV_TCP_ADDR` is set, in which case it
  defaults to `3310`.

- `CLAMAV_LOCAL_SOCKET` \\
  Path to the Unix socket used for local communication with ClamAV's `clamd`
  daemon.\\
  Defaults to not being set.

- `CLAMAV_DISABLE_CLAMD` \\
  When set (to any value), prevents ClamAV's `clamd` daemon to start.\\
  This is NOT recommended for classical usecases.\\
  Default to not being set.

- `CLAMAV_DISABLE_FRESHCLAM` \\
  When set (to any value), prevents ClamAV's `freshclam` daemon to start.\\
  This is NOT recommended for classical usecases.\\
  Defaults to not being set.

- `CLAMAV_DISABLE_CONCURRENT_RELOAD` \\
  When set to `yes`, disables non-blocking virus database reloads.\\
  See [Database reload](#db-reload) for more details.\\
  Defaults to `no`.




[ClamAV]: https://www.clamav.net/
[clamav-scalingo]: https://github.com/Scalingo/clamav-scalingo
[buildpack-inventory]: https://github.com/Scalingo/clamav-buildpack/FIXME

[private-networking]: {% post_url platform/networking/private/2000-01-01-overview %}
[procfile]: {% post_url platform/app/2000-01-01-procfile %}
[project]: {% post_url platform/projects/2000-01-01-overview %}
[application-firewall]: {% post_url platform/networking/public/2000-01-01-application-firewall %}
