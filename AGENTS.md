# PROJECT KNOWLEDGE BASE

**Repository:** dotfiles-git
**Role:** Git global configuration and Lazygit-related settings, including AI-powered commit message generation

## STRUCTURE

```text
dotfiles-git/
├── bin/                        # Public commands (added to $PATH by dotfiles-zsh)
│   ├── lg-gemini-commit        # Lazygit AI commit generator (Gemini)
│   └── lg-gemini-pr            # Lazygit AI PR description generator
├── scripts/                    # Internal helpers
│   └── lazygit-ai-commit/      # AI commit pipeline scripts
├── docs/                       # Documentation
│   └── lazygit-ai-commit/      # AI commit feature docs
├── tests/                      # Test scripts
│   └── lazygit-ai-commit/      # AI commit tests
├── examples/                   # Configuration examples
│   └── lazygit-config-snippet.yml
└── archive/                    # Historical implementation logs
```

## COMPONENT LAYOUT CONVENTION

This repository is part of the **dotfiles polyrepo** orchestrated by `dotfiles-core`.
All changes MUST comply with the central layout rules. Please refer to [`dotfiles-core/docs/ARCHITECTURE.md`](../../docs/ARCHITECTURE.md) for the full, authoritative rules and constraints.

## THIS COMPONENT — SPECIAL NOTES

- `bin/` scripts are added to `$PATH` by dotfiles-zsh (loose coupling per SPEC.md).
- `scripts/lazygit-ai-commit/` contains the AI commit generation pipeline (internal).
- `tests/` use shell-based test scripts — run with `bash tests/lazygit-ai-commit/test-*.sh`.
- Git global config files (`.gitconfig` etc.) should be Stow targets at repo root.

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
