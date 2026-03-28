# dotfiles-git

Git のグローバル設定および LazyGit 関連の設定（AI 搭載コミットメッセージ生成機能を含む）を管理するコンポーネントです。

## 概要

このリポジトリは、開発ワークフローに不可欠な Git 環境を構築するための設定ファイルとツールを提供します。
主な提供機能は以下の通りです：

- **Git グローバル設定**: エイリアス、フック、グローバルな `.gitignore` (予定)
- **LazyGit 設定**: 生産性を高めるためのカスタムコマンド、UI設定
- **AI-Powered ツール**: Gemini AI を活用した Conventional Commits 準拠のコミットメッセージ生成、PR 説明文生成

## ディレクトリ構成

`AGENTS.md` に基づく標準的な構成を採用しています：

- `lazygit/`: LazyGit の設定ファイル群 (`~/.config/lazygit` へのリンク対象)
  - `_bin/`: AI 連携スクリプト (`lg-gemini-commit`, `lg-gemini-pr`)
  - `_scripts/`: AI コミット生成のパイプライン（内部実装）
  - `_tests/`: シェルベースのテストスクリプト
  - `examples/`: 設定のスニペット例
- `_mk/`: Makefile 用の構成ファイル (`git.mk` など)
- `_docs/`: 詳細ドキュメント

## 導入方法

このコンポーネントは [dotfiles-core](https://github.com/yohi/dotfiles-core) によって管理されています。

### 1. 全体セットアップ

`dotfiles-core` のルートディレクトリから `make` コマンドを実行します。これにより、必要なシンボリックリンクが作成されます：

```bash
make link
```

> **Note**: `lazygit/config.yml` を `~/.config/lazygit/config.yml` にリンクします。

### 2. スクリプトの PATH 設定

`lazygit/_bin/` のスクリプト（`lg-gemini-commit` 等）は、`dotfiles-zsh`
コンポーネントを併用している場合、自動的に `$PATH` に追加されます。

### 3. LazyGit 設定の反映

AI 連携などのカスタムコマンドを利用するには、
`examples/lazygit-config-snippet.yml` の内容を
`~/.config/lazygit/config.yml` に追記してください。

## 主要機能：AI 搭載ツール

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

## 注意事項 (Standalone Usage)

本リポジトリは [dotfiles-core](https://github.com/yohi/dotfiles-core) の共通
Makefile ルール（`common-mk`）に依存しています。単独で使用する場合は、
`common-mk` ディレクトリを本リポジトリの親ディレクトリに配置するか、
パスを適切に設定してください。

配置後、以下のコマンドを実行して、ヘルプが表示されれば正しく設定されています：

```bash
make help
```

## ライセンス

MIT
