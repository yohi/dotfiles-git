REPO_ROOT ?= $(CURDIR)
.DEFAULT_GOAL := setup
include _mk/git.mk

.PHONY: link
link:
	@echo "==> Linking dotfiles-git"
	mkdir -p $(HOME)/.config
	ln -sfn $(REPO_ROOT)/lazygit $(HOME)/.config/lazygit

.PHONY: setup
setup:
	@echo "==> Setting up dotfiles-git"
	$(MAKE) setup-git
