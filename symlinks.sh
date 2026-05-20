#!/usr/bin/env bash
set -euo pipefail

dotfiles_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

backup_and_link() {
  local source_path=$1
  local destination_path=$2
  local destination_parent
  local existing_target
  local timestamp
  local backup_path
  local counter

  if [ ! -e "$source_path" ]; then
    echo "Source does not exist: $source_path" >&2
    exit 66
  fi

  destination_parent=$(dirname "$destination_path")
  mkdir -p "$destination_parent"

  if [ -L "$destination_path" ]; then
    existing_target=$(readlink "$destination_path")

    if [ "$existing_target" = "$source_path" ]; then
      return
    fi
  fi

  if [ -L "$destination_path" ] || [ -e "$destination_path" ]; then
    timestamp=$(date +%Y%m%d%H%M%S)
    backup_path="${destination_path}.backup.${timestamp}"
    counter=1

    while [ -e "$backup_path" ] || [ -L "$backup_path" ]; do
      backup_path="${destination_path}.backup.${timestamp}.${counter}"
      counter=$((counter + 1))
    done

    mv "$destination_path" "$backup_path"
    echo "Backed up $destination_path to $backup_path"
  fi

  ln -s "$source_path" "$destination_path"
}

backup_and_link "$dotfiles_dir/bashrc" "$HOME/.bashrc"
backup_and_link "$dotfiles_dir/bash_profile" "$HOME/.bash_profile"
backup_and_link "$dotfiles_dir/git-completion.bash" "$HOME/.git-completion.bash"
backup_and_link "$dotfiles_dir/gitconfig" "$HOME/.gitconfig"
backup_and_link "$dotfiles_dir/tmux.conf" "$HOME/.tmux.conf"
backup_and_link "$dotfiles_dir/vimrc" "$HOME/.vimrc"
backup_and_link "$dotfiles_dir/vim" "$HOME/.vim"
backup_and_link "$dotfiles_dir/CLAUDE.local.md" "$HOME/.claude/CLAUDE.local.md"

backup_and_link "$dotfiles_dir/codex/AGENTS.md" "$HOME/.codex/AGENTS.md"
backup_and_link "$dotfiles_dir/codex/config.toml" "$HOME/.codex/config.toml"

backup_and_link "$dotfiles_dir/codex/agents" "$HOME/.codex/agents"
backup_and_link "$dotfiles_dir/codex/skills" "$HOME/.codex/skills"
