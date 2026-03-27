---
name: scalingo-generate-description
description: Generate or rewrite a Jekyll Markdown front matter `description` line that is short, actionable, and optimized for LLM page routing. Use when the user asks to create/update doc descriptions for llms.txt or metadata quality.
---

# Frontmatter Description

Generate a single-line Jekyll front matter description for documentation pages.

## When to use

Use this skill when the user asks to:
- create a page `description` field
- rewrite a `description` to be shorter, clearer, or more actionable
- optimize descriptions for LLM retrieval/routing (for example "find the page about app logs")

## Output contract

When no confirmation is required, return exactly one line:

`description: <text>`

Rules:
- keep a valid YAML front matter line

When interactive confirmation is required before edits:
- show the proposed line in a clearly separated block
- do not append inline confirmation text on the same paragraph
- use the interaction policy below

## Safety and edit policy

- Default behavior: propose text first, do not write immediately.
- Ask for explicit confirmation before file edits.
- If a `description` already exists, propose a replacement and wait for confirmation before overwriting.
- Only write directly without confirmation when the user explicitly asks to apply immediately.

### Interaction policy

If collaboration mode is `Plan`:
- Use `request_user_input` with one question and 2 options:
  - `Apply (Recommended)`: write the proposed `description` into the target file.
  - `Skip`: keep file unchanged.
- After the answer, either apply edit or continue without editing.

If collaboration mode is `Default`:
- Ask using a dedicated action block, never inline with the description.
- Required prompt format:
  - `ACTION REQUISE`
  - `Reponds: apply pour ecrire dans le fichier, ou skip pour ne rien changer.`
- Accept only `apply` or `skip` (case-insensitive). If ambiguous, ask again.
- If no target file is provided, ask for the file path before asking `apply` or `skip`.
- If `apply` is selected, write the new `description` immediately.
- After applying, confirm with a short status line and show the final written line.
- If `skip` is selected, confirm that no file was modified.

Recommended presentation template:

`Description proposee:`
`description: <text>`
`ACTION REQUISE`
`Reponds: apply pour ecrire dans le fichier, ou skip pour ne rien changer.`

## Content rules

- hard limit: 256 characters max
- target: 120 to 180 characters when possible
- sequence: page scope first, actionable outcomes second
- use concrete verbs: enable, disable, configure, deploy, retrieve, inspect, reset, monitor, troubleshoot
- include retrieval-critical nouns when relevant: logs, dashboard, CLI, API, environment variables, metrics, alerts
- avoid fluff and marketing language
- avoid repeating the title verbatim unless needed for disambiguation

## Writing process

1. Read title + section headings + first paragraphs.
2. Identify the top user intent this page solves.
3. Keep only high-signal terms that help routing.
4. Draft one concise line and trim aggressively.
5. Validate against checks below.

## Validation checks

- Is it <= 256 chars?
- Would it help route a query like "how to get app logs" or "how to reset 2FA"?
- Is each word useful for either scope or actionability?
- Is it specific enough versus nearby pages?

## Good pattern

`description: <What this page covers>. <What the user can do from it>.`

## Examples

`description: Retrieve and inspect Scalingo app logs from dashboard or CLI, understand log streams, and troubleshoot common runtime errors using actionable filtering and investigation steps.`

`description: Enable, disable, or recover 2FA for a Scalingo account with dashboard steps, TOTP validation, recovery code handling, and support escalation for authenticator loss.`
