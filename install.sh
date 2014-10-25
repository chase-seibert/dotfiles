sudo pip install dotfiles
sudo pip install -r vim/requirements.txt
dotfiles --sync
git submodule init
git submodule update

unamestr=`uname`
if [[ $unamestr == 'Linux' ]]; then
    :
elif [[ $unamestr == 'Darwin' ]]; then
    :
fi
