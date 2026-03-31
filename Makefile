include _mk/core.mk
include _mk/help.mk
-include _mk/git.mk

.PHONY: install setup install-git setup-git clean test

install: install-git ## Git 関連のインストール
setup: setup-git ## Git の設定適用

install-git:
	@echo "==> Installing dotfiles-git"

setup-git:
	@echo "==> Setting up dotfiles-git"
	mkdir -p "$(HOME)/.config/lazygit"
	ln -sfn "$(CURDIR)/lazygit/config.yml" "$(HOME)/.config/lazygit/config.yml"

clean: ## 一時ファイルのクリーンアップ
	@echo "==> Cleaning dotfiles-git"

test: ## テスト実行
	@echo "==> Testing dotfiles-git"
