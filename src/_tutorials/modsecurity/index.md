---
title: Deploying a WAF with OWASP ModSecurity CRS
logo: owasp-modsecurity-crs
category: security
permalink: /tutorials/modsecurity
modified_at: 2025-08-12
---

ModSecurity is an open-source Web Application Firewall (WAF) that allows users
to monitor, log and filter HTTP requests. A very common use case is to rely on
a set of open-source rules called
[OWASP ModSecurity Core Rule Set (CRS)][CRS] to protect a web application
against generic classes of vulnerabilities and threats such as SQL injections,
Cross Site Scripting, etc.

When enabled, ModSecurity analyzes every incoming HTTP request and compares
the content of the request with a set of patterns. If there is a match, then it
runs some actions, such as blocking the request, logging a message or returning
a specific HTTP error.

ModSecurity implements its own Domain Specific Language, called *SecLang*,
making it easy for users to write and share their own rules (combination of
pattern and actions).


## Planning your Deployment

- Due to technical requirements, ModSecurity is only deployable on
  `scalingo-20` (EOL) and above.

- ModSecurity requires a set of rules to filter or block requests. In this
  tutorial, we will use the [OWASP ModSecurity Core Rule Set][CRS].

- In this tutorial, we have chosen to deploy ModSecurity connected to nginx.
  Note that ModSecurity can also be connected to other webservers such as IIS
  or Apache, but these cases are out of the scope of this guide.


## Deploying

### Using the Command Line

#### Deploying nginx

The very first steps consist of deploying an nginx application on Scalingo. To
do this, please [follow the dedicated tutorial][deploy-nginx].

#### Enabling ModSecurity

1. Once your nginx application is successfully deployed, set the environment
   variable `ENABLE_MODSECURITY` to `true`, either by adding it via
   your [dashboard] or by using the command line:
   ```bash
   scalingo --app my-app env-set ENABLE_MODSECURITY=true
   ```

2. Trigger a new deployment of your application by creating an empty commit and
   pushing it to your Scalingo remote:
   ```bash
   git commit --allow-empty -m "Enable ModSecurity"
   git push scalingo master
   ```

   The empty commit is detected by Scalingo and picked up to re-deploy the
   application. Several additional actions are done during this new deployment:

   - ModSecurity and its dependencies are installed.
   - Default configuration for ModSecurity is enabled. It downloads and enables
     the Core Rule Set (CRS) provided by OWASP.

3. Wait a few seconds for the deployment to finish and test that the CRS is
   actually active by issuing the following command:
   ```bash
   curl -v -X INVALID_HTTP_METHOD https://my-app.osc-fr1.scalingo.io
   ```

   The application should respond with a **403 forbidden** such as the following:
   ```bash
   > INVALID_HTTP_METHOD / HTTP/2
   > Host: my-app.osc-fr1.scalingo.io
   > User-Agent: curl/7.64.1
   > Accept: */*
   >
   * Connection state changed (MAX_CONCURRENT_STREAMS == 128)!
   < HTTP/2 403
   < date: Tue, 31 May 2022 13:58:46 GMT
   < content-type: text/html; charset=utf-8
   < content-length: 146
   < x-request-id: 343e6a24-640e-499a-9dfe-f5dbb636ef45
   < strict-transport-security: max-age=31536000
   <
   <html>
   <head><title>403 Forbidden</title></head>
   <body>
   <center><h1>403 Forbidden</h1></center>
   <hr><center>nginx</center>
   </body>
   </html>
   ```


## Updating

### Updating ModSecurity

By default, Scalingo tries to install the latest version of ModSecurity.

Consequently, updating ModSecurity only consists of triggering a new deployment
of your instance. To do so, create an empty commit and push it to Scalingo:

```bash
git commit --allow-empty -m "Update ModSecurity"
git push scalingo master
```

{% note %}
- Scalingo **does not** provide any guarantee in terms of packaging and
  availability after each ModSecurity release. We do our best to keep it
  up-to-date, but can't guarantee it.
- You can use the dedicated environment variable ([see below](#environment)) to
  deploy a specific version.
- Please feel free to get in touch with our support team, should you need a
  specific version.
{% endnote %}

### Updating the Core Rule Set

By default, Scalingo tries to install the latest version of the OWASP CRS.

Consequently, updating the CRS only consists of triggering a new deployment of
your instance. To do so, create an empty commit and push it to Scalingo:

```bash
git commit --allow-empty -m "Update Core Rule Set"
git push scalingo master
```

{% note %}
- Scalingo **does not** provide any guarantee in terms of packaging and
  availability after each Core Rule Set release. We do our best to keep it
  up-to-date, but can't guarantee it.
- You can use the dedicated environment variable ([see below](#environment)) to
  deploy a specific version.
- Please feel free to get in touch with our support team, should you need a
  specific version.
{% endnote %}


## Customizing

### Adding a Custom Rule

Now that we have a working WAF with a nice default set of rules, you may want
to add your own custom rules.

First, create a file at the root of your nginx application. In this example, we
call it `my_rules.conf`, but you can choose anything that suits you.

Write your rules in this file, using SecLang and the `SecRule` directive:
```
# This file is written in ModSecurity configuration language

# CUSTOM RULE id:1234
# IF query or body parameter contains a parameter named “param1” which contains “test”
# THEN block the request with a code 403 and log the event
SecRule ARGS:param1 "@contains test" \
    "id:1234,\
    deny,\
    log,\
    status:403,\
    severity: 'CRITICAL',\
    tag: 'custom-rule',\
    msg: 'this is the log message you will see',\
    logdata: '%{MATCHED_VAR_NAME}=%{MATCHED_VAR}'"
```

{% note %}
- The `id:1234` is an arbitrary number. Any number < 100000 would work (see
  [documentation][crs-ruleid] for further details).
- `logdata` supports a lot of variables (see [documentation][modsecurity-vars]
  for the exhaustive list).
{% endnote %}

Once done, tell nginx to load the brand-new rules. Edit the file you are using
for your nginx configuration (i.g. `nginx.conf`, `nginx.conf.erb`, ...) and add
two directives:

- `modsecurity`, which must be set to `on`, and that enables ModSecurity.
- `modsecurity_rules_file`, which must point to the file containing your rules.
  Since Scalingo deploys your app in `/app/`, this path **must** start with
  `/app/`.

Your file should end up like this:
```
# This file is written in nginx configuration language

location / {
    modsecurity on;   # Enable ModSecurity on /
    modsecurity_rules_file /app/my_rules.conf;   # load custom rules file
    # (...)
    # The rest of your nginx config file
}
```

You can now commit your changes and push them to your Scalingo remote, which
triggers a new deployment of your WAF:
```bash
$ git add my_rules.conf
$ git add nginx.conf
$ git commit -m "Add modsecurity custom rules"
$ git push scalingo master
```

### Disabling a Rule

If you want to disable a rule for some reason, you first need to identify the
rule, thanks to its `id` number.

You can then add a `SecRuleRemoveById` directive at the end of
[your custom rules file](#adding-a-custom-rule), like this:
```
# This file is written in the ModSecurity config language

# Rule 911100 filters unknown HTTP methods, but we actually do want to allow exotic HTTP methods
SecRuleRemoveById 911100
```

### Environment

The buildpack makes use of the following environment variable(s).
They can be leveraged to customize your deployment:

- **`MODSECURITY_VERSION`**\\
  Allows to specify the version of ModSecurity to deploy.\\
  Defaults to the version set in the buildpack.

- **`MODSECURITY_CORE_RULE_SET_VERSION`**\\
  Allows to specify the version of the OWASP Core Rule Set to deploy.\\
  Defaults to the version set in the buildpack.

- **`MODSECURITY_DEBUG_LOG_LEVEL`**\\
  Allows to specify the log level.\\
  Expects a value from `0` (no logging) to `9` (super verbose).\\
  Defaults to `0`.

- **`MODSECURITY_AUDIT_LOG_LEVEL`**\\
  Allows to configure the audit logging engine.\\
  Can be set to either `On` (log all transactions), `RelevantOnly` (only log
  transactions that returned with a status code of 4xx or 5xx) or `Off` (do not
  log transactions).\\
  Defaults to `Off`.


*[OWASP]: Open Worldwide Application Security Project
*[WAF]: Web Application Firewall
*[CRS]: Core Rule Set

[OWASP]: https://owasp.org
[CRS]: https://owasp.org/www-project-modsecurity-core-rule-set/
[crs-ruleid]: https://coreruleset.org/docs/rules/ruleid/
[modsecurity-vars]: https://github.com/SpiderLabs/ModSecurity/wiki/Reference-Manual-(v3.x)#variables

[dashboard]: https://dashboard.scalingo.com/apps/

[deploy-nginx]: {% post_url platform/deployment/buildpacks/2000-01-01-nginx %}
