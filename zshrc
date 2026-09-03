# Interactive shell configuration. Do not source Bash startup files here.
[[ -o interactive ]] || return

# Zsh's tied arrays keep PATH and completion paths free of duplicates.
typeset -U path fpath

# Support Apple Silicon, Intel macOS, and Homebrew on Linux.
for _dotfiles_brew in /opt/homebrew/bin/brew /usr/local/bin/brew /home/linuxbrew/.linuxbrew/bin/brew "${commands[brew]}"; do
  if [[ -x $_dotfiles_brew ]]; then
    eval "$("$_dotfiles_brew" shellenv zsh)"
    break
  fi
done

# macOS /etc/paths also adds this override; exclude it from Zsh's PATH.
path=("${(@)path:#/opt/dropbox-override/bin}")

# Preserve personal executable paths when present.
_dotfiles_prepend=()
for _dotfiles_dir in \
  "$HOME/.git-ai/bin" "$HOME/.local/bin" /usr/local/sbin /usr/local/bin; do
  [[ -d $_dotfiles_dir ]] && _dotfiles_prepend+=("$_dotfiles_dir")
done
path=("${_dotfiles_prepend[@]}" "${path[@]}")
[[ -d $HOME/.dotfiles/bin ]] && path+=("$HOME/.dotfiles/bin")
export PATH

if [[ $OSTYPE == darwin* ]]; then
  export CLICOLOR=1
  export LSCOLORS=gxBxhxDxfxhxhxhxhxcxcx
elif [[ $OSTYPE == linux* ]]; then
  alias ls='ls --color=auto'
fi

export EDITOR=vi
# Keep familiar Bash-style editing even when EDITOR is vi.
bindkey -e
HISTFILE=${ZDOTDIR:-$HOME}/.zsh_history
HISTSIZE=20000
SAVEHIST=10000
setopt APPEND_HISTORY INC_APPEND_HISTORY EXTENDED_HISTORY HIST_IGNORE_DUPS HIST_IGNORE_SPACE

# Autoload the native Zsh completion system, including Homebrew completions.
if [[ -n $HOMEBREW_PREFIX && -d $HOMEBREW_PREFIX/share/zsh/site-functions ]]; then
  fpath=("$HOMEBREW_PREFIX/share/zsh/site-functions" "${fpath[@]}")
fi
autoload -Uz compinit
# Ignore insecure completion directories instead of prompting or trusting them.
compinit -i

# Keep autojump, using its Zsh implementation instead of the Bash script.
if (( ! $+functions[autojump_chpwd] )); then
  for _dotfiles_script in \
    "$HOME/.autojump/share/autojump/autojump.zsh" \
    "${HOMEBREW_PREFIX:-/opt/homebrew}/share/autojump/autojump.zsh" \
    /usr/share/autojump/autojump.zsh /usr/local/share/autojump/autojump.zsh; do
    if [[ -r $_dotfiles_script ]]; then
      source "$_dotfiles_script"
      break
    fi
  done
fi

alias g='grep -rn --color'
alias tmux='tmux -u'
alias ll='ls -l'
alias hb='hub browse'
alias python=python3
alias gfo='git fetch origin'
alias gb='git branch'
alias ga='git add'
alias gco='git checkout'
alias gs='git status'
alias gd='git diff'
alias gc='git commit'
alias gps='git push'
alias gf='git fetch'

function name {
  printf '\033]0;%s\007' "$*"
}

# Create the disposable Chrome profile when invoked, not at shell startup.
function demo {
  local chrome='/Applications/Google Chrome.app/Contents/MacOS/Google Chrome'
  local profile
  if [[ ! -x $chrome ]]; then
    print -u2 'demo: Google Chrome is not installed in /Applications.'
    return 1
  fi
  profile=$(mktemp -d "${TMPDIR:-/tmp}/chrome-demo.XXXXXXXX") || return
  command "$chrome" --incognito --user-data-dir="$profile" "$@"
}

# Same yellow user@host and red current-directory prompt, using Zsh escapes.
PROMPT='%B%F{yellow}%n@%m: %F{red}%1~%f%b$ '

unset _dotfiles_brew _dotfiles_dir _dotfiles_prepend _dotfiles_script
