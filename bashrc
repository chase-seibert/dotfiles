# fix scp
if [ -z "$PS1" ]; then
    return;
fi

if [ -f ~/.bashrc ]; then
   source ~/.bashrc
fi

[ -s "/Users/cseibert/.scm_breeze/scm_breeze.sh" ] && source "/Users/cseibert/.scm_breeze/scm_breeze.sh"
