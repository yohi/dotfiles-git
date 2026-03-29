# Documentation and Setup Command Inconsistency Resolution Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Resolve inconsistencies between Makefile, README.md, and AGENTS.md regarding setup commands and directory structure.

**Architecture:** Surgical updates to Makefile and Markdown files to align implementation with documentation.

**Tech Stack:** Makefile, Markdown

---

### Task 1: Update Makefile `setup` target

**Files:**
- Modify: `Makefile`

**Step 1: Write minimal implementation**

Update `setup` target to depend on `link`.

**Step 2: Run verification command**

Run: `make setup`
Expected: `link` and `setup-git` are executed.

**Step 3: Commit**

```bash
git add Makefile
git commit -m "fix: setup ターゲットが link を呼び出すように修正"
```

---

### Task 2: Correct AGENTS.md directory structure and notes

**Files:**
- Modify: `AGENTS.md`

**Step 1: Write minimal implementation**

Correct the `STRUCTURE` tree and `SPECIAL NOTES`.

**Step 2: Commit**

```bash
git add AGENTS.md
git commit -m "docs(agents): ディレクトリ構造とセットアップコマンドの記述を修正"
```

---

### Task 3: Update README.md with directory structure and snippet instructions

**Files:**
- Modify: `README.md`

**Step 1: Write minimal implementation**

Update `ディレクトリ構成` and add a note to `導入方法`.

**Step 2: Commit**

```bash
git add README.md
git commit -m "docs: README のディレクトリ構成と既存設定保持の手順を更新"
```

---

### Task 4: Final Verification

**Step 1: Run all verification commands**

- `make help`
- `make setup`

**Step 2: Commit (if any fixes needed)**
