---
title: Getting Started With ModSecurity on Scalingo
modified_at: 2022-07-25 00:00:00
tags: tutorial security firewall modsecurity apache nginx waf
index: 11
---

ModSecurity is an open-source Web Application Firewall (WAF) that allows users
to monitor, log and filter HTTP requests. A very common use case is to rely on
a set of open-source rules provided by [OWASP](https://owasp.org/) (called
[OWASP ModSecurity Core Rule Set (CRS)](https://owasp.org/www-project-modsecurity-core-rule-set/))
to protect a web application against generic classes of vulnerabilities and
Layer 7 attacks such as SQL injections, Cross Site Scripting, ...

When enabled, ModSecurity analyzes every incoming HTTP request and compares
the content of the request with a set of patterns. If there is a match, then it
runs some actions, such as blocking the request, logging a message or returning
a specific HTTP error.

ModSecurity implements its own Domain Specific Language, called *SecLang*,
making it easy for users to write and share their own rules (combination of
pattern and actions).

For this first tutorial, we use Nginx and the CRS provided by OWASP to deploy a
WAF on Scalingo within minutes.

## Deploying Nginx

The very first steps consist of deploying an Nginx application on Scalingo. To
do this, please [follow the dedicated tutorial]({% post_url platform/deployment/buildpacks/2000-01-01-nginx %}).

## Enabling ModSecurity

Once your Nginx application is successfully deployed, set the environment
variable `ENABLE_MODSECURITY` to `true`, either by adding it via
[your dashboard](https://dashboard.scalingo.com/) or by using the command line:

```bash
$ scalingo --app my-app env-set ENABLE_MODSECURITY=true
```

Trigger a new deployment of your application by creating an empty commit and
pushing it to your Scalingo remote:

```bash
$ git commit --allow-empty -m "Enable ModSecurity"
$ git push scalingo master
```

The empty commit is detected by Scalingo and picked up to re-deploy the
application. Several additional actions are done during this new deployment:

- ModSecurity and its dependencies are installed.
- Default configuration for ModSecurity is enabled. It downloads and enables
  the Core Rule Set (CRS) provided by OWASP.

Wait a few seconds for the deployment to finish and test that the CRS is
actually active by issuing the following command:

```bash
$ curl -v -X INVALID_HTTP_METHOD https://my-app.osc-fr1.scalingo.io
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

## Adding a Custom Rule

Now that we have a working WAF with a nice default set of rules, you may want
to add your own custom rules. Let's see how to do this!

First, create a file at the root of your Nginx application. In this example, we
call it `my_rules.conf`, but you can chose whatever suits you.

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
- The `id:1234` is an arbitrary number, you can use any number < 100000 (see:
[https://coreruleset.org/docs/rules/ruleid/](https://coreruleset.org/docs/rules/ruleid/) for further details about `ruleid`).
- A list of all variables usable with `logdata` is available here:
[https://github.com/SpiderLabs/ModSecurity/wiki/Reference-Manual-(v3.x)#variables](https://github.com/SpiderLabs/ModSecurity/wiki/Reference-Manual-(v3.x)#variables)
{% endnote %}

Once done, tell Nginx to load the brand new rules. Edit the file you are using
for your Nginx configuration (i.g. `nginx.conf`, `nginx.conf.erb`, ...) and add
two directives:

- `modsecurity`, which must be set to `on`, and that enables ModSecurity.
- `modsecurity_rules_file`, which must point to the file containing your rules.
  Since Scalingo deploys your app in `/app/`, this path **must** start with
  `/app/`.

Your file should end up like this:

```
# This file is written in Nginx configuration language

location / {
    modsecurity on;   # Enable ModSecurity on /
    modsecurity_rules_file /app/my_rules.conf;   # load custom rules file
    # (...)
    # The rest of your Nginx config file
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

## Disabling a Rule

If you want to disable a rule for some reason, you first need to identify the
rule, thanks to its `id` number.

You can then add a `SecRuleRemoveId` directive at the end of
[your custom rules file](#adding-a-custom-rule), like this:

```
# This file is written in the ModSecurity config language

# Rule 911100 filters unknown HTTP methods, but we actually do want to allow exotic HTTP methods
SecRuleRemoveId 911100
```

## Updating the Core Rule Set

Unless told otherwise (see below), Scalingo automatically downloads and uses
the latest stable version of the CRS when deploying your WAF. Consequently,
updating the CRS is just a `git commit` and `git push` effort:

```bash
$ git commit --allow-empty -m "Update Core Rule Set"
$ git push scalingo master
```

As always, pushing to your Scalingo remote triggers a new deployment of your
application, and the new rules are downloaded.

{% note %}
If you want to use a specific version of the CRS, you can manually set the
`MODSECURITY_CORE_RULE_SET_VERSION` environment variable to this specific
version and trigger a new deployment.
{% endnote %}

## Updating ModSecurity

Scalingo automatically deploys the latest version of ModSecurity **we have
packaged and tested**. Consequently, updating ModSecurity only consists of
triggering a new deployment of your WAF. To do so, you can create an empty
commit and push it to Scalingo:

```bash
$ git commit --allow-empty -m "Update ModSecurity"
$ git push scalingo master
```

{% note %}
Scalingo **does not** provide any guarantee in term of packaging and
availability after each ModSecurity release. You can still get in touch with our
support team, should you need a specific version.
{% endnote %}

## Customizing ModSecurity

Scalingo provides a few environment variables for you to tweak ModSecurity:

- `MODSECURITY_DEBUG_LOG_LEVEL` allows to specify the log level. It expects a
  value from `0` (no logging) to `9` (super verbose).
  Defaults to `0`.
- `MODSECURITY_AUDIT_LOG_LEVEL` allows to configure the audit logging engine. It
  can be set to either `On` (log all transactions), `RelevantOnly` (only log
  transactions that returned with a status code of 4xx or 5xx) or `Off` (do not
  log transactions).
  Defaults to `Off`.

