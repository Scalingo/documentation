---
title: Deploy to Scalingo from Codeship
nav: Deploy from Codeship
modified_at: 2020-04-29 00:00:00
tags: ci deployment build codeship
index: 20
---

To setup **Continuous Deployment** from Codeship to Scalingo, please follow the
following steps. You can read more about [Deployment
Pipelines](https://documentation.codeship.com/basic/builds-and-configuration/deployment-pipelines)
on the Codeship documentation.

### Setup a Deployment Pipeline

On Codeship:

1. Go to the **Deployment** page of your project.
2. Add a new deployment pipeline by choosing the branch you want to deploy from.
3. Choose **Custom Script** deployment type.
4. Fill the deployment commands:

```bash
git fetch --unshallow || true
git push --force git@ssh.osc-fr1.scalingo.com:my-app.git ${CI_COMMIT_ID}:master
```

Note that the remote URL depends on the region of your application. You can get
it using our CLI with:

```bash
scalingo --app my-app git-show
```

Or you can use the
[deployments/git_push.sh](https://github.com/codeship/scripts/blob/master/deployments/git_push.sh)
script provided by Codeship.

### SSH Keys

To deploy to Scalingo from Codeship, you'll have to add the public key generated
by Codeship to the [SSH Keys page](https://dashboard.scalingo.com/account/keys) on Scalingo
dashboard. You can find this public key in the **General** page of your Codeship
project.
