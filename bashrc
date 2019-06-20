# fix scp
if [ -z "$PS1" ]; then
    return;
fi

if [ -f ~/.bashrc ]; then
   source ~/.bashrc
fi
export PATH=/opt/dropbox-override/bin:$PATH
export PATH=/opt/dropbox-override/bin:$PATH
export PATH=/opt/dropbox-override/bin:$PATH
