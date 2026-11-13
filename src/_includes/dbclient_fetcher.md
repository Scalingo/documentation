You can use our utility tool `dbclient-fetcher` to download and install the
tools for your database. To do so, call `dbclient-fetcher` with the *keyword*
corresponding to your database (see table above).

For example, to download the tools to interact with your MySQL addon:

```bash
[10:48] Scalingo ~ $ dbclient-fetcher mysql
---> Download and extract the database CLI
---> Database CLI installed:
...
```

If you ever need a specific version, just add it as a second parameter:

```bash
[10:48] Scalingo ~ $ dbclient-fetcher mysql <version>
---> Download and extract the database CLI
---> Database CLI installed:
...
```
