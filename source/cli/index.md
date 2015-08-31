---
title: Command Line Tool
date: 23/09/2014
tag: cli, interface, app
category: app
---

# Command Line Tool

## Installation

We provide a command line tool able to interact with the platform.

You can find it here with its documentation [http://cli.scalingo.com](http://cli.scalingo.com)

## Tips

* You can use tne environment `SCALINGO_APP` instead of using the `--app` flag
* If your current directory is the base directory of your project
  and that your git repository has a remote named 'scalingo', you
  don't need to specify `--app <name>` it will be detected automatically.
  * If you want to specify the remote name, you can do it by using `--remote` or `-r` flag followed
    by the name

## Command Completion

### Bash

* Make sure bash completion is installed. If you use a current Linux in a non-minimal installation, bash completion should be available. On a Mac, install with `brew install bash-completion`

* Get bash completion script in the correct folder:
  * Linux users :

```bash
curl "https://raw.githubusercontent.com/Scalingo/cli/master/cmd/autocomplete/scripts/scalingo_complete_bash" > /etc/bash_completion.d/scalingo_complete_bash.sh
```
  * Mac users :

```bash
curl "https://raw.githubusercontent.com/Scalingo/cli/master/cmd/autocomplete/scripts/scalingo_complete_bash" > /usr/local/etc/bash_completion.d/scalingo_complete_bash.sh
```


* Reload your shell in order to make the completion available: `exec bash -l`

### Zsh

* Get zsh completion script in the folder you want (~/.zsh/completion/):

```bash
curl "https://raw.githubusercontent.com/Scalingo/cli/master/cmd/autocomplete/scripts/scalingo_complete_zsh" > ~/.zsh/completion/scalingo_complete_zsh
```

* Make sure the completion script will be loaded, by adding to the following line to your `~/.zshrc` :

```bash
source ~/.zsh/completion/scalingo_complete_zsh
```

* Reload your shell: `exec zsh -l`
