sudo pip install dotfiles
sudo pip install -r vim/requirements.txt
dotfiles --sync
git submodule init
git submodule update

unamestr=`uname`
if [[ $unamestr == 'Linux' ]]; then
    sudo apt-get install silversearcher-ag
elif [[ $unamestr == 'Darwin' ]]; then
    launchctl load ~/.dotfiles/etc/pbcopy.plist
    launchctl load ~/.dotfiles/etc/pbpaste.plist
    brew install ag
fi
