# dotfiles-git

## 管理と共存関係

本リポジトリは [dotfiles-core](https://github.com/yohi/dotfiles) によって管理されるコンポーネントの一つです。

### ⚠️ 使用時の注意点
本リポジトリは `dotfiles-core` の共通 Makefile ルール（`common-mk`）に依存しており、実行時には `common-mk` へのシンボリックリンクが必要です。そのため、**本リポジトリ単体での使用（クローンしての利用）はサポートされていません。**

推奨される使用方法は、`dotfiles-core` リポジトリから `make setup` を実行し、適切なディレクトリ構造とシンボリックリンクが構成された状態で利用することです。

Git のグローバル設定および LazyGit 関連の設定（AI 搭載コミットメッセージ生成機能を含む）を管理するコンポーネントです。

## 主要機能

- **Git グローバル設定**: エイリアス、フック、グローバルな `.gitignore` の自動管理。
- **LazyGit 統合**: 直感的な TUI による Git 操作と高度なカスタム設定.
- **AI 搭載コミット生成**: `lg-gemini-commit` による Conventional Commits 準拠のコミットメッセージ生成。
- **PR 説明文の生成**: `lg-gemini-pr` によるプルリクエスト説明文の自動生成。

## ディレクトリ構成

```text
.
├── Makefile
├── README.md
├── AGENTS.md
├── _mk/                    # Makefile sub-targets
├── _docs/                  # Detailed documentation
├── lazygit/                # [Link Target] Lazygit configuration → ~/.config/lazygit
│   ├── config.yml          # Main configuration file
│   ├── _bin/               # Public commands for lazygit
│   ├── _scripts/           # Internal helpers
│   ├── _tests/             # Test scripts
│   └── examples/           # Configuration examples
│       └── lazygit-config-snippet.yml
└── DOTFILES_COMMON_RULES.md # Shared rules link
```

## 導入方法

このコンポーネントは [dotfiles-core](https://github.com/yohi/dotfiles-core) によって管理されています。

### 1. セットアップ

コンポーネントのディレクトリから以下のコマンドを実行します。これにより、必要なシンボリックリンクと初期設定が自動的に行われます：

```bash
make setup
```

> **Note**: `make setup` ターゲットは内部で `make link` と `make setup-git` を順に実行します。現状、シンボリックリンクの作成は `make link` によって行われますが、`_mk/git.mk` で定義されている `make setup-git` はプレースホルダーの状態であり、Git の詳細設定が必要な場合は手動で調整してください。

#### 既存の設定を保持したい場合
すでに `~/.config/lazygit/config.yml` をカスタマイズしている場合は、`make setup` を実行する代わりに、`lazygit/examples/lazygit-config-snippet.yml` の内容を既存の設定ファイルに追記してください。

### 2. スクリプトの PATH 設定

`lazygit/_bin/` のスクリプト（`lg-gemini-commit` 等）は、`dotfiles-zsh` コンポーネントを併用している場合、自動的に `$PATH` に追加されます。

## 詳細: AI 搭載ツール

Gemini AI を活用した強力な開発補助ツールを提供し、日々の Git 操作を効率化します。

### 1. LazyGit & Gemini AI コマンド (Ctrl+a)

LazyGit の `Files` コンテキストで `Ctrl+a` を押すことで、`lg-gemini-commit` が `staged diff` を解析し、最適なコミットメッセージを生成します。

- **Conventional Commits v1.0.0 準拠**: `feat`, `fix`, `docs`, `refactor` などを適切に付与します。
- **破壊的変更の検知**: 重大な変更が含まれる場合、`!` や `BREAKING CHANGE:` を自動付与します。
- **バリデーション機能**: 生成文が規約に違反している場合はコミットを実行せず、エラーを返します。

### 2. PR 説明文の生成 (`lg-gemini-pr`)

ブランチ間の差分を元に、GitHub/GitLab 等のプルリクエスト作成時に使える説明文の草案を生成します。

### 手動実行での確認

LazyGit を介さず、コマンドラインからも直接実行して動作を確認できます：

```bash
# 変更をステージングした後
lg-gemini-commit
```

## 環境設定

以下の環境変数を使用して、AI ツールの動作を詳細にカスタマイズできます：

| 変数名 | 既定値 | 内容 |
| --- | --- | --- |
| `MAX_DIFF_LINES` | `800` | Gemini に渡す staged diff の最大行数 |
| `GEMINI_MODEL` | `gemini-2.0-flash-exp` | 使用する Gemini モデル |
| `SMALL_DIFF_MODEL` | `gemini-2.0-flash-lite-preview` | 小規模な diff 用の高速モデル |
| `MODEL_SWITCH_LINES` | `200` | 小規模モデルに切り替える行数しきい値 |
| `TIMEOUT_SECONDS` | `30` | Gemini CLI のタイムアウト秒数 |

## 開発・テスト

提供されているスクリプトの多くは、`lazygit/_tests/` 配下のシェルスクリプトでテスト可能です：

```bash
bash lazygit/_tests/lazygit-ai-commit/test-message-generation.sh
```


## ライセンス

MIT
