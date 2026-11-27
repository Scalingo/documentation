---
title: Creating a File-Scanning API with ClamAV
logo: clamav
category: security
products:
  - Project
  - Private Network
kind: tutorial
permalink: /tutorials/clamav
modified_at: 2026-11-27
last_reviewed_at: 2026-11-27
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
the example a little more engaging and spark some inspiration, we've also built
[a small application][clamav-labs] that interacts with ClamAV and demonstrates
how it can be integrated into a real-world use case.

Deploying this small app is not part of this tutorial, but you will find some
instructions in the corresponding `README` file, available alongside the code.

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

  The **API** would expose an HTTP endpoint that allows clients to upload files
  for scanning. Upon receiving a file, the API would forward it to the ClamAV
  service for analysis, then return the scanning results to the client in JSON
  format.

- Each component is deployed as part of a [Project][project], in the same
  [Private Network][private-networking]:

  - Running inside a Private Network allows `clamd` to bind any port, which
    simplifies the deployment.

  - By listening only on the private interface, we make sure ClamAV is not
    exposed to the Internet.

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

{:#clamav-versions}
- ClamAV supports two release branches:
  - A Long-Term Support (LTS), which gets critical patch versions for an
    extended period of three (3) years starting from the initial publication
    date.
  - A regular (non-LTS), which receives critical patch versions for **at
    least** four (4) months after the next-next feature release is published.

  By default, the buildpack deploys the latest LTS available.


## Deploying the ClamAV Service

### Using the Command Line

1. Fork our [ClamAV repository][clamav-scalingo]

2. (optional) Create a new [Project][project] if needed. Skip this if you
   rather want to integrate ClamAV within an existing one.

3. Retrieve the project ID:
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

   Identify the project and keep its ID aside.

4. From the repository, create a new application **in the project**:
   ```bash
   scalingo create my-clamav --project-id <project_id>
   ```
   With `project_id` being the ID of the newly created project.

5. Let the platform know what buildpack it must use:
   ```bash
   scalingo --app my-clamav env-set BUILDPACK_URL=https://github.com/Scalingo/clamav-buildpack
   ```

6. Ensure ClamAV listens on the private network interface:
   ```bash
   scalingo --app my-clamav env-set CLAMAV_TCP_ADDR=\$SCALINGO_PRIVATE_HOSTNAME
   ```

7. (optional) Chose a port for ClamAV to listen to:
   ```bash
   scalingo --app my-clamav env-set CLAMAV_TCP_PORT=3310
   ```

8. Instruct the platform to not start a `web` process type:
   ```bash
   scalingo --app my-clamav scale web:0:M
   ```

9. (recommended) Instruct the platform to run the `clamav` process type in one
   2XL container:
   ```bash
   scalingo --app my-clamav scale clamav:1:2XL
   ```

10. Trigger a deployment by pushing your git repository to Scalingo.

### Using the Terraform Provider

1. Fork our [ClamAV repository][clamav-scalingo]

2. Ensure you have a `scalingo_project` resource block in your Terraform file:
   ```tf
   resource "scalingo_project" "clamav-prj" {
     name    = "clamav"
     default = false
   }
   ```

3. Place the following `scalingo_app` resource block in your Terraform file:
   ```tf
   resource "scalingo_app" "clamav-app" {
     name           = "my-clamav"
     project_id     = scalingo_project.clamav-prj.id
     stack_id       = "scalingo-26"

     environment = {
       BUILDPACK_URL    = "https://github.com/Scalingo/clamav-buildpack",
       CLAMAV_VERSION   = "<version>",
       CLAMAV_TCP_ADDR  = "$SCALINGO_PRIVATE_HOSTNAME,
       CLAMAV_TCP_PORT  = 3301
     }
   }
   ```

4. Link the app to its repository:
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

5. Instruct the platform to not start a `web` process type:
   ```tf
   resource "scalingo_container_type" "web-container" {
     app    = scalingo_app.clamav-app.id
     name   = "web"
     size   = "M"
     amount = 0
   }
   ```

6. (optional) Instruct the platform to run the `clamav` process type in one 2XL
   container:
   ```tf
   resource "scalingo_container_type" "clamav-container" {
     app    = scalingo_app.clamav-app.id
     name   = "clamav"
     size   = "2XL"
     amount = 1
   }
   ```

7. Run `terraform plan` and check if the result looks good

8. If so, run `terraform apply`

9. Once Terraform is done, your ClamAV instance is ready to be deployed:
   1. Head to your [dashboard]
   2. Click on your ClamAV application
   3. Click on the Deploy tab
   4. Click on Manual deployment in the left menu
   5. Click the Trigger deployment button
   6. After a few seconds, your ClamAV instance is finally up and running!


## Updating

Keeping ClamAV up to date is essential to maintaining effective protection
against malware and emerging security threats. Regular updates of the antivirus
engine itself ensure that ClamAV can detect newly identified threats, and
improves detection capabilities. We therefore advise to always run the latest
available patch version of a supported ClamAV release, whether Long-Term
Support (LTS) or regular (non-LTS).

### Using the Command Line

1. Update the version to the desired one:
   ```bash
   scalingo --app my-clamav env-set CLAMAV_VERSION=<new_version>
   ```

2. In your ClamAV repository, create a new empty commit:
   ```bash
   git commit --message "Deploy ClamAV version <new_version>" --allow-empty
   ```

3. Trigger a new deployment

### Using the Terraform Provider

1. Update the `scalingo_app` resource block of the ClamAV app to include the
   `CLAMAV_VERSION` environment variables:
   ```tf
   resource "scalingo_app" "my-clamav" {
     # [...]
     environment = {
       # [...]
       CLAMAV_VERSION = "<new_version>"
     }
   }
   ```

2. Trigger a new deployment


## Customizing

### Configuration

The `clamav-buildpack` features default settings that we deem suitable for most
cases. They can be customized by setting the corresponding environment
variables (see [Environment](#environment) hereafter).

If a required directive is not available in the provided configuration files,
you can request its addition by [opening an issue in the buildpack
repository][repo-issues] or by contacting our Support Team.

### Environment

The ClamAV buildpack makes use of the following environment variables. They can
be leveraged to customize your deployment:

- `CLAMAV_VERSION` \\
  Version of ClamAV to deploy. \\
  Defaults to not being set, which falls back on the default version set in the
  buildpack inventory file for your stack.

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
  When set (to any value), makes `clamd` listen on a local Unix socket
  (`/app/clamav/run/clamd.socket`).\\
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


*[LTS]: Long-Term Support

[ClamAV]: https://www.clamav.net/
[repo-issues]: https://github.com/Scalingo/clamav-buildpack/issues/new
[clamav-scalingo]: https://github.com/Scalingo/clamav-scalingo
[clamav-labs]: https://github.com/Scalingo/scalingo-labs/tree/main/clamav

[dashboard]: https://dashboard.scalingo.com

[private-networking]: {% post_url platform/networking/private/2000-01-01-overview %}
[procfile]: {% post_url platform/app/2000-01-01-procfile %}
[project]: {% post_url platform/projects/2000-01-01-overview %}
