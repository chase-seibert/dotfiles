export CLICOLOR=1
export LSCOLORS=gxBxhxDxfxhxhxhxhxcxcx

### Added by the Heroku Toolbelt
export PATH="/usr/local/heroku/bin:$PATH"

if [ -f $(brew --prefix)/etc/bash_completion ]; then
  . $(brew --prefix)/etc/bash_completion
fi

if [ -f ~/.git-completion.bash ]; then
      . ~/.git-completion.bash
fi

export PATH=/usr/local/bin:$PATH
eval "$(rbenv init -)"

cd ~/projects/HearsayLabs/fanmgmt/
