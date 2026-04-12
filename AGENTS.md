# AGENTS.md

Guidance for coding agents working in this repository.

## 1) Repository model

This project has two roles:
1. Neovim runtime configuration (Lua-first).
2. Python CLI + Sphinx docs tooling for build, publish, and project documentation.

Interpretation rule:
- `lua/` is editor runtime behavior.
- `src/nvim_config/` and `docs/` are project automation and documentation.

Key top-level files and paths:
- `init.lua` -> Neovim startup entrypoint.
- `lua/` -> runtime modules, plugin specs, and custom helpers.
- `src/nvim_config/main.py` -> `nvim-config` CLI entrypoint.
- `docs/` -> Sphinx documentation source.
- `Makefile` -> wrappers for common format/docs/docker tasks.
- `pyproject.toml` -> Python packaging + tooling config.

Generated artifacts (do not edit unless explicitly asked):
- `docs/_build/`
- `__pycache__/`
- build outputs under Python packaging dirs.

## 2) Config structure and plugin grouping

This repository uses a deliberate plugin grouping structure. Keep that structure intact unless the user asks for a reorganization.

Load/import order is meaningful and defined in `init.lua` via `lazy.nvim` imports.

Primary groups under `lua/plugins/`:
- `dev.lua`, `snacks.lua` -> early/core plugin foundations.
- `pde/` -> LSP, completion, and editor-as-PDE behavior.
- `persona/` -> UI/theme/appearance layers.
- `author.lua`, `git.lua`, `hotkeys.lua` -> authoring and git ergonomics.
- `expedition/` -> navigation, file movement, telescope/oil workflows.
- `treesitter/` -> parser + syntax behavior.
- `quagmire/` -> diagnostics/trouble/quicker style workflows.
- `os-config/`, `os-linux*/`, `os-windows/` -> OS-specific plugin overlays.
- `user-config/`, `user-vvnraman/` -> user/machine-specific overlays.
- `no-op/` -> intentionally empty stubs/fallback behavior.
- `session.lua`, `ai/` -> session and AI tooling.

Do not move plugins between groups casually. Prefer extending the existing group nearest to the behavior being changed.

Custom project-local Lua modules live under `lua/vvn/` (for example `lua/vvn/yank.lua`, `lua/vvn/util.lua`). Treat this folder as first-class local plugin-like infrastructure and prefer reuse from here instead of duplicating helpers.

## 3) Build, lint, and verification commands

Run commands from the current git worktree root.

Canonical config location is `~/.config/nvim/`, but active development may happen in another worktree under `~/.config/`.

### Environment setup
- `uv sync` - install/update Python dependencies.

### Formatting
- `make format` - run StyLua for Lua files.

### Docs build and preview
- `make docs` or `uv run nvim-config docs` - build docs.
- `make live` or `uv run nvim-config live` - run docs live server.
- `make clean` or `uv run nvim-config clean` - clean docs outputs.

### Type checks
- `uv run basedpyright` - type-check configured Python/docs code.

### Practical Neovim smoke checks
- `nvim --headless "+checkhealth" +qa`
- `nvim --headless "+Lazy! sync" +qa` (only when plugin changes require it)

### Worktree-specific Neovim launch
- Use the repo-local `./nvim` wrapper when validating a non-canonical worktree.
- The wrapper sets `NVIM_APPNAME` from the current worktree path so Neovim uses that worktree as its config root.
- `./nvim-init` follows the same `NVIM_APPNAME` behavior, then runs the bootstrap/headless init flow.
- Example: `./nvim --headless "+checkhealth" +qa`

### Neovim data/state paths (`NVIM_APPNAME` aware)
- For canonical config (`~/.config/nvim`), defaults are:
  - `~/.local/share/nvim/` (plugin clones and other persistent data)
  - `~/.local/state/nvim/` (runtime state)
- With custom `NVIM_APPNAME`, replace `nvim` with that app name (relative to `~/.config/`).
- Example: if `NVIM_APPNAME=foo/bar`, paths are:
  - `~/.local/share/foo/bar/`
  - `~/.local/state/foo/bar/`
- For troubleshooting plugin installs/updates, inspect `~/.local/share/$NVIM_APPNAME/` first.

## 4) Docker end-to-end test harness

This repo includes a Docker harness for end-to-end validation under `docker/`.

Use this for major config/plugin/profile changes to confirm behavior in clean environments.

Key commands:
- Interactive shells:
  - `make docker-shell-arch`
  - `make docker-shell-ubuntu`
  - `make docker-shell-ubuntu-minimal`
- Automated smoke tests:
  - `./docker/run-workflow.sh --workflow smoke-test arch,standard`
  - `./docker/run-workflow.sh --workflow smoke-test ubuntu,standard`
  - `./docker/run-workflow.sh --workflow smoke-test ubuntu,minimal`

When changes are broad (plugin bootstrapping, load order, profiles, telescope/oil flows, keymaps used in startup), run at least one relevant Docker smoke workflow.

## 5) Lua coding conventions

General:
- Keep changes minimal, local, and scoped to relevant modules.
- Preserve existing naming and module boundaries.
- Prefer explicit, readable logic over compact cleverness.
- Use guard clauses/early returns for invalid state.

Style and module patterns:
- Use StyLua conventions from `stylua.toml` (2 spaces, 96 cols, double quotes, call parens).
- Use `local M = { ... }` + `return M` for modules/spec files.
- Use `local fn_name = function() ... end` for local helpers.
- Prefer `snake_case` names.

Keymaps and plugin specs:
- Prefer `vim.keymap.set(..., { desc = ... })`.
- Reuse shared helpers from `lua/globals.lua` where appropriate.
- Declare plugin dependencies explicitly in spec tables.

EmmyLua annotations (required):
- Add EmmyLua annotations for new or changed Lua functions.
- At minimum, annotate function params/returns (`---@param`, `---@return`).
- Add local type hints (`---@type`) where non-obvious structures are used (for example Telescope picker entries, complex option tables, callback payloads).
- Keep annotations accurate when refactoring.

## 6) Python coding conventions

Scope: `src/nvim_config/` and docs tooling code.

- Keep compatibility with `pyproject.toml` requirements.
- Group imports as stdlib, then third-party, then local.
- Add type hints for parameters and return values.
- Keep `basedpyright` clean for touched code.
- Preserve CLI UX semantics when extending commands.

## 7) Documentation expectations

This project is comprehensively documented. Documentation updates are part of
normal code changes, not an afterthought.

Follow `docs/reference/meta.rst` as the source of truth for documentation
structure, changelog conventions, explanation/how-to/reference writing style,
and literalinclude/layout rules.

Always update the relevant docs when behavior changes, and never hand-edit
generated output under `docs/_build/`.

## 8) File and change hygiene

- Do not rename/move top-level entrypoints (`init.lua`, `pyproject.toml`, `Makefile`) without explicit need.
- Keep plugin changes scoped to relevant files under `lua/plugins/**`.
- Avoid broad refactors during targeted fixes.
- Respect existing user changes in a dirty worktree; do not revert unrelated edits.

## 9) Cursor/Copilot rules status

Checked these locations:
- `.cursor/rules/**`
- `.cursorrules`
- `.github/copilot-instructions.md`

Current status: no extra Cursor/Copilot rule files are present in this repo.
If added later, treat them as authoritative and merge guidance here.

## 10) Suggested execution order for agents

For most changes:
1. Read relevant Lua/docs modules first.
2. Apply scoped code edits.
3. Run `make format` for Lua edits.
4. Run targeted verification:
   - Neovim headless checks for runtime changes.
   - Docker smoke tests for major cross-cutting changes.
5. Run docs build (`make docs`) when docs or behavior changed.
6. Summarize what changed, what was verified, and what remains manual.
