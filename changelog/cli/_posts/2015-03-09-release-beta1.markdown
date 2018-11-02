---
title:	'Release of 1.0.0-beta1'
github: 'https://github.com/Scalingo/cli/releases'
---

http://cli.scalingo.com

Changelog:

* Windows, password: don't display password in clear
* Windows, db-tunnel: Correctly handle SSH key path with -i flag
* Send OS to one-off containers (for prompt handling, useful for Windows)
* Fix EOF error when writing the password
* Fix authentication request to adapt the API
* Correctly handle 402 errors (payment method required) #90
* Project is go gettable `go get github.com/Scalingo/cli`
* Fix GIT remote detection #89
* Correctly handle 404 Error, display clearer messages #91
* More documentation for the `run` command - Fixed #79
* Rewrite API client package, remove unsafe code - Fixed #80
* Allow environment variable name or value for `db-tunnel` as argument
* Extended help for `db-tunnel` - Fixed #85
* Ctrl^C doesn't kill an `run` command anymore - Fixed #83
* --app flag can be written everywhere in the command line - Fixed #10
* Use SSH agent if possible to get SSH credentials
* Correcty handle encrypted SSH keys (AES-CBC and DES-ECE2) - Fixed #76, #77
