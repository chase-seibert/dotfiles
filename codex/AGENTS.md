## Domain Files

These are user-level files outside the active project. Do not look for an
agents directory relative to the active project. Use the absolute paths exactly
as written.

- General engineering defaults: `/Users/cseibert/.codex/agents/general-engineering.md`
- macOS app development: `/Users/cseibert/.codex/agents/macos-development.md`
- iOS app development: `/Users/cseibert/.codex/agents/ios-development.md`
- Work and collaboration: `/Users/cseibert/.codex/agents/work.md`

## How To Use This Index

1. Start with the current task and repository instructions.
2. Load the absolute-path domain files above that match the task.
3. If a subfile conflicts with a project-local instruction, load both.
4. If an absolute-path domain file cannot be read, continue without blocking. Do
   not report that a local `agents/` directory is missing.
