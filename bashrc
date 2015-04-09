# fix scp
if [ -z "$PS1" ]; then
    return;
fi

if [ -f ~/.bashrc ]; then
   source ~/.bashrc
fi
