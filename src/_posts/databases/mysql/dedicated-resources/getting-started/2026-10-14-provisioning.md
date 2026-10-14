---
title: Provisioning a Scalingo for MySQL® Dedicated Resources Database
nav: Provisioning
modified_at: 2026-10-14 00:00:00
tags: databases mysql dedicated
index: 1
---


{% include database_architecture_models.md engine="MySQL®" %}

You can provision a MySQL® Dedicated Resources database using the
[dashboard](#using-the-dashboard), [CLI](#using-the-command-line),
[Terraform Provider](#using-the-terraform-provider) or
[Kubernetes Operator](#using-the-kubernetes-operator).


## Provisioning

{% include dedicated_resources_availability.md %}

### Using the Dashboard

1. From your web browser, open your [dashboard][dashboard]
2. Select the **Project** where you want to create the database
3. Click the arrow next to **Create an application**, then click
   **Database Dedicated Resources**
4. In the **Databases engines** section, select
   **MySQL Dedicated Resources** and confirm your choice
5. Enter a database name, then select or confirm the appropriate **Project** and
   **Region**
6. Select the plan you want to provision and confirm your selection
7. Click the **Create database** button
8. Database provisioning typically takes 15–30 minutes

### Using the Command Line (Preview) {#using-the-command-line}

Because Dedicated Resources databases are not yet generally available,
you must first enable preview features to use the related CLI commands:

```sh
export SCALINGO_PREVIEW_FEATURES=true
```


1. Make sure you have correctly [setup the Scalingo command line tool][cli]
2. From the command line, list the plans available for `mysql-dr`:
   ```bash
   scalingo database-list-plans mysql-dr
   ```
   The output should look like this:
   ```text
   +-----------------------+------------+
   | ID                    | NAME       |
   +-----------------------+------------+
   | mysql-dr-starter-8192 | Starter 8G |
   ...
   ```
3. Locate the `ID` corresponding to the plan you want to deploy (for example
   `mysql-dr-starter-8192`)
4. Provision the database:
   ```bash
   scalingo database-create --type mysql-dr --plan <plan_ID> <database_name>
   ```
   The output should look like this:
   ```text
   -----> Your mysql-dr database 698e082f968c27dfb8a27521 ('my-dedicated-database') is being provisioned…
   ```
5. Database provisioning typically takes 15–30 minutes

Optionally you can use `--wait` in order to make the command synchronous.
```bash
scalingo database-create --type mysql-dr --plan <plan_ID> --wait <database_name>
```

### Using the Terraform Provider

1. Place the following `resource` block in your Terraform file to create the
   database:
   ```tf
   resource "scalingo_database" "my-dedicated-database" {
     name       = "my-dedicated-database"
     technology = "mysql-dr"
     plan       = "mysql-dr-starter-8192"
   }
   ```
   In this example, we create a dedicated MySQL Starter 8192 database named `my-dedicated-database`. We could have done the same with another plan.
2. Run `terraform plan` and check if the result looks good
3. If so, run `terraform apply`
4. Database provisioning typically takes 15–30 minutes

### Using the Kubernetes Operator

1. Deploy the [Scalingo Kubernetes Operator][kube-operator] in your cluster
   using the installation manifest `install.yaml` from the
   [latest release][kube-operator-install].

2. Create a Scalingo API token and store it in a Kubernetes Secret, as
   documented in [Create Secret][kube-operator-secret].

3. Create a custom resource to provision your dedicated MySQL database:

   ```yaml
   apiVersion: databases.scalingo.com/v1
   kind: MySQL
   metadata:
     labels:
       app.kubernetes.io/name: scalingo-operator
       app.kubernetes.io/managed-by: kustomize
     name: my-dedicated-database
   spec:
     # Secret read by operator
     authSecret:
       name: scalingo
       key: api_token

     # Secret written by operator
     connInfoSecretTarget:
       name: my-dedicated-database-secret
       prefix: MYSQL

     # Network configuration
     networking:
       internet_access:
         enabled: true
       outscale:
         oks:
           net_peering: false
       firewall:
         rules:
           - type: "custom_range"
             cidr: "198.51.100.25/32"
             label: "My workstation"

     name: my-dedicated-database
     plan: mysql-dr-starter-8192
     region: osc-fr1
   ```

   This example provisions a dedicated MySQL database named
   `my-dedicated-database` on the `mysql-dr-starter-8192` plan and writes
   its connection information to the `my-dedicated-database-secret` Kubernetes
   Secret. You can use another `mysql-dr-*` plan instead.

4. Apply the resource and wait for provisioning to complete:

   ```bash
   kubectl apply -f my-dedicated-database.yaml
   ```

5. Database provisioning typically takes 15–30 minutes

To read the database URL from the generated secret:
```bash
kubectl describe secret my-dedicated-database-secret
kubectl get secret my-dedicated-database-secret -o jsonpath='{.data}' | grep MYSQL
```

For a complete manifest (including all available fields), use the official
[MySQL sample resource][kube-operator-mysql-sample].


## Accessing the Scalingo for MySQL® Dashboard

Every MySQL® database comes with its dedicated dashboard, generally referred
to as **database dashboard**, which is the central place for administrative
tasks such as:

- [Monitoring the database][mysql-dr-monitoring] through logs, metrics and statistics
- [Upgrading the database][mysql-dr-upgrading] engine version
- [Managing database users][mysql-dr-managing-users]
- [Managing Collaborators][mysql-dr-managing-collaborators]
- [Using multiple databases][mysql-dr-multiple-db]
- [Managing backups][mysql-dr-backing-up]

You can access the database dashboard from the main dashboard:

1. From your web browser, open your [dashboard][dashboard]
2. Open the **Project** containing the database you want to manage
3. In the **Databases** section, click the database name


[dashboard]: https://dashboard.scalingo.com/projects

[cli]: {% post_url tools/cli/2000-01-01-start %}
[kube-operator]: {% post_url tools/2000-01-01-kubernetes-operator %}
[kube-operator-install]: https://github.com/Scalingo/scalingo-operator/releases
[kube-operator-secret]: https://github.com/Scalingo/scalingo-operator/blob/main/README.md#create-secret
[kube-operator-mysql-sample]: https://github.com/Scalingo/scalingo-operator/blob/main/config/samples/databases_v1_mysql.yaml

[mysql-dr-monitoring]: {% post_url databases/mysql/dedicated-resources/guides/2026-10-14-monitoring %}
[mysql-dr-upgrading]: {% post_url databases/mysql/dedicated-resources/guides/2026-10-14-upgrading %}
[mysql-dr-managing-users]: {% post_url databases/mysql/dedicated-resources/guides/2026-10-14-managing-users %}
[mysql-dr-managing-collaborators]: {% post_url databases/mysql/dedicated-resources/guides/2026-10-14-managing-collaborators %}
[mysql-dr-backing-up]: {% post_url databases/mysql/dedicated-resources/guides/2026-10-14-backing-up %}

[mysql-dr-multiple-db]: {% post_url databases/mysql/dedicated-resources/guides/2026-10-14-using-multiple-databases %}
