unamestr=`uname`

if [[ $unamestr == 'Linux' ]]; then

    alias ls="ls --color=always"
    if [ -f ~/.git-completion.bash ]; then
          . ~/.git-completion.bash
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

alias dev="ssh cseibert@cseibert.dev.hearsaylabs.com"
alias fan="cd ~/projects/HearsayLabs/fanmgmt/"
alias grep="grep -rn --color"
alias tmux="tmux -u"

PS1='\[\e[33;1m\]\u@\h: \[\e[31m\]\W\[\e[0m\]$ '
cd ~/projects/HearsayLabs/fanmgmt/
