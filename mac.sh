#!/usr/bin/env bash
set -euo pipefail

dotfiles_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
bash "$dotfiles_dir/autojump.sh"

# Keep the existing remote clipboard setup.
launchctl load ~/.dotfiles/etc/pbcopy.plist
launchctl load ~/.dotfiles/etc/pbpaste.plist
