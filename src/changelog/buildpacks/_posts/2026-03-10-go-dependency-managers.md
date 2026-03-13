---
modified_at: 2026-03-10 12:00:00
title: 'Go - Remove support for some dependency managers'
github: 'https://github.com/Scalingo/go-buildpack'
---

Support for the following dependency managers has been removed from the
buildpack:
- `dep`
- `godep`
- `govendor`
- `glide`
- `GB`

Please use `go.mod` instead. For futher help, please see
[our documentation][https:/doc.scalingo.com/languages/go/gomod].
