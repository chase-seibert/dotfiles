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

Run the platform bootstrap script to install stuff:

```bash
./mac.sh
# or
./linux.sh
```

Reload the shell profile:

```bash
source ~/.bash_profile
```

## What Gets Linked

`symlinks.sh` links the source files in this repo to their canonical locations:

- `bashrc` to `~/.bashrc`
- `bash_profile` to `~/.bash_profile`
- `git-completion.bash` to `~/.git-completion.bash`
- `gitconfig` to `~/.gitconfig`
- `tmux.conf` to `~/.tmux.conf`
- `vimrc` to `~/.vimrc`
- `vim/` to `~/.vim`
- `CLAUDE.local.md` to `~/.claude/CLAUDE.local.md`
- `codex/AGENTS.md` to `~/.codex/AGENTS.md`
- `codex/config.toml` to `~/.codex/config.toml`
- `codex/agents/*.md` to matching files under `~/.codex/agents/`
- user skill directories in `codex/skills/` to matching directories under
  `~/.codex/skills/`

The symlink commands use the `backup_and_link` function in `symlinks.sh`.
Running the script repeatedly is safe: destinations that already point at the
right source are left alone. Existing files, directories, and symlinks that
point somewhere else are moved to timestamped `*.backup.YYYYmmddHHMMSS` paths
before new links are created.

## Repo Map

- `bashrc`, `bash_profile`: shell setup.
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

## Bootstrap Scripts

These scripts are intentionally direct and mutate the local machine. Read them
before running on a fresh host.

- `mac.sh` installs Homebrew, packages, casks, Ruby via `rbenv`, launchd
  clipboard helpers, and `scm_breeze`.
- `linux.sh` installs packages with `apt-get` and installs `scm_breeze`.
- `vim.sh` installs `vim/requirements.txt` with `sudo pip`, then initializes and
  updates Git submodules.

Some package names are historical, especially in `mac.sh`, so Homebrew commands
may need cleanup on a modern machine.

## Codex Files

Codex keeps credentials, sessions, logs, caches, generated media, plugin data,
and worktrees in `~/.codex`. Do not symlink or commit the whole directory.

This repo tracks only the stable Codex dotfiles:

- `codex/AGENTS.md`: user-level instruction index.
- `codex/agents/`: instruction domain files referenced by `AGENTS.md`.
- `codex/config.toml`: exact local Codex configuration.
- `codex/skills/`: user-managed skills.

Codex-managed system skills live in `~/.codex/skills/.system` and are not
managed here. `symlinks.sh` automatically links every non-hidden entry in
`codex/skills/`, so adding a new user skill directory does not require editing
the installer.

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
bash -n symlinks.sh mac.sh linux.sh vim.sh
python3 -m py_compile bin/*.py
```

Use Git submodule commands when working with Vim bundles:

```bash
git submodule status
git submodule update --init
```

Keep secrets out of the repo. Public keys are fine, private keys, tokens,
machine-specific credentials, and generated local state are not.
