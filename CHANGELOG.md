# Changelog

All notable changes to this dotfiles repo are documented here.

This file was bootstrapped from `git log` history. The repository has no version
tags, so historical entries are grouped by calendar year.

Do not add a "Unreleashed" section; just keep a running list by year. 

## 2026

- 2026-09-02: Refreshed Codex settings and domain docs, including app naming,
  transcript corrections, shared cowork projects, native Mac behavior, and
  iOS/macOS persistence and deployment defaults.
- 2026-09-02: Added disk-space cleanup, offline name-game, and personal GitHub
  publishing skills; removed seven untracked work-specific skills locally
  before publishing the remaining changes.
- 2026-09-02: Added Git AI shell/Git integration, GitHub CLI credential
  helpers, and the existing Codex cost report.
- Moved Codex domain instruction files from `codex/agents` to `codex/docs` and
  updated the user-level index, symlink setup, and ignore allowlist.
- Linked the full Codex docs and skills directories into `~/.codex` so new
  user-managed files automatically appear in this repo.
- Made `symlinks.sh` idempotent for destinations that are already linked to
  the expected source.
- Refreshed tracked Codex general engineering instructions from the live
  user-level Codex configuration.
- Added this changelog scaffold.
- Added tracked Codex instructions, config, and user-skill symlinking with
  inline backup-before-link install behavior.
- Updated the merged-branch cleanup helper for Python 3 compatibility.
- Added `CLAUDE.local.md` and linked it into `~/.claude/CLAUDE.local.md`.
- Updated shell profile aliases, including a `python` alias.

## 2025

- Added a `demo` alias for launching independent Chrome instances.
- Updated shell and Git defaults supporting that local workflow.

## 2022

- Refreshed shell, Git, and Vim defaults for newer work-machine setup.
- Updated Bash profile and Bash rc configuration for the latest MacBook Pro.

## 2020

- Adjusted shell profile behavior to avoid the macOS Catalina zsh warning.

## 2019

- Added a tmux daily dashboard script and alias.
- Added a standup helper script.
- Iterated dashboard windows for Git stats, Jira comments, Dropbox teams, and
  team-specific workflows.
- Updated shell paths to prefer Dropbox-provided binaries.
- Refreshed Dropbox-era Bash, Git, and tmux defaults.

## 2018

- Refactored setup from a single installer into explicit platform scripts and
  manual symlink setup.
- Added `symlinks.sh`, `vim.sh`, `mac.sh`, and `linux.sh`.
- Split macOS and Linux package/bootstrap commands.
- Checked in `git-completion.bash`.
- Added SCM Breeze, autojump, and Bash completion setup.
- Updated README install instructions for the new shell-profile flow.
- Removed custom SSH config and updated the public SSH key.
- Cleaned up older work-specific Bash profile settings.

## 2016

- Added `hub` install support.
- Added autojump and Bash completion install support.
- Updated tmux configuration for tmux 2.1.

## 2015

- Added `bin/ngrok`.
- Added public SSH key material.
- Added SCM Breeze integration, new aliases, and a merged-branch cleanup helper.
- Improved tmux behavior, including same-directory windows and macOS support.
- Tuned Vim behavior for Python mode, Rope, completion, linting speed, active
  pane cursor behavior, and search ignores.
- Added shell helpers for AWS, Heroku, and VM workflows.
- Removed checked-in Vim Rope project files.

## 2014

- Created the initial dotfiles repository with README, install script, Bash
  profile, Bash rc, Git config, and Vim config.
- Added full Vim runtime setup, including Pathogen, NERDTree, ctrlp,
  python-mode, Solarized, Markdown support, custom colors, syntax files, and
  indentation files.
- Added tmux configuration.
- Added remote copy/paste helpers and launchd plist files for macOS clipboard
  integration.
- Added early shell aliases, prompt tweaks, `ls` colors, OS-specific install
  handling, and macOS Git completion fixes.
- Tuned Vim clipboard bindings, Python linting/completion, Rope behavior, and
  whitespace cleanup.
