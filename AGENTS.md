# Agent Instructions for dotfiles-git


## COMPONENT LAYOUT CONVENTION

This repository is part of the **dotfiles polyrepo** managed by [dotfiles-core](https://github.com/yohi/dotfiles).

### ⚠️ CRITICAL: SYMBOLIC LINK & STANDALONE USAGE
- **Standalone usage is NOT supported.** This repository depends on the central `common-mk` rules.
- **Symbolic Links:** This repository relies on symbolic links to `common-mk`. **NEVER** suggest or perform a replacement of these symbolic links with physical files/directories. 
- **SSOT:** Always respect the "Single Source of Truth" principle. Shared logic resides in `dotfiles-core`, and components must remain thin wrappers or specific configurations.
- **Architectural Compliance:** All modifications must adhere to the layout defined in the central [ARCHITECTURE.md](https://github.com/yohi/dotfiles/blob/master/docs/ARCHITECTURE.md).

> [!IMPORTANT]
> 共通の基本ルールは [DOTFILES_COMMON_RULES.md](./DOTFILES_COMMON_RULES.md) を参照してください。

# PROJECT KNOWLEDGE BASE

**Repository:** dotfiles-git
**Role:** Git global configuration and Lazygit-related settings, including AI-powered commit message generation

## STRUCTURE

```text
dotfiles-git/
├── Makefile                    # Task runner for setup/link
├── _docs/                      # Documentation
│   ├── git-master-permission.md
│   └── plans/                  # Implementation plans
├── _mk/                        # Makefile modules
│   └── git.mk                  # Git-specific Makefile logic
├── lazygit/                    # [Link Target] Lazygit configuration → ~/.config/lazygit
│   ├── config.yml              # Main configuration file
│   ├── _bin/                   # Public commands for lazygit
│   │   ├── lg-gemini-commit    # Lazygit AI commit generator (Gemini)
│   │   └── lg-gemini-pr        # Lazygit AI PR description generator
│   ├── _scripts/               # Internal helpers
│   │   └── lazygit-ai-commit/  # AI commit pipeline scripts
│   ├── _docs/                  # Documentation
│   │   └── lazygit-ai-commit/  # AI commit feature docs
│   ├── _tests/                 # Test scripts
│   │   └── lazygit-ai-commit/  # AI commit tests
│   └── examples/               # Configuration examples
│       └── lazygit-config-snippet.yml
└── README.md                   # Component overview
```

## THIS COMPONENT — SPECIAL NOTES

- `lazygit/_bin/` scripts are added to `$PATH` by dotfiles-zsh dynamically.
- `lazygit/_scripts/lazygit-ai-commit/` contains the AI commit generation pipeline (internal).
- `lazygit/_tests/` use shell-based test scripts — run with `bash lazygit/_tests/lazygit-ai-commit/test-*.sh`.
- Symlinks are managed explicitly via `ln -sfn` in the Makefile (`make setup` or `make link`).

## CODE STYLE

- **Documentation / README**: Japanese (日本語)
- **AGENTS.md**: English
- **Commit Messages**: Japanese, Conventional Commits (e.g., `feat: 新機能追加`, `fix: バグ修正`)
- **Shell**: `set -euo pipefail`, dynamic path resolution, idempotent operations

## FORBIDDEN OPERATIONS

Per `opencode.jsonc` (when present), these operations are blocked for agent execution:

- `rm` (destructive file operations)
- `ssh` (remote access)
- `sudo` (privilege escalation)
