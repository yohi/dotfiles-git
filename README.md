# dotfiles-git

Git のグローバル設定および LazyGit 関連の設定（AI 搭載コミットメッセージ生成機能を含む）を管理するコンポーネントです。

## 管理と共存関係

> [!IMPORTANT]
> 本リポジトリは [dotfiles-core](https://github.com/yohi/dotfiles-core) によって管理されるコンポーネントの一つです。

> [!WARNING]
> **使用時の注意点**
> 本リポジトリは `dotfiles-core` の共通 Makefile ルール（`common-mk`）に依存しており、実行時には `common-mk` へのシンボリックリンクが必要です。そのため、**本リポジトリ単体での使用（クローンしての利用）はサポートされていません。**
>
> 推奨される使用方法は、`dotfiles-core` リポジトリから `make setup` を実行し、適切なディレクトリ構造とシンボリックリンクが構成された状態で利用することです。

## 主要機能

- **Git グローバル設定**: エイリアス、フック、グローバルな `.gitignore` の自動管理。
- **LazyGit 統合**: 直感的な TUI による Git 操作と高度なカスタム設定。
- **AI 搭載コミット生成**: `nxc`（[nexus-commit](https://github.com/yohi/nexus-commit)）によるローカル完結のコミットメッセージ生成（`Ctrl+a`）。Google Gemini を使う `lg-gemini-commit`（`Ctrl+b`）も利用できます。
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

> **Note**: `make setup` ターゲットは内部で `make setup-git` を実行します。これにより、必要なシンボリックリンク（`~/.config/lazygit/config.yml`）の作成と初期設定が自動的に行われます。

#### 既存の設定を保持したい場合
すでに `~/.config/lazygit/config.yml` をカスタマイズしている場合は、`make setup` を実行する代わりに、`lazygit/examples/lazygit-config-snippet.yml` の内容を既存の設定ファイルに追記してください。

### 2. スクリプトの PATH 設定

`lazygit/_bin/` のスクリプト（`lg-gemini-commit` 等）は、`dotfiles-zsh` コンポーネントを併用している場合、自動的に `$PATH` に追加されます。

## 詳細: AI 搭載ツール

ローカル完結の `nxc`（nexus-commit）と Google Gemini を活用した開発補助ツールを提供し、日々の Git 操作を効率化します。

### 1. LazyGit & nxc コマンド (Ctrl+a)

LazyGit の `Files` コンテキストで `Ctrl+a` を押すと、`nxc`（[nexus-commit](https://github.com/yohi/nexus-commit)）が起動します。`staged diff` とローカルインデックス基盤 Nexus から取得した周辺コードの文脈をローカル LLM（Ollama 等）に渡し、**外部へのデータ送信なし**で Conventional Commits 準拠のメッセージを生成します。

- **完全ローカル完結**: ソースコードを外部 SaaS に送信せず、プライバシーを保ったまま生成します。
- **ディープ・コンテキスト**: `--auto-start-nexus` により Nexus daemon を自動起動し、周辺コードの意図まで汲み取ります。
- **対話的フロー**: 生成 → プレビュー → 採用 / 編集 / 再生成 / 中止 を `nxc` 自身が提供し、採用時にそのままコミットします。

> **前提条件**: `nxc` 本体・ローカル LLM（Ollama + `qwen2.5-coder` 等）・埋め込みモデル（`nomic-embed-text`）が必要です。`nxc --doctor` で疎通を確認できます。詳細は [nexus-commit](https://github.com/yohi/nexus-commit) を参照してください。

### 2. LazyGit & Gemini AI コマンド (Ctrl+b)

`Files` コンテキストで `Ctrl+b` を押すと、Google Gemini を利用した `lg-gemini-commit` が `staged diff` を解析してコミットメッセージを生成します（要 `gemini` CLI）。ネットワーク経由の高速生成が必要な場合のフォールバックとして利用できます。

- **Conventional Commits v1.0.0 準拠**: `feat`, `fix`, `docs`, `refactor` などを適切に付与します。
- **破壊的変更の検知**: 重大な変更が含まれる場合、`!` や `BREAKING CHANGE:` を自動付与します。
- **バリデーション機能**: 生成文が規約に違反している場合はコミットを実行せず、エラーを返します。

### 3. PR 説明文の生成 (`lg-gemini-pr` / Ctrl+g)

ブランチ間の差分を元に、GitHub/GitLab 等のプルリクエスト作成時に使える説明文の草案を生成します。

### 手動実行での確認

LazyGit を介さず、コマンドラインからも直接実行して動作を確認できます：

```bash
# 変更をステージングした後（nxc / ローカル AI）
nxc --staged

# Gemini 版を使う場合
lg-gemini-commit
```

## 環境設定

### nxc (nexus-commit / Ctrl+a)

`nxc` は環境変数で設定します。主要な変数は以下の通りです（全一覧は [nexus-commit](https://github.com/yohi/nexus-commit) を参照）：

| 変数名 | 既定値 | 内容 |
| --- | --- | --- |
| `NEXUS_COMMIT_LLM_URL` | `http://localhost:11434/v1` | OpenAI 互換 LLM エンドポイント |
| `NEXUS_COMMIT_LLM_MODEL` | `qwen2.5-coder:1.5b` | 使用するローカル LLM モデル |
| `NEXUS_COMMIT_LANG` | `ja` | 生成言語（`ja` / `en`） |
| `NEXUS_API_URL` | `http://localhost:8080` | Nexus サーバーの URL |

### Gemini 版 (`lg-gemini-commit` / Ctrl+b)

以下の環境変数で Gemini 版の動作をカスタマイズできます：

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
