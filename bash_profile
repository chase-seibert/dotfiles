unamestr=`uname`

for _dotfiles_brew in /opt/homebrew/bin/brew /usr/local/bin/brew; do
    if [ -x "$_dotfiles_brew" ]; then
        eval "$("$_dotfiles_brew" shellenv)"
        break
    fi
done
unset _dotfiles_brew

if [[ $unamestr == 'Linux' ]]; then

    alias ls="ls --color=always"
    if [ -f ~/.git-completion.bash ]; then
          . ~/.git-completion.bash
    fi

    # Predictable SSH authentication socket location.
    SOCK="/tmp/ssh-agent-$USER-screen"
    if test $SSH_AUTH_SOCK && [ $SSH_AUTH_SOCK != $SOCK ]
    then
        rm -f /tmp/ssh-agent-$USER-screen
        ln -sf $SSH_AUTH_SOCK $SOCK
        export SSH_AUTH_SOCK=$SOCK
    fi

elif [[ $unamestr == 'Darwin' ]]; then

    export CLICOLOR=1
    export LSCOLORS=gxBxhxDxfxhxhxhxhxcxcx
    export PATH=/usr/local/bin:$PATH

    if [ -f ~/.git-completion.bash ]; then
      . ~/.git-completion.bash
    fi

fi

# Load Autojump directly; no separate Bash completion package is required.
for _dotfiles_autojump in \
    "$HOME/.autojump/share/autojump/autojump.bash" \
    "${HOMEBREW_PREFIX:-/opt/homebrew}/share/autojump/autojump.bash" \
    /usr/share/autojump/autojump.bash /usr/local/share/autojump/autojump.bash; do
    if [ -r "$_dotfiles_autojump" ]; then
        source "$_dotfiles_autojump"
        break
    fi
done
unset _dotfiles_autojump

alias g="grep -rn --color"
alias tmux="tmux -u"
alias ll="ls -l"
function name {
    echo -ne "\033]0;"$*"\007"
}

# dropbox specific
alias dev="ssh $USER-dbx"

PATH=$PATH:$HOME/.dotfiles/bin
PATH=$PATH:/usr/local/heroku/bin
PS1='\[\e[33;1m\]\u@\h: \[\e[31m\]\W\[\e[0m\]$ '

export PATH="/usr/local/sbin:$PATH"
export PATH=/opt/dropbox-override/bin:$PATH
export BASH_SILENCE_DEPRECATION_WARNING=1
export PATH="$HOME/.local/bin:$PATH"

alias start-pg="pg_ctl -D /opt/homebrew/var/postgres start"
alias stop-pg="pg_ctl -D /opt/homebrew/var/postgres stop"
export EDITOR=vi
alias gfo="git fetch origin"
alias gb="git branch"
alias ga="git add"
alias gco="git checkout"
alias gs="git status"
alias gd="git diff"
alias gc="git commit"
alias gps="git push"
alias gf="git fetch"
alias demo="/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome \
  --incognito \
  --user-data-dir=$(mktemp -d)"
alias python=python3
