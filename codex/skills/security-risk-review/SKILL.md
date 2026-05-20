---
name: security-risk-review
description: Review code, pull requests, designs, architecture changes, and product flows for security bugs, hardcoded secrets, abuse paths, and cost-scaling risk. Use when Codex is asked for a security review, secrets scan, abuse/misuse review, threat-model pass, rate-limit/quota review, cost explosion review, or PR/design review involving auth, user input, external APIs, background jobs, files, payments, AI/model calls, messaging, signup, invitations, scraping, logging, or sensitive data.
---

# Security Risk Review

## Overview

Use this skill to review real artifacts for concrete, actionable risk. Prefer evidence from code, diffs, configs, logs, tests, schemas, and product docs over generic security advice.

## Workflow

1. Identify the reviewed surface: changed files, entrypoints, callers, data stores, external services, background jobs, user roles, and trust boundaries.
2. Run the bundled scanner when reviewing a repository, diff, or file tree:

```bash
python3 /Users/cseibert/.codex/skills/security-risk-review/scripts/scan_secrets.py <paths...>
```

Use `--json` for machine-readable output and `--fail-on-findings` only when a nonzero exit code is useful. Never paste full secret values into the response.

3. Trace risky flows end to end: request or event source, authentication, authorization, validation, side effects, persistence, logging, retries, billing, and user-visible output.
4. Report only issues that are plausible for the artifact. Avoid checklist dumping. If something is uncertain, call it an assumption or open question.

## Review Lenses

### Secrets

Look for hardcoded API keys, private keys, tokens, passwords, webhook URLs, database URLs, credentials in examples, committed `.env` files, logs, fixtures, generated files, screenshots, mobile bundles, and client-side config. If a real secret may have been committed, recommend immediate rotation/revocation and history cleanup rather than only deleting the current line.

### Security

Prioritize authn/authz bypass, IDOR, tenant isolation, injection, XSS, CSRF, SSRF, path traversal, unsafe file handling, unsafe deserialization, weak crypto, dependency exposure, insecure defaults, missing audit trails, PII leakage, and sensitive data in logs or analytics.

### Abuse

Check whether the feature can be used for spam, enumeration, scraping, credential stuffing, invite/referral abuse, payment abuse, free-tier bypass, replay, automated account creation, harassment, content laundering, or moderation evasion. Look for missing rate limits, quotas, friction, idempotency, provenance, alerts, and operator controls.

### Cost Scaling

Check for unbounded fanout, recursive or repeated work, retry storms, queue amplification, excessive polling, external API loops, AI/model calls without token/file-size caps, expensive database scans, cache misses, missing per-user/project budgets, absent kill switches, and weak attribution for who caused spend.

## Output Contract

Lead with findings, ordered by severity. For each finding include:

- A file and line reference when available.
- The impact and likely exploit or failure path.
- A concrete fix.
- A test or verification step.

If no issues are found, say that clearly and include residual risk, such as code paths not reviewed, scanner limitations, missing runtime config, or assumptions about deployment controls.

Use a code-review tone for PRs: concise, specific, and grounded in the artifact. Do not overstate speculative risk, and do not expose secret material beyond masked snippets.

## Scanner Notes

The scanner is intentionally conservative and dependency-free. Treat hits as review leads, not proof. It skips common dependency, build, cache, and VCS directories; scans text-like files; masks candidate values; and combines high-signal token patterns with entropy checks for generic secret assignments.
