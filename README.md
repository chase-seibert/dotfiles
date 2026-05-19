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

The symlink commands use `ln -sf`, so running the script again will refresh the
links.

## Repo Map

- `bashrc`, `bash_profile`: shell setup.
- `gitconfig`, `git-completion.bash`: Git defaults and completion.
- `tmux.conf`: tmux configuration.
- `vimrc`, `vim/`: Vim configuration, syntax files, colors, and bundled
  plugins.
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

## Adding A New Dotfile

1. Create or move the source file into `~/.dotfiles`, usually without the
   leading dot.
2. Add the matching `ln -sf` command to `symlinks.sh`.
3. Run just the new symlink command, or rerun `./symlinks.sh`.
4. Update this README if the file changes setup, install, or maintenance steps.

Example:

```bash
mv ~/.inputrc ~/.dotfiles/inputrc
ln -sf ~/.dotfiles/inputrc ~/.inputrc
```

Then add this line to `symlinks.sh`:

```bash
ln -sf ~/.dotfiles/inputrc ~/.inputrc
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
