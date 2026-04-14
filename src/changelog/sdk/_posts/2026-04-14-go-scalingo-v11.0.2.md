---
modified_at: 2026-04-14 00:00:00
title: 'go-scalingo - New version: 11.0.2'
github: 'https://github.com/Scalingo/go-scalingo'
---

## Breaking Changes in v11

* `PrivateNetworksDomainsList` signature changed. It must take a `pagination.Request` in argument instead of the separated `page` and `perPage` arguments.
  Old usage:
  ```go
  domainNames, err := scalingoClient.PrivateNetworksDomainsList(ctx, app, page, perPage)
  ```
  New usage:
  ```go
  domainNames, err := scalingoClient.PrivateNetworksDomainsList(ctx, app, pagination.NewRequest(page, perPage))
  ```

* `Logs` signature changed. It returns a `io.ReadCloser` instead of a `*http.Response`.
  Old usage:
  ```go
  httpResponse, _ := c.Logs(ctx, logsURL, n, filter)
  defer httpResponse.Close()
  sr := bufio.NewReader(httpResponse.Body)
  // ...
  ```
  New usage:
  ```go
  readCloser, _ := c.Logs(ctx, logsURL, n, filter)
  defer readCloser.Close()
  sr := bufio.NewReader(readCloser)
  // ...
  ```

## Changelog

* fix(privatenetworks): `PrivateNetworksDomainsList` must take a `pagination.Request` in argument (breaking change)
* fix(errors): detect if body is invalid in case of 422
* refactor: replace `github.com/golang/mock` with `go.uber.org/mock`
* refactor(env): replace most calls to `Do` with calls to `DoRequest` (breaking change)
* chore(deps): bump `golang.org/x/text` from `0.34.0` to `0.35.0` ([#494](https://github.com/Scalingo/go-scalingo/pull/494))
* build: align Dockerfile Go version with `go.mod` ([#494](https://github.com/Scalingo/go-scalingo/pull/494))
* feat(EventRestart): add `Reason` field
