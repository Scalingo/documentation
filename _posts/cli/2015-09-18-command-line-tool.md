---
title: CLI Command Line Tool
modified_at: 2015-11-05 17:21:00
category: app
tags: cli interface app
---

## Installation

We provide a command line tool (CLI) able to interact with the platform. You
can find the download link and changelog here
[http://cli.scalingo.com](http://cli.scalingo.com).

### Linux & macOS

You need to download the binary and put it in your `PATH`. The easiest way is
to follow the instructions on
[http://cli.scalingo.com](http://cli.scalingo.com). It consists of this single
line:

```bash
curl -O https://cli-dl.scalingo.io/install && bash install
```

### Windows

We highly recommend to use [git-bash](https://git-for-windows.github.io/) to have an all-in-one deployment environment.

Then, you need to download Scalingo command-line tool:

* [Windows 64 bits users](http://cli-dl.scalingo.io/release/scalingo_latest_windows_amd64.zip)
* [Windows 32 bits users](http://cli-dl.scalingo.io/release/scalingo_latest_windows_386.zip)

Place the `scalingo.exe` file in the path you want, e.g. "C:/Program Files".

From git-bash add this path to your `PATH` environment variable:

```bash
$ export PATH=$PATH:/c/Program\ Files/
```

Now you should be able to run `scalingo.exe` from git-bash.

Note that you set `PATH` for this specific git-bash instance and that you should add the command line above to a `.bashrc` file at the root of your `HOME`:

```bash
$ echo "export PATH=$PATH:/c/Program\ Files/" >> $HOME/.bashrc
```

Now `scalingo.exe` will be available from git-bash for your next sessions.

## Tips

* You can use the environment variable `SCALINGO_APP` instead of using the `--app` flag
* If your current directory is the base directory of your project
  and that your git repository has a remote named `scalingo`, you
  don't need to specify `--app <name>`. It will be detected automatically.
* If you want to specify a different remote name, you can do it by using
  `--remote` or `-r` flag followed by the name

## Command Completion

### Bash

* Make sure bash completion is installed. If you use a current Linux in a
  non-minimal installation, bash completion should be available. On macOS,
  install with `brew install bash-completion`

* Get bash completion script in the directory:
  * Linux users `/etc/bash_completion.d/`:

  ```bash
    sudo curl "https://raw.githubusercontent.com/Scalingo/cli/master/cmd/autocomplete/scripts/scalingo_complete.bash" -o /etc/bash_completion.d/scalingo_complete.sh
  ```

  * macOS users `/usr/local/etc/bash_completion.d/`:

  ```bash
    sudo curl "https://raw.githubusercontent.com/Scalingo/cli/master/cmd/autocomplete/scripts/scalingo_complete.bash" -o /usr/local/etc/bash_completion.d/scalingo_complete.sh
  ```

* Reload your shell in order to make the completion available:

  ```bash
  exec bash -l
  ```

### Zsh

* Create a directory `~/.zsh/completion/` :

  ```bash
  mkdir -p ~/.zsh/completion
  ```

* Get Zsh completion script in the directory `~/.zsh/completion/` :

  ```bash
  curl "https://raw.githubusercontent.com/Scalingo/cli/master/cmd/autocomplete/scripts/scalingo_complete.zsh" > ~/.zsh/completion/scalingo_complete.zsh
  ```

* Make sure the completion script will be loaded, by adding to the following line to your `~/.zshrc` :

  ```bash
  source ~/.zsh/completion/scalingo_complete.zsh
  ```

* Reload your shell:

  ```bash
  exec zsh -l
  ```

## Features

### Create new apps

`scalingo create`

```bash
scalingo create my-app

# Create a new app with a custom Git remote
scalingo create my-app --remote staging
scalingo create my-app --remote production
scalingo create my-app --remote custom
```

### Setup your account SSH keys
`scalingo keys|keys-add|keys-remove`

```bash
scalingo keys
scalingo keys-add "Laptop SSH key" $HOME/.ssh/id_rsa.pub
scalingo keys-remove "Laptop SSH key"
```

### Configure their environment
`scalingo env|env-set|env-unset`

```bash
scalingo -a my-app env
scalingo -a my-app env-set NODE_ENV=production
scalingo -a my-app env-unset NODE_ENV
```

### Configure custom domain names
`scalingo domains|domains-add|domains-ssl|domains-remove`

```bash
scalingo -a my-app domains
scalingo -a my-app domains-add example.com
scalingo -a my-app domains-ssl example.com --cert file.crt --key file.key
scalingo -a my-app domains-remove example.com
```

### Manage collaborators of the application
`scalingo collaborators|collaborators-add|collaborators-remove`

```bash
scalingo -a my-app collaborators
scalingo -a my-app collaborators-add user@example.com
scalingo -a my-app collaborators-remove user@example.com
```

### List existing addons and plans
`scalingo addons-list|addons-plans`

```bash
scalingo addons-list
scalingo addons-plans scalingo-mongodb
```

### Manage addons of your applications
`scalingo addons|addons-add|addons-remove|addons-upgrade`

```bash
scalingo -a my-app addons
scalingo -a my-app addons-add scalingo-mongodb 1g
scalingo -a my-app addons-remove my-app_12345
scalingo -a my-app addons-upgrade my-app_12345 2g
```

### Read and watch the logs
`scalingo logs`

```bash
# Display the last 1000 lines of log
scalingo -a my-app logs -n 1000

# Follow the logs of your application in real-time
scalingo -a my-app logs -f

# Filter your logs by container type
scalingo -a my-app logs -F "web"
scalingo -a my-app logs --filter "worker"
scalingo -a my-app logs -F "web|worker"
```

### Run custom job
`scalingo run`

```bash
scalingo -a my-app run bundle exec rails console

# Define custom environment variables into the one-off container
scalingo -a my-app run --env CUSTOM_ENV=value --env ENV_EXAMPLE=custom <command>

# Upload a file to the one-off container (target is /tmp/uploads)
scalingo -a my-app run --file ./dump.sql <command>

# Start the one-off container with a specific size of container
scalingo -a my-app run --size 2XL <command>
```

### Get metrics of your application
`scalingo stats`

```bash
# Get the current stats of the containers of your app
scalingo -a my-app stats

# Display and update every 10 seconds the stats of the containers of your app
scalingo -a my-app stats --stream
```

### Access your database
`scalingo mongo-console|redis-console|mysql-console|pgsql-console|db-tunnel`

```bash
scalingo -a my-app mongo-console
scalingo -a my-app redis-console
scalingo -a my-app mysql-console
scalingo -a my-app pgsql-console

# Build an encrypted tunnel to access your database
scalingo -a my-app db-tunnel MONGO_URL
```

### Manage containers, scale
`scalingo ps|restart|scale`

```bash
scalingo -a my-app ps
scalingo -a my-app restart web:1
scalingo -a my-app scale web:2
scalingo -a my-app scale worker:2:L
scalingo -a my-app scale clock:0
```

## Configuration

### Application Detection

We try to detect automatically the name of your application according to:

* `SCALINGO_APP` environment variable
* `-a|--app`     flag of the command line to specify an application name
* `-r|--remote`  flag of the command line to specify a remote Git
* `scalingo` remote of your Git repository
