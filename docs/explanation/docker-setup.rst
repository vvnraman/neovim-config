.. _docker-setup:

*******************
Docker Test Harness
*******************

This page explains how the Docker harness builds pinned Neovim environments,
mounts the current worktree, and runs smoke or interactive validation against
that same checkout.

High-level flow
===============

1. ``docker/run-workflow.sh`` resolves one or more ``os,profile`` targets.
2. Docker Compose builds the matching Arch or Ubuntu image with pinned build
   args from ``docker/docker-compose.yaml``.
3. The runtime image installs Neovim ``v0.12.1`` plus ``fd``, ``ripgrep``, and
   ``tree-sitter-cli``.
4. The selected service mounts the repo at the same absolute path inside the
   container.
5. ``docker/nvim-env.sh`` derives ``XDG_CONFIG_HOME`` and ``NVIM_APPNAME`` from
   that mounted path before running Neovim or launching Bash.


CLI Tool Installation
=====================

``docker/install-cli-tools.sh`` is the single entrypoint for CLI tool
installation.

How it works:

- Accepts ``target_os`` as argument 1 (``arch`` or ``ubuntu``).
- Accepts repeatable ``--tool 'tool-name:tool-version'`` flags.
- Supported tools are ``fd``, ``ripgrep``, and ``tree-sitter-cli``.
- ``tool-version`` can be a pinned version or ``latest``.
- If no ``--tool`` flags are passed, defaults are used for ``fd`` and
  ``ripgrep``.
- The Dockerfiles pass ``tree-sitter-cli`` explicitly so Neovim 0.12 Treesitter
  parser installs work in both images.
- On Arch, ``fd`` and ``ripgrep`` are installed with ``pacman``.
- On Ubuntu, ``fd`` and ``ripgrep`` are downloaded from upstream GitHub release
  archives.
- ``tree-sitter-cli`` is installed from the upstream release artifact on both
  images.


Neovim Installation
===================

``docker/install-neovim.sh`` installs Neovim from the upstream AppImage release.

How it works:

- Accepts version as argument 1 (default: ``v0.12.1``).
- Accepts optional checksum as argument 2.
- ``latest`` is supported as a special version and is resolved from the GitHub
  releases API.
- If checksum argument 2 is provided, the downloaded file is validated with
  ``sha256sum``.
- The AppImage is installed directly as executable ``/usr/local/bin/nvim``
  without pre-extracting the image during build.
- Docker images set ``APPIMAGE_EXTRACT_AND_RUN=1`` so AppImage execution works
  in container environments without FUSE.

Runtime Orchestration (``docker-compose.yaml``)
================================================

``docker/docker-compose.yaml`` is the runtime layer for the harness. It decides
how the built image is executed for smoke checks and interactive debugging.

Key Compose mechanics
---------------------

The most important behavior in this file is how path and Neovim config
resolution are handled.

- ``working_dir: ${NVIM_CONFIG_DIR:?set NVIM_CONFIG_DIR}``.
- ``volumes: ${NVIM_CONFIG_DIR}:${NVIM_CONFIG_DIR}``.

``${NVIM_CONFIG_DIR:?set NVIM_CONFIG_DIR}`` is Compose variable expansion:

- use ``NVIM_CONFIG_DIR`` when it is set;
- fail fast with ``set NVIM_CONFIG_DIR`` when it is missing or empty.

That variable is plumbed from the top-level wrapper command:

- ``docker/run-workflow.sh`` sets ``NVIM_CONFIG_DIR`` to the repository root
  when the user does not provide one.

When we run ``./docker/run-workflow.sh --workflow smoke-test arch,standard``:

- The script resolves ``NVIM_CONFIG_DIR`` (user-provided value or repository
  root).
- The compose command receives ``NVIM_CONFIG_DIR`` as an environment variable.
- Compose substitutes it into ``working_dir`` and ``volumes``.
- Host and container use the same absolute workspace path.

For smoke tests, the script accepts multiple ``os,profile`` targets and runs the
corresponding services together through one compose invocation.

These two settings intentionally share the same path on host and container.
That keeps ``$PWD`` stable and avoids path-mapping edge cases.

Both smoke and shell entrypoints source ``/opt/nvim-harness/nvim-env.sh``,
which sets:

- ``XDG_CONFIG_HOME="$(dirname "$PWD")"``
- ``NVIM_APPNAME="$(basename "$PWD")"``

before running Neovim (smoke) or launching Bash (shell).

This makes Neovim resolve this mounted directory as the active app config
directory, instead of falling back to ``~/.config/nvim``.

Services and differences
------------------------

All services follow the same wiring pattern (image build, ``TARGET_OS`` profile,
and the same mounted workspace path). They differ only by OS image and runtime
intent.

Smoke tests
~~~~~~~~~~~

Purpose: run non-interactive validation.

Key fields:

- ``command: ["/opt/nvim-harness/smoke.sh", "<target_os>", "<nvim_profile>"]``
  runs the smoke script for the selected OS and Neovim profile.
- ``environment.CC: gcc`` keeps parser/tool compilation available during checks.
- ``TERM``/``COLORTERM`` stay fixed so smoke runs use a stable terminal baseline.

The smoke script runs two stages for every target:

- ``install`` sets ``NVIM_TREESITTER_SYNC_INSTALL=1`` and runs
  ``nvim --headless "+Lazy! restore" +qall`` so first-run plugin and parser
  bootstrap failures stay visible.
- ``launch`` unsets the sync install override and runs
  ``nvim --headless "+doautocmd CmdlineEnter" "+sleep 100m" +qall`` so delayed
  startup errors still fail the workflow.
- Each stage scans the captured log for config, compile, and startup failures
  before reporting success.

This service is designed to fail fast in CI-like local checks.

Interactive tests
~~~~~~~~~~~~~~~~~

Purpose: open an interactive shell for manual debugging and live Neovim use.

Typical workflow:

- Run ``./docker/run-workflow.sh arch,standard``,
  ``./docker/run-workflow.sh ubuntu,standard``, or
  ``./docker/run-workflow.sh ubuntu,minimal``.
- Inside the container shell, run ``nvim``.
- On first start, expect plugin bootstrap/sync via ``lazy.nvim``.
- After plugin setup, expect Treesitter parser installation for configured
  languages.
- Subsequent starts should be much faster once those assets are installed.

Interactive mode accepts exactly one ``os,profile`` target per run.

Interactive shell services preserve the host terminal context instead of forcing
the smoke-test defaults.

- ``TERM`` and ``COLORTERM`` follow the host terminal so Neovim keeps the same
  color capabilities inside the container.
- ``TMUX``, ``TERM_PROGRAM``, ``KITTY_WINDOW_ID``, ``WEZTERM_PANE``, ``ZELLIJ``,
  and ``SSH_TTY`` pass through to preserve terminal-specific behavior.
- Outside tmux, ``NVIM_CLIPBOARD=osc52`` stays enabled for shell services so
  clipboard copy operations can travel back through the host terminal.
- Inside tmux, the interactive harness mounts the live tmux socket directory,
  passes ``TMUX_PANE``, and switches Neovim to a tmux-backed clipboard bridge.
  That path uses tmux buffer commands for copy and paste instead of relying on
  OSC52 passthrough.

For command usage, see :doc:`../how-to/test-in-docker`.

Relevant changelogs
===================

- :ref:`changelog-2026-04-apr-prepare-neovim-0-12-migration`
- :ref:`changelog-2026-02-feb-docker-test-harness`
