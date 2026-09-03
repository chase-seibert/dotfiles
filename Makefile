.PHONY: check link link-zsh

check:
	bash -n symlinks.sh mac.sh linux.sh vim.sh bashrc bash_profile
	zsh -n zshrc

link:
	./symlinks.sh

link-zsh:
	./symlinks.sh --zsh-only
