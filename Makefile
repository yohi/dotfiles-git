# Orchestrator core configuration
# Note: These are symlinked from ../../common-mk/ when managed by dotfiles-core
-include _mk/core.mk
-include _mk/help.mk

# Component-specific logic





REPO_ROOT ?= $(CURDIR)
include _mk/git.mk

.PHONY: link
link: ## シンボリックリンクを展開し、dotfiles を配置します
	@echo "==> Linking dotfiles-git"
	mkdir -p $(HOME)/.config/lazygit
	ln -sfn $(REPO_ROOT)/lazygit/config.yml $(HOME)/.config/lazygit/config.yml

.PHONY: setup
setup: ## セットアップ（依存関係、設定適用）を一括実行します
	@echo "==> Setting up dotfiles-git"
	$(MAKE) setup-git
