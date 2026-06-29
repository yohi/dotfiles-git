include _mk/core.mk
include _mk/help.mk
-include _mk/git.mk

.PHONY: all install setup install-git setup-git clean test

all: install setup ## 全てをインストールおよび設定 (デフォルト)

install: install-git ## Git 関連のインストール
setup: setup-git ## Git の設定適用

install-git:
	@echo "==> Installing dotfiles-git"

setup-git:
	@echo "==> Setting up dotfiles-git"
	mkdir -p "$(HOME)/.config/lazygit"
	ln -sfn "$(CURDIR)/lazygit/config.yml" "$(HOME)/.config/lazygit/config.yml"
	mkdir -p "$(HOME)/.config/git"
	ln -sfn "$(CURDIR)/ignore" "$(HOME)/.config/git/ignore"
	git config --global core.excludesfile "$(HOME)/.config/git/ignore"

clean: ## 一時ファイルのクリーンアップ
	@echo "==> Cleaning dotfiles-git"

test: ## テスト実行
	@echo "==> Testing dotfiles-git"
