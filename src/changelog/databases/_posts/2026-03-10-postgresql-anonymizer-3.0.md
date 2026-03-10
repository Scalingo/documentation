---
modified_at: 2026-03-10 10:00:00
title: 'PostgreSQL Anonymizer 3.0 — Important Security Updates'
---

Dalibo has released [PostgreSQL Anonymizer 3.0](https://www.postgresql.org/about/news/postgresql-anonymizer-30-parallel-static-masking-json-import-export-3236/), a new major version of its privacy-by-design extension.

**This release includes important security fixes and should be adopted as soon as possible.**

- PostgreSQL® Anonymizer 3.0 is now available with Scalingo for PostgreSQL® `17.9.0-2`
- PostgreSQL® 16 images remain on the PostgreSQL® Anonymizer 2.x branch

Upgrading from the 2.x branch to 3.x requires a specific procedure. Before upgrading a database to PostgreSQL® 17.9.0-2 or later, the extension must be dropped and recreated after the upgrade. See the [PostgreSQL® Anonymizer documentation page]({% post_url databases/postgresql/extensions/2000-01-01-postgresql-anonymizer %}#upgrading-postgresql-anonymizer) for the full procedure.
