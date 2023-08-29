You can use our utility tool `dbclient-fetcher` to download and install the
tools for the database of your choice. To do so, call `dbclient-fetcher` with
the `db_kind` of your choice (see table above).

For example, to download the tools to interact with your MySQL addon:

```bash
[10:48] Scalingo ~ $ dbclient-fetcher mysql
---> Download and extract the database CLI
---> Database CLI installed:
mysql  Ver 8.0.33 for Linux on x86_64 (Source distribution)
```

If you ever need a specific version, just add it as a second parameter:

```bash
[10:48] Scalingo ~ $ dbclient-fetcher mysql 8.0
---> Download and extract the database CLI
---> Database CLI installed:
mysql  Ver 8.0.33 for Linux on x86_64 (Source distribution)
```
