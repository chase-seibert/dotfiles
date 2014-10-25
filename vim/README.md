chase-vimrc
===========

Chase Seibert's vimrc + bundles

## Linux / OSX

```bash
git clone git@github.com:chase-seibert/chase-vimrc.git ~/.vim
ln -s ~/.vim/.vimrc ~/.vimrc
cd .vim
sudo pip install -r requirements.txt
git submodule init
git submodule update
```
## Windows

```bash
# must run command line as administrator (for the mklink)
cd %HOMEPATH%
git clone https://github.com/chase-seibert/chase-vimrc.git vimfiles
mklink _vimrc vimfiles\.vimrc
cd vimfiles
git submodule init
git submodule update
```

# Cheat Sheet

## Movement
- W, E, B, gE
- f/ - go forward to first slash character
- H, M, L - move cursor quickly
- ^U, ^D - scroll up/down by half pages
- G, gg - bottom, top
- :marks, ma, 'a - see marks, make a mark, goto mark a
- '' - back to where you were
- zz - center screen on current line

## Search
- * - search on current word
- n, N - forward/back on search term
- :%s/foo/bar/g - search and replace
- \g - Grep for word under cursor (custom)

## Edit
- o, O - add a new line bellow or above, go into insert mode
- I, A - enter insert mode at the start or end of the current line
- x, X - delete current character, previous character
- ctm - change until first m character
- cc - change line in place
- C - change to end of line
- J - join this line and the next line

## Normal mode quickies
- . - last command
- % - jump between parans
- *, # - next/prev version of word

## Buffers
- :ls, :b name/number
- copy current word - :yiw
- d} - delete current block

## Common functions
- ^P - word completion
- :source $MYVIMRC - reload .vimrc
- :e - reload current file
- ^o - back to last buffer
- ^i - forward one buffer

## Splits
- ^W^S - split window horizontally
- ^W^V - split window vertically
- ^W^W - toggle windows
- ^W^H - rotate window left (can also use J K or L)

## Spelling
- :setlocal spell spelllang=en_us - enable
- z= - correct the word under the cursor

## Formatting

- gq - Wrap a visual selection at 80 chars

## Rope

- ^<Space> - Rope Auto-complete (context aware version of control-P)
- ^Crr - Rope rename refactoring
- ^Cro - Rope re-order imports
- ^Cra - Auto import word under cursor!

# Bundles

## Install new

```bash
cd ~/.vim
git submodule add git@github.com:davidhalter/jedi-vim.git bundle/jedi-vim
```

## Update submodules

```bash
git submodule -q foreach git pull -q origin master
```

## ctrlp.vim
- control + p - open fuzzy finder
- control + o - open selection, prompts for how (new tab, etc)

# MacVim + python-mode

Set PYTHONPATH in `~/.bash_profile` to include the absolute paths for your project. That will enable go to.

# OSX +python in command-line vim

From: http://mikegrouchy.com/blog/compile-vim-with-python-on-osx-with-homebrew.html

```bash
sudo pip install mercurial
brew install https://raw.github.com/gist/2051422/0cfce544a4ab86318221c4d7213306a7b7ec7b3d/vim.rb
sudo mv /usr/bin/vim /usr/bin/oldvim
sudo ln -s /usr/local/bin/vim /usr/bin/vim
vim --version
```


# References
- http://stevelosh.com/blog/2010/09/coming-home-to-vim/#important-vimrc-lines
- http://www.derekwyatt.org/vim/vim-tutorial-videos/vim-novice-tutorial-videos/
