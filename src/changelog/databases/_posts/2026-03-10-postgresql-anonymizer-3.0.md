---
modified_at: 2026-03-10 10:00:00
title: 'PostgreSQL Anonymizer 3.0 — Important Security Updates'
---

Dalibo has released [PostgreSQL Anonymizer 3.0](https://www.postgresql.org/about/news/postgresql-anonymizer-30-parallel-static-masking-json-import-export-3236/), a new major version of its privacy-by-design extension.

**This release includes important security fixes and should be adopted as soon as possible.**

Changelog :

- PostgreSQL® Anonymizer 3.0 is now available with Scalingo for PostgreSQL® `17.9.0-2`
- Legacy Static Masking was deprecated since version 2.0 and it is now fully removed
- The anon.pg_masking_rules view is replaced by anon.{all|sys|user}_rules

Before upgrading, make sure to read the [PostgreSQL® Anonymizer upgrade procedure]({% post_url databases/postgresql/extensions/2000-01-01-postgresql-anonymizer %}#upgrading-postgresql-anonymizer).

Note: Scalingo for PostgreSQL® 16.x will remain on the PostgreSQL® Anonymizer 2.x branch.
