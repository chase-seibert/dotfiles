sudo pip install dotfiles
sudo pip install -r vim/requirements.txt
dotfiles -R ~/.dotfiles/ --sync
git submodule init
git submodule update
