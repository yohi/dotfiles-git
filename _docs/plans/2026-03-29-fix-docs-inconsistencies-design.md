# Design Doc: Documentation and Setup Command Inconsistency Resolution
Date: 2026-03-29

## Context
There are several inconsistencies between `Makefile`, `README.md`, and `AGENTS.md` regarding the primary setup command (`make setup` vs `make link`), the directory structure, and the instructions for using LazyGit configuration snippets.

## Proposed Changes
1. **Makefile**:
   - Update `setup` target to depend on `link` and `setup-git`.
   - Ensures `make setup` (the recommended command in `README.md`) actually creates the necessary symlinks.

2. **AGENTS.md**:
   - Correct the `STRUCTURE` tree:
     - Remove `_bin/` (root-level, doesn't exist) and `archive/` (doesn't exist).
     - Add `_mk/` and `_docs/` (root-level, exist).
   - Update `THIS COMPONENT — SPECIAL NOTES` to mention `make setup` as the primary command.

3. **README.md**:
   - Correct the `ディレクトリ構成` (Directory Structure) tree to include `_mk/` and `lazygit/examples/`.
   - Update the `導入方法` (Installation) section to include a note about using `lazygit/examples/lazygit-config-snippet.yml` for users with existing configurations.

## Verification Strategy
1. **Makefile Verification**:
   - Run `make help` to ensure the descriptions are correct.
   - Run `make setup` and verify it triggers `link` and `setup-git`.
2. **Documentation Verification**:
   - Review all modified Markdown files for accuracy and formatting.
   - Verify that the directory tree matches the actual layout.
