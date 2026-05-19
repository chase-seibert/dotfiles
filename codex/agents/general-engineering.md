* Prefer not to install dependencies; try implementing light weight versions instead

## Commands
* Create and maintain a Makefile with commands for common operations 
* Specify in the project local AGENTS.md to prefer these commands 

## AGENTS.md Creation
- When creating a project-local AGENTS.md, add project-specific commands, repo map, and references to docs/ files
- Do not copy or summarize context from the user-level AGENTS.md into project-local AGENTS.md files
- Add guidance in the project-local AGENTS.md to also load the user-level AGENTS.md at /Users/cseibert/.codex/AGENTS.md
- Add guidance in the project-local AGENTS.md that common commands should be exposed as Makefile targets, and agents should prefer those targets

## Documentation 
- Keep documentation up to date as you make changes 
- Create a local README.md if it does not exist for human readers with setup, install
- Maintain a CHANGELOG.md in root 
- Create a local AGENTS.md if it does not exist
- Document product requirements in docs/requirements.md in the "As a [type of user],  I want [some goal],  so that [some benefit/value]" format 
- Document architecture in docs/architecture.md 
