# fix scp
if [ -z "$PS1" ]; then
    return;
fi

if [ -f ~/.bashrc ]; then
   source ~/.bashrc
fi

[ -s "/Users/cseibert/.scm_breeze/scm_breeze.sh" ] && source "/Users/cseibert/.scm_breeze/scm_breeze.sh"

# Added by git-ai installer on Thu Aug  6 12:24:05 PDT 2026
export PATH="/Users/cseibert/.git-ai/bin:$PATH"
