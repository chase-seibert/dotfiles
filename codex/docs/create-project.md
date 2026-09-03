# Creating New Projects

Use these instructions when creating or scaffolding a new project.

For Shared Cowork Projects, also load and follow
`/Users/cseibert/.codex/docs/create-shared-cowork-project.md`.

## Baseline Files

- Create new project directories under `/Users/cseibert/projects`.
- Codex projectless/generated work is redirected from `/Users/cseibert/Documents/Codex` to `/Users/cseibert/projects/codex` by symlink; move durable coding projects out to `/Users/cseibert/projects/<project-name>`.
- Create a project-local `AGENTS.md`.
- Create a `README.md` for human readers.
- Create a root `CHANGELOG.md`.
- For coding projects, create a `Makefile` even when the project is small.
- Create a local `docs/` folder for project documentation.

## Project AGENTS.md

The project-local `AGENTS.md` should be specific to the repository.

Include:

- A repo map that names the important directories and files.
- A commands section that points agents to Makefile targets for setup, validation, running, and building.
- A documentation index that links to the files in the local `docs/` folder.
- Guidance to also load the user-level AGENTS file at /Users/cseibert/.codex/AGENTS.md.
- Guidance that common commands should be exposed as Makefile targets, and agents should prefer those targets.

Do not copy or summarize context from the user-level AGENTS file into the project-local `AGENTS.md`.

## Makefile

For coding projects, include targets for the common local workflow where applicable:

- `setup` or `install`
- `format`
- `lint`
- `test`
- `run`
- `build`
- `clean`

Prefer targets that execute real project commands over placeholder targets.

For new iOS SwiftUI projects, follow `/Users/cseibert/.codex/docs/ios-development.md`
and include Makefile targets for both simulator and physical-device workflows.
Include at least:

- `sim-build`
- `sim-launch`
- `phone-build`
- `phone-install`
- `phone-launch`
- `phone-deploy`

Default the physical device to Chase's iPhone 17 Pro. Use the configured Apple
Personal Team for signing, not the default deploy team:

```make
DEVICE_ID ?= 00008150-000E41422E40401C
DEVELOPMENT_TEAM ?= 96NAC4VTEN
```

Physical-device builds must use automatic signing:

- `CODE_SIGN_STYLE=Automatic`
- `DEVELOPMENT_TEAM=$(DEVELOPMENT_TEAM)`
- `-allowProvisioningUpdates`
- `-allowProvisioningDeviceRegistration`

Build physical-device apps with:

```make
-destination 'platform=iOS,id=$(DEVICE_ID)'
```

Install and launch physical-device apps with:

```make
xcrun devicectl device install app --device $(DEVICE_ID) "$(DERIVED_DATA)/Build/Products/Debug-iphoneos/$(APP_NAME).app"
xcrun devicectl device process launch --device $(DEVICE_ID) --terminate-existing $(BUNDLE_ID)
```

## Documentation

Create these docs for new projects:

- `docs/initial-brainstorm.md`: copy the initial prompt/session that started the project.
- `docs/architecture.md`: describe the architecture, major components, data flow, and important tradeoffs.
- `docs/design.md`: include this for projects with UI.
- `docs/product-requirements.md`: document requirements in the form "As a [type of user], I want [some goal], so that [some benefit/value]".
- `docs/setup-install.md`: include this when setup or installation needs detailed steps beyond the README.

Keep documentation up to date as the project changes.

## Changelog

Maintain `CHANGELOG.md` by date.

- Do not create an "Unreleased" section.
- Use dated entries such as `## 2026-05-21`.
- Add new changes under the date they were made.
