sudo pip install dotfiles
sudo pip install -r vim/requirements.txt
cp ~/.dotfiles/dotfilesrc ~/.dotfilesrc
dotfiles --sync -R ~/.dotfiles --force
git submodule init
git submodule update
