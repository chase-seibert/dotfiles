* Prefer not to install dependencies; try implementing light weight versions instead

## Skill Creation
- When creating or validating Codex skills, do not assume PyYAML is installed; use lightweight, standard-library validation for the limited frontmatter shape skills need.

## Commands
* Create and maintain a Makefile with commands for common operations
* Specify in the project-local AGENTS.md to prefer these commands

## New Projects
* When creating or scaffolding a new project, load and follow `/Users/cseibert/.codex/docs/create-project.md`

## AGENTS.md Creation
- Do not copy or summarize context from the user-level AGENTS.md into project-local AGENTS.md files
- Add guidance in the project-local AGENTS.md to also load the user-level AGENTS.md at /Users/cseibert/.codex/AGENTS.md
- Add guidance in the project-local AGENTS.md that common commands should be exposed as Makefile targets, and agents should prefer those targets

## Documentation 
- Keep documentation up to date as you make changes
- For new projects, follow the new-project instructions
- Do not create an "Unreleased" section in CHANGELOG.md
- Create a local AGENTS.md if it does not exist
