---
title: Deploy with GitLab
modified_at: 2019-08-30 00:00:00
tags: scm gitlab deployment
index: 4
---

You can deploy your Scalingo application with a code hosted on GitLab: either
the SaaS version at [https://gitlab.com/](https://gitlab.com/) or a self-hosted
version. You will have to link it to a GitLab repository and branch.

## Link Your App to the SCM Tool

{% warning %}
The web dashboard is currently only compatible with GitHub. To integrate your
application with GitLab, please install our [CLI](https://cli.scalingo.com)
tool.
{% endwarning %}

You first need to link your Scalingo account with your GitLab account. This is
achieved with the following command:

* For GitLab:

```
$ scalingo integrations-add gitlab
```

* For GitLab self-hosted:

```
$ scalingo integrations-add gitlab-self-hosted --url https://gitlab.example.org --token <token>
```

The token you need is a personal access token. Here is the [GitLab
documentation](https://docs.gitlab.com/ee/user/profile/personal_access_tokens.html)
on how to create one. TODO WHAT ARE THE SCOPES?! The scopes you need on Scalingo are `api`, `read_user`.

Then, add and configure a link between your Scalingo application and the
GitLab-hosted repository with:

```
$ scalingo --app my-app integration-link-create https://gitlab.example.org/my-company/my-app --auto-deploy --branch master
```

A comprehensive list of available configuration flags is available with:

```
$ scalingo help integration-link-create
```

## Deployments

When your application is linked to the GitLab repository some deployments
options are available:

With "Auto deploy" enabled, your application will be deployed every time you
push to a selected branch of your repository. You can enable the "Auto deploy"
on your application when creating the link or later, with the following command:

```
$ scalingo --app my-app integration-link-update --auto-deploy --branch master
```

You can also trigger a manual deployment to choose a specific branch to
deploy:

```
$ scalingo --app my-app integration-link-manual-deploy master
```

You can get all information about your GitLab integration configuration with:

```
$ scalingo --app my-app integration-link
```

## Review Apps

Review apps are special type of applications linked to a merge request. They can
be created automatically every time a merge request is opened or they can be
created manually by selecting the merge request to deploy among the currently
opened ones.

By default, review apps are automatically destroyed when the merge request is
closed. But you can specify a duration after which the review app is destroyed:

```
$ scalingo --app my-app integration-link-update --deploy-review-apps --destroy-on-close --hours-before-destroy-on-close 3
```

Manually create a review app with:

```
$ scalingo --app my-app integration-link-manual-review-app 4
```

`4` being the ID of the merge request.

For more information, you can read the more specific documentation pages [SCM
integration, Auto Deploy and Review Apps]({% post_url
platform/app/2000-01-01-scm-integration %}) and [Review Apps]({% post_url
platform/app/2000-01-01-review-apps %}).

You can get all information about your GitLab integration configuration with:

```
$ scalingo --app my-app integration-link
```

## Some suggestions

You can also create a [child app]({% post_url platform/app/2000-01-01-child-apps
%}) which is not a review app.
