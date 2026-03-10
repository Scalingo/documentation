---
title: PostgreSQL® Anonymizer
nav: PostgreSQL® Anonymizer
modified_at: 2026-03-10 10:00:00
tags: databases postgresql anonymization extensions
index: 50
---

**PostgreSQL® Anonymizer** is an open-source extension for PostgreSQL® that
facilitates the masking or replacement of personally identifiable information
(PII) and commercially sensitive data directly within a database.

This extension is particularly useful for organizations handling sensitive data
and is designed with **anonymization by design** principles to ensure
compliance with privacy regulations such as GDPR, HIPAA, and CCPA.

This extension adds several features and functions. You can find more
information on the [official documentation][official_doc].

{% warning %}
PostgreSQL® Anonymizer 3.0 includes important security fixes. If you are using
the 2.x branch, plan your upgrade as soon as possible.
{% endwarning %}


## Enabling PostgreSQL® Anonymizer

1. [Create a new user with read only abilities][creating-user]
2. Contact our support team and provide the name of the user you just created
   to request activation of the extension
3. Our team activates the extension and sets up masking for the given user
4. Once done, you can define and manage masking rules for your user
   autonomously as described below.


## Upgrading PostgreSQL® Anonymizer

PostgreSQL® Anonymizer cannot be upgraded in place. If you upgrade your 
PostgreSQL® database to a version that ships a different major version of the 
extension, you must drop the extension before upgrading the database and 
recreate it afterwards.

{% warning %}
PostgreSQL® Anonymizer 3.0 fixes [two critical vulnerabilities](https://www.postgresql.org/about/news/postgresql-anonymizer-30-parallel-static-masking-json-import-export-3236/#:~:text=Important%20Security%20Updates) that could allow users to gain superuser privileges under certain conditions. To benefit from these fixes, upgrade your PostgreSQL database to `17.9.0-2` as soon as possible.
{% endwarning %}

The required procedure is the following:

1. Drop the extension from your database:

   ```sql
   DROP EXTENSION IF EXISTS anon CASCADE;
   ```

2. Upgrade your database to the Scalingo for PostgreSQL® version that ships a
   higher major branch of PostgreSQL® Anonymizer
3. Contact our support team so we can re-create the extension and configure it
   again if needed

### Upgrading from 2.x to 3.x

The "Legacy Dynamic Masking" was the dynamic masking method used in version 1.x. It is now completely removed and replaced by "Transparent Dynamic Masking".

If you are still using Legacy Dynamic Masking in version 2.x, you must [disable it BEFORE upgrading](https://postgresql-anonymizer.readthedocs.io/en/stable/UPGRADE/).


## Example: Dynamic Masking for Read-Only Users

Suppose you have a table named users containing the columns `first_name`,
`last_name`, `email`, and `phone` and you want to hide sensitive data
dynamically for specific users.

These users must be restricted to read-only abilities and must have been masked
as described above. You can then declare `SECURITY LABEL` with your regular
user.

- Regular roles still have access to the original data
- Masked users see altered data according to the masking rules

Connect as the regular user to the database:

```sql
SELECT * FROM people;

Result:
  id | firstname | lastname |   phone    |         email
 ----+-----------+----------+------------+-------------------------
   1 | Sarah     | Conor    | 0606060606 |  sarah.conor@example.com
   2 | John      | Doe      | 0707070707 |  john.doe@example.com

-- Declare the masking rules
SECURITY LABEL FOR anon ON COLUMN people.lastname
IS 'MASKED WITH FUNCTION anon.dummy_last_name();';

SECURITY LABEL FOR anon ON COLUMN people.phone
IS 'MASKED WITH FUNCTION anon.partial(phone, 2, $$******$$, 2)';
```

Connect as the read-only user to the database and view data:

```sql
SELECT * FROM people;

 Result:
  id | firstname | lastname  |    phone     |           email
 ----+-----------+-----------+--------------+----------------------------
   1 |  Sarah    | Preston   | 06********06 | sarah.conor@example.com
   2 |  John     | Cristian  | 07********07 | john.doe@example.com
```


## Example: Anonymizing Entire Rows with a Query

Suppose you have a table named users containing the columns `first_name`,
`last_name`, `email`, and `phone`. If you want to retrieve as many rows as your
query can fetch with anonymized data, you can use the following query:

```sql
SELECT anon.fake_last_name() AS anonymized_last_name,
       anon.fake_first_name() AS anonymized_first_name,
       anon.random_phone('+33') AS anonymized_phone,
       anon.fake_email() AS anonymized_email
FROM users;

anonymized_last_name | anonymized_first_name | anonymized_phone |      anonymized_email
----------------------+-----------------------+------------------+-----------------------------
 Garza                | Reginald              | +33959147281     | richardsmall@example.org
 Schwartz             | Amber                 | +33180356490     | brittanystewart@example.net
 Shelton              | Kerry                 | +33711805689     | boyerkrystal@example.com
 Mcneil               | Darryl                | +33982131333     | leethomas@example.net
 Mcintosh             | Evan                  | +33158299618     | mariahpatrick@example.org
 Shaffer              | Cristian              | +33225352636     | ashley66@example.org
 Mack                 | Kaitlyn               | +33739247085     | rayamanda@example.net
 Warren               | Vanessa               | +33531162736     | allen06@example.com
 Baldwin              | Sarah                 | +33113538315     | tpeterson@example.net
 Hudson               | Preston               | +33477420668     | andreaortiz@example.com
```


[official_doc]: https://postgresql-anonymizer.readthedocs.io/en/stable/

[creating-user]: {% post_url databases/postgresql/shared-resources/guides/2000-01-01-managing-users %}#creating-a-new-user
