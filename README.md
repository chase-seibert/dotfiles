# Dotfiles

Personal shell, Git, tmux, Vim, and helper-script setup. The basic pattern is:
keep files in this repo without the leading dot, then symlink them into the home
directory.

## Install

Clone the repo into the expected location:

```bash
git clone git@github.com:chase-seibert/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
```

Link the dotfiles:

```bash
./symlinks.sh
```

Set up Vim plugins and Python requirements:

```bash
./vim.sh
```

Run the platform bootstrap script (macOS also loads the remote clipboard helpers):

```bash
./mac.sh
# or
./linux.sh
```

Start Zsh to try the new configuration (exit to return to the current shell):

```sh
zsh
```

To install only Zsh configuration without relinking other dotfiles:

```sh
make link-zsh
```

This backs up any existing `~/.zshrc` and links it to `~/.dotfiles/zshrc`.
It does not change the account's default login shell. Once ready, you can run
`chsh -s /bin/zsh` yourself and open a new terminal.

If continuing to use Bash, reload its profile:

```bash
source ~/.bash_profile
```

## What Gets Linked

`symlinks.sh` links the source files in this repo to their canonical locations:

- `bashrc` to `~/.bashrc`
- `bash_profile` to `~/.bash_profile`
- `zshrc` to `~/.zshrc`
- `git-completion.bash` to `~/.git-completion.bash`
- `gitconfig` to `~/.gitconfig`
- `tmux.conf` to `~/.tmux.conf`
- `vimrc` to `~/.vimrc`
- `vim/` to `~/.vim`
- `CLAUDE.local.md` to `~/.claude/CLAUDE.local.md`
- `codex/AGENTS.md` to `~/.codex/AGENTS.md`
- `codex/config.toml` to `~/.codex/config.toml`
- `codex/docs/` to `~/.codex/docs`
- `codex/skills/` to `~/.codex/skills`

The symlink commands use the `backup_and_link` function in `symlinks.sh`.
Running the script repeatedly is safe: destinations that already point at the
right source are left alone. Existing files, directories, and symlinks that
point somewhere else are moved to timestamped `*.backup.YYYYmmddHHMMSS` paths
before new links are created.

## Repo Map

- `bashrc`, `bash_profile`: existing Bash setup.
- `zshrc`: Zsh setup, migrated aliases, and optional installed integrations.
- `SHELL-AUDIT.md`: migration inventory, recommendations, and rollback steps.
- `gitconfig`, `git-completion.bash`: Git defaults and completion.
- `tmux.conf`: tmux configuration.
- `vimrc`, `vim/`: Vim configuration, syntax files, colors, and bundled
  plugins.
- `codex/`: tracked Codex instructions, config, and user skills.
- `bin/`: personal helper scripts.
- `etc/`: launchd plists for remote clipboard helpers.
- `ssh/`: public SSH material only. Do not put private keys here.
- `symlinks.sh`: creates home-directory symlinks.
- `vim.sh`: installs Vim Python requirements and updates submodules.
- `mac.sh`: macOS package and shell bootstrap.
- `linux.sh`: Linux package and shell bootstrap.
- `autojump.sh`: install or update Autojump; supports macOS without Homebrew.

## Bootstrap Scripts

These scripts are intentionally direct and mutate the local machine. Read them
before running on a fresh host.

- `mac.sh` installs or updates Autojump and loads the existing launchd clipboard
  helpers. Homebrew itself is not installed automatically.
- `linux.sh` refreshes the apt package index and installs the distribution's
  current Autojump package.
- `vim.sh` installs `vim/requirements.txt` with `sudo pip`, then initializes and
  updates Git submodules.

### Package preferences

Install Autojump. Do not install Silver Searcher (`ag`), iTerm2, LibreOffice,
tmux, the `bash-completion` package, OmniFocus, SCM Breeze, Hub, rbenv, or
ruby-build as part of bootstrap.
SCM Breeze is also removed from Bash startup. Existing tmux configuration and
optional `ag` support in Vim can remain for machines where those tools already
exist; bootstrap does not install or uninstall them.

Hub and its `hb` alias are removed. Do not add Ruby version managers or
Ruby build tooling to the dotfiles. Leave the macOS system Ruby in place;
bootstrap does not install or select a Ruby version.

### Autojump

To install only Autojump without loading clipboard services:

```bash
make autojump
# Without make / Xcode Command Line Tools:
bash ./autojump.sh
```

With Homebrew already installed, this refreshes its index and installs or
upgrades Autojump to the current stable formula. Without Homebrew, it uses
Python 3 and the upstream stable source archive, verifies its SHA-256 digest,
and installs into `~/.autojump`. The fallback is pinned to **22.5.3**, the latest
stable release verified on 2026-09-04. Update both the tag and digest in
`autojump.sh` when adopting a newer upstream stable release. Upstream's Python
launcher is adjusted to use `python3` on current macOS.

Both shell profiles load Autojump when present. Open a new terminal, visit
some directories normally, then use `j partial-directory-name` to jump back.
Verify with `autojump --version` and `type j`.

Sources: [Autojump](https://github.com/wting/autojump) and the
[current Homebrew formula](https://formulae.brew.sh/formula/autojump).

## Zsh Configuration

`zshrc` runs for interactive login and non-login shells. It initializes
Homebrew, preserves personal PATH entries, uses native Zsh completion,
and loads autojump when installed. It keeps the personal Git aliases,
colored prompt, terminal-title helper, and Chrome demo function.
No framework or new package is required.

SCM Breeze, work helpers and Dropbox PATH overrides, Ruby manager startup,
PostgreSQL aliases, PHP paths, and the obsolete Heroku path are omitted.
See [the audit](SHELL-AUDIT.md) for the final inventory and migration decisions.
It does not source `.bashrc` or `.bash_profile`. Standalone noninteractive
Zsh processes do not load these settings; scripts should set their own
environment or inherit it from an interactive shell.

After migrating from the earlier configuration, open a new terminal window.
Sourcing the edited file does not remove aliases, functions, or environment
variables that were already loaded. Other inherited PATH entries are preserved;
the Dropbox override directory is filtered out because macOS also adds it
through `/etc/paths`.

History uses `~/.zsh_history` (or `$ZDOTDIR/.zsh_history`), keeps 10,000
entries, appends commands as they run, and ignores immediate duplicates and
commands beginning with a space. Bash history is left in place.

## Codex Files

Codex keeps credentials, sessions, logs, caches, generated media, plugin data,
and worktrees in `~/.codex`. Do not symlink or commit the whole directory.

This repo tracks only the stable Codex dotfiles:

- `codex/AGENTS.md`: user-level instruction index.
- `codex/config.toml`: exact local Codex configuration.
- `codex/docs/`: instruction domain files and stable Codex documentation.
- `codex/skills/`: user-managed skills.

`symlinks.sh` links the full `codex/docs/` directory to `~/.codex/docs`, so
new user documentation files created by Codex appear in this repo automatically.
Codex-managed system skills live in `~/.codex/skills/.system` and are ignored by
Git. `symlinks.sh` links the full `codex/skills/` directory to
`~/.codex/skills`, so new user skill directories created by Codex appear in this
repo automatically.

## Adding A New Dotfile

1. Create or move the source file into `~/.dotfiles`, usually without the
   leading dot.
2. Add the matching `backup_and_link` call to `symlinks.sh`.
3. Rerun `./symlinks.sh`.
4. Update this README if the file changes setup, install, or maintenance steps.

Example:

```bash
mv ~/.inputrc ~/.dotfiles/inputrc
```

Then add this line to `symlinks.sh`:

```bash
backup_and_link "$dotfiles_dir/inputrc" "$HOME/.inputrc"
```

## Maintenance

Useful checks after editing:

```bash
make check
python3 -m py_compile bin/*.py
```

Use Git submodule commands when working with Vim bundles:

```bash
git submodule status
git submodule update --init
```

Keep secrets out of the repo. Public keys are fine, private keys, tokens,
machine-specific credentials, and generated local state are not.
