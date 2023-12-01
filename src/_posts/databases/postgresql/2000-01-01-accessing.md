---
title: Accessing Your Scalingo for PostgreSQL® Addon
nav: Accessing
modified_at: 2023-12-01 00:00:00
tags: databases postgresql addon
index: 6
---


## Using the Interactive Remote Console

### Connecting

1. Make sure you have correctly [setup the Scalingo Command Line tool]({% post_url platform/cli/2000-01-01-start %})
2. From the command line, open a console for your Scalingo for PostgreSQL®
   addon:
   ```bash
   scalingo --app my-app pgsql-console
   ```
   The output should look like this:
   ```bash
   -----> Starting container one-off-7872  Done in 0.479 seconds
   -----> Connecting to container [one-off-7872]...  
   -----> Process 'pgsql-console my_app_4553' is starting...  

   Hello from bashrc.
   ---> Download and extract the database CLI
   ---> Database CLI installed:
   psql (PostgreSQL) 14.6
   psql (14.6, server 14.8 (Debian 14.8-1.pgdg110+1))
   SSL connection (protocol: TLSv1.3, cipher: TLS_AES_256_GCM_SHA384, bits: 256, compression: off)
   Type "help" for help.

   my_app_4553=>
   ```

### Exiting




## Using an Encrypted Tunnel

## ...
