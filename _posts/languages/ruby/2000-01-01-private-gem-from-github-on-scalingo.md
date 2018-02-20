---
title: Installing a Gem on Scalingo from a Private GitHub Repo
modified_at: 2015-10-17 17:39:00
categories: languages ruby
tags: ruby gem private github
---

Sometimes you want to use a gem on Scalingo that is in a private repository on
GitHub.

Using Git over HTTP you can authenticate to GitHub using basic authentication.
However, we don't want to embed usernames and passwords in `Gemfile`s. Instead,
we can use authentication tokens.

## Get an OAuth Token from  GitHub

First you will need to get an OAuth token from GitHub using your own username and "note"

```bash
curl -u 'Soulou' -d '{"scopes":["repo"],"note":"Ventana Example App"}' https://api.github.com/authorizations
```

## Authenticate bundler to GitHub via OAuth Token

Add this line to your `Gemfile` replacing `your_token` with the token you got
from step 1. In this example we install the `ventana` gem:

```ruby
gem 'ventana', git: "https://your_token:x-oauth-basic@github.com/thoughtbot/ventana.git"
```

## Storing the OAuth token in an environment variable (more secure)

For additional security you can store your OAuth token in an environment
variable. This way your token is not included in your code base which is
insecure.

Change the line in your `Gemfile` to

```ruby
gem 'ventana', git: "https://#{ENV['GITHUB_TOKEN']}:x-oauth-basic@github.com/thoughtbot/ventana.git"
```

Then set the your access token locally using the token you got from above:

```bash
export GITHUB_TOKEN=your_token
```

Now bundle and if everything works locally you are ready to deploy to Scalingo!

Finally add the GITHUB_TOKEN to your Scalingo environment

```bash
scalingo env-set GITHUB_TOKEN=your_token
```

And deploy

```bash
git push scalingo master
```

You now have a private gem installed on Scalingo!
