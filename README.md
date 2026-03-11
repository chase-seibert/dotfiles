# Install

```bash
git clone git@github.com:chase-seibert/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
./symlinks.sh
./vim.sh
./mac.sh  # or ./linux.sh
source ~/.bash_profile
```

Adding files
1. Update symlinks.sh
2. Create (or move) the file into ~/.dotfiles, remove the "." prefix
3. Run the individual symlink command to link the file at the canonical location
