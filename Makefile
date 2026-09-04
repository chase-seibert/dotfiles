.PHONY: check link link-zsh autojump

check:
	@for script in symlinks.sh mac.sh linux.sh autojump.sh vim.sh bashrc bash_profile; do bash -n "$$script" || exit; done
	zsh -n zshrc

link:
	./symlinks.sh

link-zsh:
	./symlinks.sh --zsh-only

autojump:
	bash ./autojump.sh
