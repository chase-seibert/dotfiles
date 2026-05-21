## Domain Files

These are user-level files outside the active project. Do not look for a
domain-file directory relative to the active project. Use the absolute paths
exactly as written.

- General engineering defaults: `/Users/cseibert/.codex/docs/general-engineering.md`
- macOS app development: `/Users/cseibert/.codex/docs/macos-development.md`
- iOS app development: `/Users/cseibert/.codex/docs/ios-development.md`
- Work and collaboration: `/Users/cseibert/.codex/docs/work.md`

## How To Use This Index

1. Start with the current task and repository instructions.
2. Load the absolute-path domain files above that match the task.
3. If a subfile conflicts with a project-local instruction, load both.
4. If an absolute-path domain file cannot be read, continue without blocking. Do
   not report that a local domain-file directory is missing.
