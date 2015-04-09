# fix scp
if [ -z "$PS1" ]; then
    return;
fi

if [ -f ~/.bashrc ]; then
   source ~/.bashrc
fi

### Added by the Heroku Toolbelt
export PATH="/usr/local/heroku/bin:$PATH"
