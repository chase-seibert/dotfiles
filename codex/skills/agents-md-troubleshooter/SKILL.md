---
name: agents-md-troubleshooter
description: Parse, audit, and troubleshoot AGENTS.md and Codex instruction files. Use when Codex needs to inspect user-level and project-level AGENTS.md files, follow referenced local instruction/domain files, diagnose missing, unreadable, ambiguous, duplicate, or circular references, identify conflicting instructions, explain effective precedence, or propose fixes without applying edits unless explicitly asked.
---

# AGENTS.md Troubleshooter

## Overview

Use this skill to build the complete local instruction graph for Codex before diagnosing AGENTS.md behavior. Always consider user-level and project-level instructions together, then apply project precedence when explaining the effective behavior.

## Workflow

1. Identify the target project from the user's prompt or current working directory.
2. Run the checker:

```bash
python3 /Users/cseibert/.codex/skills/agents-md-troubleshooter/scripts/check_agents_refs.py <project-or-file-path>
```

3. Load and read every readable local file reported by the checker that is relevant to the audit. At minimum, read all present standard instruction files and referenced Markdown instruction files.
4. Analyze the effective instruction set using this precedence, lowest to highest:
   - `/Users/cseibert/.codex/AGENTS.md`
   - `<project-root>/AGENTS.md`
   - `<project-root>/AGENTS.override.md`
5. Treat referenced subfiles as belonging to the precedence tier of the file that referenced them. If the same subfile is referenced from multiple tiers, use the highest referring tier when discussing conflicts.
6. Report findings before proposing changes. Do not edit files unless the user explicitly asks for implementation.

## Checker Capabilities

The checker is deterministic and uses only the Python standard library. It:

- Detects the project root with `git rev-parse --show-toplevel`, falling back to the supplied directory.
- Loads standard files if present: user-level `AGENTS.md`, project `AGENTS.md`, and project `AGENTS.override.md`.
- Resolves absolute paths, `~`, Markdown links, `Load ...` lines, and `@file.ext` references.
- Resolves relative references from the file that contains them.
- Reports missing, unreadable, non-file, duplicate, circular, external URL, and max-depth-skipped references.
- Supports JSON output:

```bash
python3 /Users/cseibert/.codex/skills/agents-md-troubleshooter/scripts/check_agents_refs.py <project-or-file-path> --json
```

Use `--strict` only when a nonzero exit status is useful for automation.

## Audit Output

When responding to the user, use this order:

1. Loaded instruction files and effective precedence.
2. Reference graph issues: missing files, unreadable files, duplicate references, circular references, and external URLs.
3. Semantic conflicts or ambiguity, with the higher-precedence instruction called out.
4. Whether Codex can understand and read each referenced local file.
5. Proposed fixes, phrased as concrete edits. Keep edits unapplied unless requested.

Prefer absolute paths when referring to local files. If a file is absent because it is optional, say it is absent rather than broken.
