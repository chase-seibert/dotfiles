# Shell configuration notes

- 2026-09-04: On a fresh Mac, `make` invokes the Xcode developer-tools install
  prompt. Until those tools exist, run shell checks in a loop and invoke the
  requested installer directly with Bash. Autojump publishes stable tags but
  its GitHub latest-release API returns 404; use the verified stable tag and
  checksum. Its upstream executable requests `python`, so the source fallback
  explicitly uses `python3`.
- 2026-09-04: Removed the legacy `bashrc` self-source noted below. Also replaced
  unconditional Homebrew/chruby startup and removed SCM Breeze integration.
- 2026-09-02: The legacy `bashrc` sources its own `~/.bashrc` symlink. Do not
  run it to audit startup behavior; inspect it statically. Validate the migrated
  Zsh config in fresh processes with a temporary `ZDOTDIR` so completion caches
  and test history stay separate from the user's state.
- 2026-09-02: Removing the Dropbox override PATH addition from `zshrc` did not
  remove it in login shells: `/etc/paths` also adds `/opt/dropbox-override/bin`.
  Filter that entry after Homebrew initialization, and check login as well as
  non-login startup when verifying PATH removals.
