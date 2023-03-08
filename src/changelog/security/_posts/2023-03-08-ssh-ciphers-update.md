---
modified_at:	2022-03-08 10:00:00
title:	'SSH - Adding new crypto algorithms, Sunset obsolete ones'
---

The list of allowed algorithms of `ssh.osc-fr1.scalingo.com` and
`ssh.osc-secnum-fr1.scalingo.com` have been updated.

Before:

```
# key exchange algorithms
(kex) curve25519-sha256@libssh.org  -- [info] available since OpenSSH 6.5, Dropbear SSH 2013.62
(kex) ecdh-sha2-nistp256            -- [fail] using weak elliptic curves
                                    `- [info] available since OpenSSH 5.7, Dropbear SSH 2013.62
(kex) ecdh-sha2-nistp384            -- [fail] using weak elliptic curves
                                    `- [info] available since OpenSSH 5.7, Dropbear SSH 2013.62
(kex) ecdh-sha2-nistp521            -- [fail] using weak elliptic curves
                                    `- [info] available since OpenSSH 5.7, Dropbear SSH 2013.62
(kex) diffie-hellman-group14-sha1   -- [warn] using weak hashing algorithm
                                    `- [info] available since OpenSSH 3.9, Dropbear SSH 0.53

# host-key algorithms
(key) ssh-rsa (4096-bit)            -- [fail] using weak hashing algorithm
                                    `- [info] available since OpenSSH 2.5.0, Dropbear SSH 0.28
                                    `- [info] a future deprecation notice has been issued in OpenSSH 8.2: https://www.openssh.com/txt/release-8.2
(key) ssh-ed25519                   -- [info] available since OpenSSH 6.5

# encryption algorithms (ciphers)
(enc) aes128-ctr                    -- [info] available since OpenSSH 3.7, Dropbear SSH 0.52
(enc) aes192-ctr                    -- [info] available since OpenSSH 3.7
(enc) aes256-ctr                    -- [info] available since OpenSSH 3.7, Dropbear SSH 0.52
(enc) aes128-gcm@openssh.com        -- [info] available since OpenSSH 6.2

# message authentication code algorithms
(mac) hmac-sha2-256                 -- [warn] using encrypt-and-MAC mode
                                    `- [info] available since OpenSSH 5.9, Dropbear SSH 2013.56
(mac) hmac-sha1                     -- [warn] using encrypt-and-MAC mode
                                    `- [warn] using weak hashing algorithm
                                    `- [info] available since OpenSSH 2.1.0, Dropbear SSH 0.28
```

After:

```
# key exchange algorithms
(kex) curve25519-sha256@libssh.org   -- [info] available since OpenSSH 6.5, Dropbear SSH 2013.62

# host-key algorithms
(key) rsa-sha2-512 (4096-bit)        -- [info] available since OpenSSH 7.2
(key) rsa-sha2-256 (4096-bit)        -- [info] available since OpenSSH 7.2
(key) ssh-ed25519                    -- [info] available since OpenSSH 6.5

# encryption algorithms (ciphers)
(enc) chacha20-poly1305@openssh.com  -- [info] available since OpenSSH 6.5
                                     `- [info] default cipher since OpenSSH 6.9.
(enc) aes128-gcm@openssh.com         -- [info] available since OpenSSH 6.2

# message authentication code algorithms
(mac) hmac-sha2-256-etm@openssh.com  -- [info] available since OpenSSH 6.2
```

**Compatibility Information**: Minimum version of OpenSSH to connect to these
servers is 7.2, released in February 2016.
