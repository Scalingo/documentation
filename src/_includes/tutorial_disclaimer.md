<div id="tutorial_disclaimer" markdown="1">
## Disclaimer

This tutorial provides guidance based on approaches that are generally
considered effective and aligned with common industry practices. However, it
reflects a generalized perspective and may not be fully suitable for every
environment or use case.

While care has been taken to follow recognized best practices, the actual
implementation will depend on your specific infrastructure, constraints, and
requirements. **You remain solely responsible for evaluating, adapting, and
applying the instructions appropriately in your context**.

We strive to keep this content accurate and up to date. Nevertheless,
technologies, dependencies, and security standards evolve over time, and we
cannot guarantee that all information remains current or error-free.

All commands, configuration snippets, and examples are provided for
illustrative purposes only. They are not intended to be used verbatim in
production without proper review, testing, and adaptation.\\
**Final implementation decisions and their consequences are the responsibility
of the reader**.

### Security Notice

Proper security practices are essential when deploying software:
- **Always use strong, unique passwords** for all services and accounts.
- **Do not reuse credentials** across systems.
- Prefer long passphrases (at least 16 characters) combining letters, numbers,
  and symbols.
- **Store credentials securely** (e.g., password managers, secret management
  tools) and **never hardcode them in source code or configuration files**.

Here is an example command to generate a strong password from the command line:
```bash
openssl rand -base64 24
```

Alternatively:
```bash
head -c 32 /dev/urandom | base64
```

### Feedback and Contributions

If you identify an error, outdated information, or missing details,
contributions are welcome. You may:

- Get in touch with our Support Team
- [Open an issue](https://github.com/Scalingo/documentation/issues)
- [Submit a pull request](https://github.com/Scalingo/documenation/pulls)

Your feedback helps improve the quality and reliability of this documentation.
</div>
