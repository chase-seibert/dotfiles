/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
brew install ag
brew install Caskroom/cask/iterm2
brew install Caskroom/cask/libreoffice
brew install tmux
brew install bash-completion
brew install autojump
brew install hub
brew install caskroom/cask/omnifocus
brew install rbenv ruby-build
rbenv install 2.5.1
rbenv global 2.5.1
launchctl load ~/.dotfiles/etc/pbcopy.plist
launchctl load ~/.dotfiles/etc/pbpaste.plist
git clone git://github.com/scmbreeze/scm_breeze.git ~/.scm_breeze
~/.scm_breeze/install.sh
source ~/.bashrc
