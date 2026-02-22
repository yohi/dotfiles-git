REPO_ROOT ?= $(CURDIR)
.DEFAULT_GOAL := setup
include _mk/git.mk

.PHONY: setup
setup: setup-git
	@echo "==> Setting up dotfiles-git"
