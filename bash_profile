unamestr=`uname`

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
    if [ -f $(brew --prefix)/etc/bash_completion ]; then
      . $(brew --prefix)/etc/bash_completion
    fi
    export PATH=/usr/local/bin:$PATH
    eval "$(rbenv init -)"

fi

alias dev="ssh cseibert.dev.hearsaylabs.com"
alias fan="cd ~/projects/HearsayLabs/fanmgmt/"
alias g="grep -rn --color"
alias tmux="tmux -u"
alias ll="ls -l"

PATH=$PATH:$HOME/.dotfiles/bin
PS1='\[\e[33;1m\]\u@\h: \[\e[31m\]\W\[\e[0m\]$ '
cd ~/projects/HearsayLabs/fanmgmt/
