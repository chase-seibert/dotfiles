unamestr=`uname`

eval $(/opt/homebrew/bin/brew shellenv)

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

    source /usr/share/autojump/autojump.bash

elif [[ $unamestr == 'Darwin' ]]; then

    export CLICOLOR=1
    export LSCOLORS=gxBxhxDxfxhxhxhxhxcxcx
    if [ -f $(brew --prefix)/etc/bash_completion ]; then
      . $(brew --prefix)/etc/bash_completion
    fi
    export PATH=/usr/local/bin:$PATH

    if [ -f ~/.git-completion.bash ]; then
      . ~/.git-completion.bash
    fi

    [[ -s $(brew --prefix)/etc/profile.d/autojump.sh ]] && . $(brew --prefix)/etc/profile.d/autojump.sh

fi

# before aliases so that I can over-ride "g"
# [ -s "$HOME/.scm_breeze/scm_breeze.sh" ] && source "$HOME/.scm_breeze/scm_breeze.sh"

alias g="grep -rn --color"
alias tmux="tmux -u"
alias ll="ls -l"
alias hb="hub browse"
function name {
    echo -ne "\033]0;"$*"\007"
}

# dropbox specific
alias dev="ssh $USER-dbx"

PATH=$PATH:$HOME/.dotfiles/bin
PATH=$PATH:/usr/local/heroku/bin
PS1='\[\e[33;1m\]\u@\h: \[\e[31m\]\W\[\e[0m\]$ '

export PATH="/usr/local/sbin:$PATH"
if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi
export PATH=/opt/dropbox-override/bin:$PATH
export BASH_SILENCE_DEPRECATION_WARNING=1

alias start-pg="pg_ctl -D /opt/homebrew/var/postgres start"
alias stop-pg="pg_ctl -D /opt/homebrew/var/postgres stop"
source /opt/homebrew/opt/chruby/share/chruby/chruby.sh
chruby ruby-3.1.2
export EDITOR=vi
alias gfo="git fetch origin"
alias gb="git branch"
alias ga="git add"
alias gco="git checkout"
alias gs="git status"
alias gd="git diff"
alias gc="git commit"
alias gps="git push"
