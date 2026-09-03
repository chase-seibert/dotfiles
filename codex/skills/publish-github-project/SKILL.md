---
name: publish-github-project
description: Publish a local project to the user's personal GitHub account. Use when the user wants to put a local folder or existing Git repository on GitHub, create and push a personal GitHub repository, add an optional README screenshot before publishing, or initialize and publish a non-Git project.
---

# Publish GitHub Project

Use the `gh` CLI, not the GitHub app/plugin, because this workflow must publish through the user's personal GitHub authentication.

## Guardrails

- Work only in the user-specified project directory. Default the repository name to its basename; accept an explicit override.
- Before proposing any write, run `gh auth status` and `gh api user --jq .login`. Report the authenticated GitHub login and use it as `OWNER`.
- If `gh auth status` shows multiple GitHub.com accounts, identify the active account. Ask before changing it with `gh auth switch --hostname github.com --user OWNER`, then rerun both identity checks. Do not assume the Codex GitHub integration can select the needed account.
- Create repositories only as `OWNER/REPO`. Never create under an organization or another account, even if a local remote suggests one. If the expected personal account is unclear or the logged-in account is not the one the user intends, stop and ask for direction.
- Default new repositories to public. Ask before using private visibility.
- Treat `git init`, staging, commits, repository creation, README edits, and pushes as external or persistent changes. Summarize the exact changes and obtain the user's confirmation immediately before making them.
- Never force-push, overwrite or replace an existing remote, or publish unreviewed secrets. Adding `origin` as part of creating the new personal repository is allowed; for an existing `origin`, verify that its GitHub owner equals `OWNER`, otherwise stop and explain the mismatch.

## Inspect and prepare

1. Inspect the directory, `git status --short --branch`, `git remote -v`, the current branch, and existing README files. Do not alter anything yet.
2. Inspect potentially staged or proposed files for obvious credentials and private local configuration. Respect `.gitignore`; call out anything that should be excluded before staging.
3. Check whether the README already renders a project screenshot (an image reference) and whether common image assets exist. If there is no README screenshot, ask whether the user wants to attach or name a local screenshot before publishing. This is optional: proceed without one only after they decline or explicitly ask to continue.

### Adding a screenshot

When the user provides a screenshot:

1. Copy it into `docs/images/` in the project, creating that directory if needed. Preserve the supplied filename unless it would collide; do not move or delete the original.
2. Add a Markdown image reference using a repository-relative path to the README. Put it near the top, below the introductory description when one exists.
3. If no README exists, ask whether to create a minimal one with the project name and screenshot; do not invent a detailed project description.
4. Show the README diff and include the copied image in the next commit.

## Publish workflow

### Existing Git repository without a remote

1. Determine the current branch. If there is no commit or branch, follow the non-Git preparation flow below.
2. Review uncommitted changes. If needed, show the planned commit summary and ask whether to stage and commit them. Do not silently include unrelated changes.
3. After confirmation, create and push the personal repository:

   ```bash
   gh repo create OWNER/REPO --public --source=. --remote=origin --push
   ```

   Substitute the verified login and chosen repository name. Use `--private` only when the user explicitly selected private visibility.

### Existing Git repository with an `origin`

1. Confirm `origin` targets `github.com/OWNER/REPO` (SSH or HTTPS) and that the branch and any pending commits are the intended ones.
2. If the remote does not match the verified personal login, stop; do not replace or push to it.
3. After confirmation, push only the current branch:

   ```bash
   git push -u origin "$(git branch --show-current)"
   ```

### Non-Git directory

1. Explain that publishing will initialize Git, stage the reviewed project files, create an initial commit, create `OWNER/REPO`, and push it. Obtain confirmation.
2. Initialize Git and create a `main` branch. Add a `.gitignore` only if the project clearly needs one and the proposed contents are shown to the user first.
3. Stage the reviewed files, show `git diff --cached --stat` and the concise commit message (normally `Initial commit`), then commit.
4. Create and push using `gh repo create OWNER/REPO --public --source=. --remote=origin --push`. Use `--private` only when the user explicitly selected private visibility.

## Verify and report

After publishing, verify `git remote -v`, `git branch -vv`, and `gh repo view OWNER/REPO --json nameWithOwner,url,visibility`. Report the repository URL, visibility, branch, and whether a README screenshot was added.
