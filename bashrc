# fix scp
if [ -z "$PS1" ]; then
    return;
fi

if [ -f ~/.bashrc ]; then
   source ~/.bashrc
fi

[ -s "/Users/chase/.scm_breeze/scm_breeze.sh" ] && source "/Users/chase/.scm_breeze/scm_breeze.sh"
