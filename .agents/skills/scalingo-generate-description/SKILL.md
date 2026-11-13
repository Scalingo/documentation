---
name: scalingo-generate-description
description: Generate or rewrite concise, source-grounded Jekyll front matter descriptions for Scalingo documentation, SEO snippets, and llms.txt page routing.
---

# Frontmatter Description

Write a description that helps a reader or retrieval system choose the right
documentation page for a task or question.

## Scope and edits

- Read the requested pages before drafting. For a PR, identify its base and changed
  files; include added, modified, and renamed content pages at their current paths.
- Skip deleted pages, includes, configuration, and empty navigation files. Do not
  invent content for a page that only defines navigation metadata.
- Propose descriptions by default. If the user asks to apply descriptions or run
  iterative edits, that authorizes edits within that scope, including replacements;
  do not ask again for each page or round. Otherwise, ask before writing.
- Change only `description` and any modification date required by repository
  conventions. Preserve page bodies and unrelated metadata. Never commit unless asked.

## Output contract

For a single description request, return exactly one line:

`description: "<text>"`

For a batch, identify each file and its description. If the user requests an
evaluation or log, include the requested analysis separately.

- Use one YAML line with a double-quoted value; escape embedded double quotes and
  backslashes. No Markdown, HTML, Liquid, links, or line breaks in the value.
- Use the page's language and established product terminology. Name concepts
  with terms the page uses and, where possible, explains or defines. Do not
  introduce a parallel vocabulary or a new abstract object while summarizing:
  “assign a role” does not establish an “assignment” concept. Ordinary grammatical
  changes are fine; this is a terminology check, not literal word matching.
- Maximum: 256 characters in the description value, excluding YAML syntax. This
  is a ceiling, not a target. Stop once the main intent and distinguishing scope
  are clear; never add weak or secondary topics to use the remaining characters.
  The 120–180 range is only a guide: prefer a shorter, focused description over
  a longer, diluted one. There is no minimum length.
  This is a local metadata constraint, not a Google snippet-length requirement.

## Select the information

Read the title, headings, full body, and content-bearing Jekyll includes. The title
and first paragraph alone can overemphasize prerequisites or miss the actual task.
Use only explicit page content; do not add capabilities from general product knowledge.
Distinguish what the page explains from tasks merely mentioned in navigation,
related links, or Next Steps. Do not advertise a linked procedure as if this page
contained it. An overview may summarize its documented scope without pretending
to provide detailed instructions.

Prioritize:

1. The main task or question and the exact product object it concerns.
2. The distinction needed to choose this page over its neighbors: database engine,
   Shared or Dedicated Resources, personal account or organization, resource role
   or organization role.
3. A useful outcome or interface, only when it changes which page the reader needs.

Omit by default:

- Preview/beta status, rollout dates, release promotion, sales contact gates,
  temporary limitations, and roadmap statements.
- Prerequisite lists, eligibility gates, quotas, invitation expiry, prices, example
  identifiers, UI click paths, and implementation keys.
- Secondary topics, exhaustive section summaries, and generic claims about
  security, simplicity, performance, or control.

Keep a condition only when omitting it would misrepresent the page's main subject
or the action described. For example, keep the personal-account scope of a free
trial page, but omit its signup prerequisites and resource quotas. Describe
automatic billing when it is a central behavior of that page. A duration that
defines the subject (a 30-day trial) is different from a temporary rollout date.
Do not let a warning displace the task it qualifies.

## Tone and sentence form

- Prefer one direct sentence. Put the object and intent near the beginning.
- For a procedure, start with a concrete action: create, configure, view, export,
  compare, reset, revoke, or troubleshoot. Avoid a title-like fragment followed by
  another sentence, and avoid “This page covers”, “Learn how to”, and “Understand”.
- For a conceptual page, an active statement about the product or rule is valid;
  do not force an artificial task. Reference pages can start with “Compare”.
- For an announcement, describe the change or feature in the present tense.
  Do not imply that the announcement contains a configuration procedure or copy
  “new”, “now available”, or release promotion into the description.
- Use specific verbs instead of “manage” where a more precise verb fits. Avoid
  “enable” when it means “make possible” rather than switching a setting on.
- Keep the main action and closely related outcomes. Do not turn the description
  into a list of every heading, role, interface, or exception. Related operations
  on the same object may form one coherent intent; do not append a separate topic
  just because the page mentions it.
- Describe the exact operation: “create read-only users” is not “change user
  permissions”. Say “revoke access”, rather than “revoke collaborators”. Avoid
  implying every role applies to every resource or every action to every listed
  interface. Drop an interface list when the object and action already route well.
- Retain retrieval-critical nouns naturally. Repeat a title term when needed to
  identify the object; avoid verbatim title repetition and keyword stuffing.

## Review before writing

Check each description against the body, then compare sibling pages:

- Can every action and qualification be traced to substantive content on this
  page, including its relevant includes, rather than only to a linked page?
- Does the description match the page type: procedure, concept, reference, or
  announcement? Does it promise only what this page actually explains?
- Do the nouns naming concepts come from the page's terminology, preferably
  terms it explains? Check noun phrases and nominalizations as well as factual
  meaning; a related verb in the source does not establish a new product object.
- Does the first clause identify the main intent and the correct object?
- Is the sentence active, natural, and useful without the title?
- Does each detail help select this page rather than summarize a secondary section?
- Before accepting a shorter version, compare what it drops: keep terms naming a
  distinct user task or product scope, and remove redundant wording first. A lower
  character count alone is not evidence of improvement.
- Are different objects and scopes still distinguishable across the batch?
- Is the value valid YAML, on one line, and no longer than 256 characters?

After writing, read back the values and inspect the diff for unrelated changes.
Describe static validation as such; do not claim SEO or retrieval gains without
measurements. In this repository, `llms.txt` uses descriptions directly, but the
HTML head prefers `page.excerpt` over `page.description`; editing a description
alone does not guarantee a changed search snippet.

## Examples

`description: "View and export application collaborators and their 2FA status from your Scalingo personal account as CSV or JSON."`

`description: "Compare Owner, Collaborator, and Limited Collaborator permissions for Scalingo applications, including deployments, settings, and data access."`

`description: "Scalingo organizations group projects, resources, and members under separate administration and billing."`

`description: "On Scalingo, each collaborator has a role that defines what they can do on an application or database."`
