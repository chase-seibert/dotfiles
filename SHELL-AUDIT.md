# Bash to Zsh audit

Audited September 2, 2026. Updated with your final choices: keep autojump;
omit SCM Breeze, work helpers, Ruby startup, PostgreSQL aliases, and PHP setup.

The configuration lives in `~/.dotfiles/zshrc`, linked from `~/.zshrc`.
Your original local Zsh file is preserved as
`~/.zshrc.backup.20260902203147`. Bash files and existing history are unchanged.

## Final configuration

| Area | Kept in Zsh |
| --- | --- |
| Everyday helpers | `g` for recursive grep, `ll`, `tmux -u`, `python=python3`, and `EDITOR=vi`, with Bash-style keyboard editing. |
| Git aliases | `gfo`, `gb`, `ga`, `gco`, `gs`, `gd`, `gc`, `gps`, `gf`, and `hb` (`hub browse`). Git is no longer wrapped by SCM Breeze. |
| PATH | Homebrew, existing `/usr/local/bin`, `/usr/local/sbin`, `.local/bin`, `.dotfiles/bin`, and `.git-ai/bin`; duplicate entries are removed. |
| Prompt and colors | Yellow user/host, red current directory, and macOS `ls` colors. Linux uses `ls --color=auto`. |
| Completion | Native Zsh completion, including installed Homebrew completions. |
| Navigation | autojump's installed Zsh integration, including `j`. |
| Chrome demo | `demo` creates a fresh temporary Chrome profile only when invoked and accepts extra arguments. |
| Terminal title | `name` uses quoted `printf` to handle spaces and backslashes predictably. |
| History | Saves 10,000 commands, appends as commands run, and skips immediate duplicates and commands beginning with a space. |

## Omitted

- SCM Breeze loading, numbered Git shortcuts, and its command wrappers.
- `dev` / `$USER-dbx` and `/opt/dropbox-override/bin`. The latter is also
  filtered out after Homebrew initialization because `/etc/paths` adds it.
- Both rbenv initialization and chruby loading/Ruby 3.1.2 selection.
- PostgreSQL `start-pg` and `stop-pg` aliases.
- The PHP 7.4 PATH entry and all PHP-specific setup.
- The obsolete `/usr/local/heroku/bin` path, which was absent on this Mac.
- Bash completion scripts, Bash prompt escapes, and the Bash deprecation-warning
  setting.
- The Linux SSH-agent socket symlink workaround. Zsh inherits `SSH_AUTH_SOCK`.

These are configuration removals. Installed packages, Ruby installations,
database files, and the original Bash setup were not removed or changed.

## Fixes and remaining notes

The old `bashrc` sources `~/.bashrc`, whose symlink points back to itself;
interactive Bash that reads it can recurse indefinitely. The Bash login profile
also does not source that rc file, so its startup paths receive different
settings. The Zsh configuration does not source either Bash file.

The original `demo` alias evaluated `mktemp` while defining the alias, creating
a directory at startup and reusing it within that shell. The new function
creates one directory per invocation. Those profiles remain in the OS temporary
directory after Chrome closes.

Keep the remaining helpers if you use them. The `tmux` alias is retained, but
tmux was not on PATH during the audit. `hub` was installed and remains available
through `hb`. No additional framework or dependency is needed for this setup.

Native completion uses `compinit -i`, which ignores insecure completion
directories. The installed completion audit passed. See the
[Zsh completion documentation](https://zsh.sourceforge.io/Doc/Release/Completion-System.html).

## Activation and validation

Open a new terminal window after this change. Sourcing the edited file cannot
remove functions or aliases already loaded by the old configuration, and a
child shell inherits its parent's PATH and exported variables. The new config
does not add the omitted paths; it also filters the Dropbox override directory
out of the inherited PATH. Other inherited PATH entries are preserved.

Your macOS account already specifies `/bin/zsh`. If a terminal still opens
Bash, check its profile's startup command. No account or terminal setting was
changed here.

Zsh loads `.zshrc` for interactive login and non-login shells. Standalone
noninteractive scripts do not load it; set their environment explicitly or
inherit it from an interactive shell. See
[Zsh startup files](https://zsh.sourceforge.io/Doc/Release/Files.html).

Validation covers shell syntax, clean-environment login/non-login startup,
autojump and Git completion, removal of the requested functions/aliases/PATH
additions, reloads without duplicate paths/hooks, and the home-directory link.
Linux was not exercised. No database service, SSH connection, or Chrome window
was launched.

To roll back to the original local Zsh config, remove only the `~/.zshrc`
symlink and move `~/.zshrc.backup.20260902203147` back to `~/.zshrc`. Then open
a new terminal window. The tracked config can remain for later use.
