sudo pip install dotfiles
sudo pip install -r vim/requirements.txt
cp ~/.dotfiles/dotfilesrc ~
dotfiles --sync -R ~/.dotfiles --force
git submodule init
git submodule update

unamestr=`uname`
if [[ $unamestr == 'Linux' ]]; then
    sudo apt-get install silversearcher-ag
elif [[ $unamestr == 'Darwin' ]]; then
    launchctl load ~/.dotfiles/etc/pbcopy.plist
    launchctl load ~/.dotfiles/etc/pbpaste.plist
    brew install ag
    brew install Caskroom/cask/iterm2
    brew install Caskroom/cask/libreoffice
    brew install tmux
    brew install bash-completion
fi
