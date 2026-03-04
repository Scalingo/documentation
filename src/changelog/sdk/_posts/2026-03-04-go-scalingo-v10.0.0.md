---
modified_at: 2026-03-04 00:00:00
title: 'go-scalingo - New version: 10.0.0'
github: 'https://github.com/Scalingo/go-scalingo'
---

## Breaking Changes

* `LogsURL` signature changed from `(*http.Response, error)` to `(*LogsURLRes, error)`.
  You no longer need to read and decode the response body yourself.
  Old usage:
  ```go
  resp, err := client.LogsURL(ctx, app)
  // decode {"logs_url": "..."} from resp.Body
  ```
  New usage:
  ```go
  logsURLRes, err := client.LogsURL(ctx, app)
  logsResp, err := client.Logs(ctx, logsURLRes.LogsURL, n, filter)
  ```
  The returned type is:
  ```go
  type LogsURLRes struct {
      LogsURL string `json:"logs_url"`
      App     *App   `json:"app,omitempty"`
  }
  ```

* Internal error wrapping moved from `gopkg.in/errgo.v1` to `github.com/Scalingo/go-utils/errors/v3`.
  If your code assumes SDK errors are `*errgo.Err` (or uses `errgo`-specific helpers on SDK-returned errors), update that logic to use generic error handling (`errors.Is` / `errors.As`) instead.

* The function `(*APIRequest).BuildQueryFromParams` is no longer publicly exported.

* The function `http.NewRequestFailedError` now takes a `context.Context` as its first parameter.


## Changelog

* chore(databases): refactor constants
* build(deps): update `github.com/golang-jwt/jwt` from v4 to v5
* refactor: replace `errgo` with `github.com/Scalingo/go-utils/errors/v3` (breaking change)
* feat(logs): `LogsURL` returns a parsed structure (breaking change)
* refactor: autofix by `go fix` and `golangci-lint`
* refactor: remove use of a custom pagination structure
