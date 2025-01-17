---
title: PostgreSQL Anonymizer
nav: PostgreSQL Anonymizer
modified_at: 2025-01-24 09:00:00
tags: databases postgresql anonymization extensions
index: 16
---

**PostgreSQL Anonymizer** is an open-source extension for PostgreSQL® that facilitates the masking or replacement of personally identifiable information (PII) and commercially sensitive data directly within a database.

This extension is particularly useful for organizations handling sensitive data and is designed with **anonymization by design** principles to ensure compliance with privacy regulations such as GDPR, HIPAA, and CCPA.

The extension supports the following features:

- Static anonymization: Irreversibly anonymize data for development or testing environments.
- Dynamic masking: Apply real-time masking to hide sensitive information for specific users or roles.
- Customizable anonymization rules: Use pre-defined or user-defined strategies for anonymization.
- Multiple anonymization techniques: Including randomization, hashing, and data redaction.
- Role-based access control: Restrict visibility of sensitive data based on user roles.
- Compatibility with standard PostgreSQL queries and tools.

## Usage Examples for PostgreSQL Anonymizer
### Anonymizing Entire Rows with a Query

Suppose you have a table named users containing the columns `first_name`, `last_name`, `email`, and `phone`. If you want to retrieve as many rows as your query can fetch with anonymized data, you can use the following query:

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

### Dynamic Masking for Read-Only Users

Suppose you have a table named users containing the columns `first_name`, `last_name`, `email`, and `phone`. If you want to hide sensitive data dynamically for specific users, such as a "read-only" user as "MASKED", you can declare `SECURITY LABEL` for its. Other roles will still access the original data.

Example: Hiding Data for a "Masked" User

```sql
-- View data as a regular user
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

-- Connect as the masked user and view data
\c - my_read_only_user
SELECT * FROM people;

 Result:
  id | firstname | lastname  |    phone     |           email            
 ----+-----------+-----------+--------------+----------------------------
   1 |  Reginald | Preston   | +33477420668 | rayamanda@example.net
   2 |  Shaffer  | Cristian  | +33225352636 | mariahpatrick@example.org
```

## Enabling PostgreSQL Anonymizer

To enable PostgreSQL Anonymizer:

1. Create a "read_only" user through your database dashboard.
2. Contact our support team and provide the name of your "read_only" user to request activation of the extension.
3. Our team will activate the extension and set up masking for your "read_only" user.
4. Once completed, you can use the extension to define and manage masking rules for your "read_only" user independently.
