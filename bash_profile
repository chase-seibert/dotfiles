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

    if [ -f ~/.git-completion.bash ]; then
      . ~/.git-completion.bash
    fi

fi

# before aliases so that I can over-ride "g"
[ -s "/Users/cseibert/.scm_breeze/scm_breeze.sh" ] && source "/Users/cseibert/.scm_breeze/scm_breeze.sh"
[[ -s $(brew --prefix)/etc/profile.d/autojump.sh ]] && . $(brew --prefix)/etc/profile.d/autojump.sh

alias g="grep -rn --color"
alias tmux="tmux -u"
alias ll="ls -l"
alias hb="hub browse"
alias git-delete-branches="python ~/.dotfiles/bin/git-delete-merged-branches.py"
function vmake {
    (cd ~/projects/dev-vagrant/vmware/; vagrant ssh --command "cd $OLDPWD; make $@");
}

# dropbox specific
alias dev="ssh $USER-dbx"

PATH=$PATH:$HOME/.dotfiles/bin
PATH=$PATH:/usr/local/heroku/bin
PS1='\[\e[33;1m\]\u@\h: \[\e[31m\]\W\[\e[0m\]$ '

export PATH="/usr/local/sbin:$PATH"
if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi
