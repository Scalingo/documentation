---
name: scalingo-security-bulletin
description: Use when drafting or updating a customer-facing Scalingo Security Bulletin (SSB) in this documentation repository. Covers evidence, customer actions, and adversarial review; not general security research or incident triage.
---

# Scalingo security bulletins

Write a bulletin a customer can use to decide whether they are affected, what to do, and how to verify the result. Read `CONTRIBUTING.md` and a nearby bulletin before editing. The [PHP2Shell](../../../src/_posts/security/bulletins/2026-10-21-SSB-2026-005.md), [eMudhra](../../../src/_posts/security/bulletins/2026-10-21-SSB-2026-006.md), and [Node2Shell](../../../src/_posts/security/bulletins/2026-10-23-SSB-2026-007.md) bulletins show different action and impact cases; follow the relevant case rather than copying every section.

## Establish the facts

- Check the latest repository revision and existing SSB numbers before choosing a filename under `src/_posts/security/bulletins/`. Bulletins use their publication date and `SSB-YYYY-NNN` in the filename, unlike ordinary documentation posts.
- Verify CVE identifiers, severity *and scoring version*, affected and fixed versions, exploit conditions, and release dates against primary public sources. Attribute differing vendor and CVSS ratings instead of flattening them into one score.
- Verify Scalingo changes separately: a fix added to a buildpack or stack does not update an already deployed application. State whether a customer must rebuild, redeploy, change a version constraint, or update a custom image, and how they can check the running result.
- Publish only facts approved for customers. Do not copy internal ticket links, private hostnames, customer identifiers, unverified exploit claims, or operational details from incident notes into the bulletin. Distinguish what happened, what is planned, and what remains unknown.

## Give customers a usable answer

Use the established structure where it helps: a TL;DR with impact and immediate action; what happened and the conditions for exploitation; what Scalingo did; numbered customer actions; product impacts; contact; a dated timeline; and a changelog for published revisions. Add sections such as data affected or future actions only when the incident needs them. Use the nearby bulletin's front matter, including `cvss` when a defensible score is available.

For each action, say **who** needs it, **what** to change, **how** to deploy it, and **how** to verify it. Cover exact pins or constraints that can keep an unsafe version, custom runtimes or buildpacks, and the difference between restart and rebuild when relevant. A temporary mitigation needs its limits, customer-visible side effects, and any supported way to request an exception; it must not read like a complete fix if another exposure path remains.

Use public HTML pages and canonical documentation links. Check that commands, version numbers, links, and product names work as written. Keep the explanation concise enough that a customer can find the required action without reading the incident history.

## Adversarial customer review — required for every update

Before publishing *any* new or changed bulletin, read the rendered page as a skeptical customer. Test these questions against the actual text, then revise it:

1. Could a customer with an affected version, an exact version pin, or a custom runtime follow the steps and still remain vulnerable while believing they are safe?
2. Could a customer mistake an available upstream fix, a merged buildpack change, a planned platform measure, or a restart for protection already active in their application?
3. Could a workaround break legitimate traffic or behavior? Does the bulletin tell affected customers how to adapt and what risk returns if the rule is disabled?
4. Are the exploit path, affected products, and non-affected paths precise enough to avoid both false reassurance and unnecessary work?
5. Can every event and publication claim in the timeline and changelog be verified? Use absolute dates, times, and a stated timezone when known. Do not describe a planned event as completed or claim publication while the public page is unavailable.

Record material corrections in the changelog once published. Preserve superseded published facts as `CONTRIBUTING.md` directs. Run the repository's Jekyll build and inspect the rendered bulletin, including CSS and links, before reporting it ready.
