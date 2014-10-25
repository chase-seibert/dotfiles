platform='unknown'
unamestr=`uname`
if [[ "$unamestr" == 'Linux' ]]; then
   platform='linux'
elif [[ "$unamestr" == 'FreeBSD' ]]; then
   platform='freebsd'
fi

if [[ $platform == 'linux' ]]; then

    if [ -f ~/.git-completion.bash ]; then
          . ~/.git-completion.bash
    fi

elif [[ $platform == 'freebsd' ]]; then

    if [ -f $(brew --prefix)/etc/bash_completion ]; then
      . $(brew --prefix)/etc/bash_completion
    fi
    export PATH=/usr/local/bin:$PATH
    eval "$(rbenv init -)"

fi

alias dev="ssh cseibert@cseibert.dev.hearsaylabs.com"
alias fan="cd ~/projects/HearsayLabs/fanmgmt/"
alias grep="grep -rn --color"

cd ~/projects/HearsayLabs/fanmgmt/
