# Repository Instructions

## Project Overview

This repository contains personal dotfiles and bootstrap scripts. Files are
stored in the repo without a leading dot where possible, then linked into the
home directory by `symlinks.sh`.

## Repo Map

- `README.md`: human install and "adding files" workflow.
- `symlinks.sh`: canonical symlink setup for home-directory dotfiles.
- `mac.sh`, `linux.sh`: platform bootstrap scripts that install packages and
  shell integrations.
- `vim.sh`: Vim dependency and submodule setup.
- `bashrc`, `bash_profile`, `gitconfig`, `tmux.conf`, `vimrc`: dotfile source
  files linked into the home directory.
- `bin/`: helper scripts intended to be on the user's path.
- `etc/`: launchd plist files used by the remote clipboard helpers.
- `vim/`: Vim runtime files and bundled plugins.
- `ssh/`: public SSH material only. Do not add private keys.
- `CLAUDE.local.md`: local Claude instructions linked to
  `~/.claude/CLAUDE.local.md`.

## Commands

- Install symlinks: `./symlinks.sh`
- Set up Vim dependencies and submodules: `./vim.sh`
- Run macOS bootstrap: `./mac.sh`
- Run Linux bootstrap: `./linux.sh`
- Check shell scripts before editing completes: `bash -n symlinks.sh mac.sh linux.sh vim.sh`
- Check Python helpers after editing: `python3 -m py_compile bin/*.py`

## Editing Guidelines

- Be careful with commands that mutate the user's home directory, install
  packages, load launchd jobs, or clone external repositories. Explain before
  running bootstrap scripts.
- Preserve the symlink model. When adding a new dotfile, store it in this repo
  without the leading dot when practical, update `symlinks.sh`, and update
  `README.md`.
- Prefer lightweight changes over adding new dependencies.
- Keep private material out of the repo. `ssh/id_rsa.pub` is public; private
  keys and secrets do not belong here.
- Treat vendored Vim bundles as third-party code unless the task specifically
  asks to change them.

## Documentation

- Keep `README.md` current when setup, install, or dotfile linking behavior
  changes.
- Update or create `CHANGELOG.md` for notable user-visible changes.
