# Shell configuration notes

- 2026-09-02: The legacy `bashrc` sources its own `~/.bashrc` symlink. Do not
  run it to audit startup behavior; inspect it statically. Validate the migrated
  Zsh config in fresh processes with a temporary `ZDOTDIR` so completion caches
  and test history stay separate from the user's state.
- 2026-09-02: Removing the Dropbox override PATH addition from `zshrc` did not
  remove it in login shells: `/etc/paths` also adds `/opt/dropbox-override/bin`.
  Filter that entry after Homebrew initialization, and check login as well as
  non-login startup when verifying PATH removals.
