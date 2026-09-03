# Creating Shared Cowork Projects

Use these instructions when creating or evolving a Shared Cowork Project.

A Shared Cowork Project is a Dropbox-shared, Git-versioned project folder for
collaborative initiative work. It gathers the project instructions, reusable
assets, local memory, task tracking, scripts, skills, automations, and produced
reports in one place so multiple collaborators can run agent sessions against
the same working context.

These projects are intended to be shared through Dropbox, not deployed. Git is
for local version tracking, review, and fast rollback. Do not assume the Git
repository will be pushed to a remote unless the project explicitly says so.
Reports and artifacts should be written in formats that render well in Dropbox
browser previews, such as Markdown, HTML, PDF, CSV, and common office formats.

## Creation Flow

Before scaffolding the project, ask the user these questions and capture the
answers in `docs/project-charter.md`:

- What is the ultimate goal of this project?
- What context do you already have about the initiative?
- What links, documents, datasets, notes, meetings, Slack threads, emails, Jira
  issues, Confluence pages, or other assets might be relevant?
- How can the agent go find out more information on its own?
- Who else is involved in the project, and what roles do they play?
- What questions should this project ultimately answer?
- What specific deliverables do you expect from this project?

If the user has only partial answers, scaffold the project anyway and mark the
unknowns in `docs/project-charter.md`.

## Required Root Layout

Create this required root layout:

```text
docs/
scripts/
reports/
memory/
tasks/
skills/
.codex/
README.md
CHANGELOG.md
AGENTS.md
```

Do not rename these required directories or top-level files.

Use `docs/` for durable project documentation, `scripts/` for reusable helper
logic, `reports/` for generated deliverables, `memory/` for reusable session
memory and cached remote sources, `tasks/` for the local task index, and
`skills/` for agent-neutral project skills.

Create `.codex/skills/` as the Codex-specific harness. Each entry in
`.codex/skills/` should be a symlink back to the corresponding entry in the
root `skills/` directory. For example:

```text
.codex/skills/<skill-name> -> ../../skills/<skill-name>
```

The root `skills/` directory is the source of truth. Do not copy skill content
into `.codex/skills/`.

## Required Files

Create these required root files:

- `README.md`
- `CHANGELOG.md`
- `AGENTS.md`

Create these exact required files in `docs/`:

- `docs/project-charter.md`
- `docs/task-delegation.md`
- `docs/automations.md`
- `docs/create-shared-cowork-project.md`
- `docs/sources.md`
- `docs/decisions.md`
- `docs/deliverables.md`

Create these required non-doc Markdown files:

- `memory/AGENTS.md`
- `tasks/tasks.md`

Every project starts with these files. Add extra documentation only when there
is a durable need, and link it from `README.md` and `AGENTS.md`.

## README.md

Write `README.md` for human collaborators. It should include:

- The project purpose and current owner.
- Setup instructions for opening the Dropbox-shared folder and starting an
  agent session from the project root.
- A short explanation that Git is for local version tracking and rollback, not
  deployment or remote publishing unless the project opts in.
- Dropbox sharing expectations, including where human-readable reports and
  artifacts are written.
- How collaborators should orient themselves: read `AGENTS.md`, then
  `docs/project-charter.md`, `tasks/tasks.md`, `docs/deliverables.md`, and
  `memory/AGENTS.md`.
- Common commands, including Makefile targets if the project has a `Makefile`,
  and script entrypoints from `scripts/` when there is no Makefile.
- Where to find project docs, reports, task status, memory, scripts, and skills.
- How to request a new deliverable or update an existing one.

Keep the README brief enough that a new collaborator can skim it before running
their first session.

## CHANGELOG.md

Maintain `CHANGELOG.md` by date.

- Do not create an "Unreleased" section.
- Use dated entries such as `## 2026-06-26`.
- Log meaningful changes to structure, instructions, scripts, automations,
  reports, deliverables, and task workflows.

## AGENTS.md

Write the root `AGENTS.md` for agents working inside the project. It should be
specific to this project and should not copy or summarize the user-level
`/Users/cseibert/.codex/AGENTS.md`.

Include:

- A short instruction to also load `/Users/cseibert/.codex/AGENTS.md`.
- A repo map for `docs/`, `scripts/`, `reports/`, `memory/`, `tasks/`,
  `skills/`, and `.codex/`.
- A documentation index naming every required file in `docs/`.
- A project state section pointing to `docs/project-charter.md`,
  `docs/decisions.md`, `docs/sources.md`, `docs/deliverables.md`, and
  `tasks/tasks.md`.
- A commands section that tells agents to prefer Makefile targets when a
  `Makefile` exists, otherwise prefer documented scripts in `scripts/`.
- A skills section explaining that root `skills/` is agent-neutral and
  `.codex/skills/` contains symlinks for Codex discovery.
- A memory section telling agents to read `memory/AGENTS.md` before reusing or
  adding cached sources.
- A task section telling agents to update `tasks/tasks.md` whenever they create,
  sync, or follow up on delegated work.
- An automation section telling agents to read `docs/automations.md` before
  creating, running, or modifying project automations.
- A reporting section telling agents to write shareable outputs to `reports/`
  in Dropbox-preview-friendly formats.

## docs/project-charter.md

Use `docs/project-charter.md` as the canonical project brief. Include:

- Project goal.
- Current initiative context.
- Known constraints and non-goals.
- People involved, with roles and relevant teams.
- Source systems and places the agent can investigate independently.
- Links or documents supplied by the user.
- Questions the project should answer.
- Expected deliverables.
- Current status and next recommended session.

Update this file when the project goal, scope, stakeholders, or expected
deliverables change.

## docs/task-delegation.md

Use `docs/task-delegation.md` to define how this project assigns work to other
people and follows up on it.

Include:

- The Jira projects used by the local teams involved in the initiative.
- The managers and engineers who may receive tasks.
- The rule that Jira issues should be filed in the assignee team's local Jira
  project whenever possible.
- The rule that each issue should be assigned to the engineer or manager doing
  the work.
- The rule that when an issue is assigned to an engineer, the engineer's manager
  should be CC'd or otherwise notified so they are aware of the request.
- The expected follow-up cadence.
- The Jira issue template or required fields for task requests.
- The local task index schema used in `tasks/tasks.md`.

Do not rely on Jira alone as the project memory. Keep `tasks/tasks.md` updated
with the project-local view of delegated work.

## docs/automations.md

Use `docs/automations.md` as the source of truth for project automations.

Include:

- The current automation runner: the specific person responsible for running
  the project's automations.
- Setup instructions for running automations in the local agent harness.
- Any cron or crontab setup only when the project explicitly needs it.
- The rule that the local agent harness is preferred over cron for project
  automations.
- The rule that every automation must check at startup whether the current user
  is the configured automation runner.
- The rule that an automation must exit gracefully without side effects when the
  current user is not the configured automation runner.
- A table of automations with name, purpose, owner, runner, schedule or trigger,
  command, inputs, outputs, last run, and notes.

Automations should write their outputs to predictable paths in `reports/`,
`memory/`, or `tasks/`, and should log meaningful status in `CHANGELOG.md` only
when they change durable project state or generate important deliverables.

## docs/create-shared-cowork-project.md

Copy the user-level guide from
`/Users/cseibert/.codex/docs/create-shared-cowork-project.md` into
`docs/create-shared-cowork-project.md` when creating a new Shared Cowork
Project.

This project-local copy is allowed to evolve as the project discovers better
practices. When updating it:

- Keep a changelog at the bottom of the file.
- Prefer concrete practices learned from the project over broad theory.
- Note whether the change should be promoted back to the user-level guide.
- When asked to update the user-level guide, compare the local copy against
  `/Users/cseibert/.codex/docs/create-shared-cowork-project.md` and propose or
  apply the useful reusable changes.

## docs/sources.md

Use `docs/sources.md` for durable source-of-truth references, not cached copies.

Include:

- Canonical links to source systems such as Jira, Confluence, Slack, Google
  Drive, Dropbox, email threads, dashboards, spreadsheets, and meeting notes.
- A short description of why each source matters.
- Source owner or source system.
- Known access requirements.
- Expected freshness or update cadence.

When an agent pulls content from a source for reuse, it should add the cached
copy or shortcut to `memory/` and update `memory/AGENTS.md`.

## docs/decisions.md

Use `docs/decisions.md` as the durable decision log.

Record dated decisions with:

- Date.
- Decision.
- Context.
- Owner or decision maker.
- Alternatives considered when useful.
- Consequences or follow-up work.

Keep this file concise. It should help future sessions understand why the
project moved in a particular direction.

## docs/deliverables.md

Use `docs/deliverables.md` to track expected and produced outputs.

Include:

- Deliverable name.
- Audience.
- Owner.
- Status.
- Due date or target date when known.
- Output path in `reports/`.
- Dropbox share link or source link when available.
- Notes about format, review state, and follow-up work.

Write final reports and artifacts to `reports/` in formats that render well in
Dropbox browser previews.

## memory/AGENTS.md

Use `memory/AGENTS.md` as the agent-discoverable index and operating guide for
project memory.

It should explain that `memory/` stores:

- Web shortcuts to remote sources.
- Local flat-file copies or extracts of remote material pulled during sessions.
- Notes about capture date, source, owner, freshness, and staleness.

Use a table with these columns for memory entries:

```markdown
| ID | Title | Source | Local copy or shortcut | Captured | Freshness | Owner or system | Notes |
| --- | --- | --- | --- | --- | --- | --- | --- |
```

Rules:

- Add a memory entry when remote content is likely to be reused and is not
  already captured.
- Prefer Markdown or plain text extracts for agent readability.
- Include the original source URL or path whenever possible.
- Mark when the cached copy should be considered stale.
- Re-check the remote source before using cached material for high-stakes,
  time-sensitive, or externally visible work.
- Do not store secrets, credentials, or unnecessary personal data in `memory/`.

## tasks/tasks.md

Use `tasks/tasks.md` as the project-local index of delegated work.

Start with this table:

```markdown
| ID | Jira | Title | Assignee | Manager CC | Local team or project | Status | Requested | Due | Last synced | Next follow-up | Notes |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
```

Suggested status values:

- `proposed`
- `filed`
- `in-progress`
- `blocked`
- `done`
- `canceled`

Update `tasks/tasks.md` when:

- A task is proposed.
- A Jira issue is filed.
- The assignee, manager, due date, or scope changes.
- The agent checks Jira status.
- The agent follows up with the assignee or manager.
- The task is completed, canceled, or blocked.

The Jira issue remains the source of truth for the assigned task, but
`tasks/tasks.md` is the project-local index that helps future sessions quickly
understand what has been delegated and what still needs follow-up.

## skills/

Use root `skills/` for project-specific reusable skills that any agent can
discover.

Each skill should be a directory under `skills/` with a clear name. Include a
`README.md` for agent-neutral instructions. If the skill should be usable by
Codex as a Codex skill, include the Codex-compatible files inside the same
skill directory and symlink that directory from `.codex/skills/`.

Rules:

- Keep root `skills/` as the source of truth.
- Do not put unique skill content only under `.codex/skills/`.
- Prefer symlinks from `.codex/skills/` to `../../skills/<skill-name>`.
- Document project skills in the root `AGENTS.md`.

## scripts/

Use `scripts/` for reusable project logic.

Scripts should:

- Be documented in `README.md` or `AGENTS.md`.
- Prefer dry-run or preview modes when they make sense.
- Avoid hidden side effects.
- Write durable outputs to `reports/`, `memory/`, or `tasks/`.
- Avoid hardcoding a single collaborator's local paths unless the project docs
  explain why.

If the project has repeatable commands, create a `Makefile` with real targets
and document those targets in `README.md` and `AGENTS.md`. Do not create
placeholder targets.

## reports/

Use `reports/` for generated artifacts intended to be shared or reviewed.

Prefer filenames that begin with an ISO date and a short slug, such as:

```text
2026-06-26-executive-summary.md
2026-06-26-risk-review.html
2026-06-26-task-status.pdf
```

Reports should be readable from Dropbox browser previews whenever possible.
Track expected and completed reports in `docs/deliverables.md`.

## Jira Delegation

When assigning tasks to other managers or engineers:

- Prefer filing a Jira issue.
- File the issue in the Jira project for the assignee's local team whenever
  possible.
- Assign the issue to the person expected to do the work.
- If the assignee is an engineer, CC or otherwise notify that engineer's manager.
- Add the Jira issue to `tasks/tasks.md`.
- Sync `tasks/tasks.md` when checking status or following up.
- Pull back useful completion context into the project docs, reports, memory, or
  decision log as appropriate.

If Jira is not available or not appropriate, record the task in `tasks/tasks.md`
with the external tracking location or communication thread.

## Local Evolution

Each Shared Cowork Project starts with a local copy of this guide at
`docs/create-shared-cowork-project.md`.

As the project discovers better reusable practices, update the local copy first.
Add a changelog entry at the bottom of the local copy for each meaningful
change. When the local practice appears reusable across projects, ask an agent
to update the user-level guide at
`/Users/cseibert/.codex/docs/create-shared-cowork-project.md` with the local
best practices.

## Guide Changelog

## 2026-06-26

- Created the initial Shared Cowork Project guide.
