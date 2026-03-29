.. _docker-setup:

*******************
Docker Test Harness
*******************

There is a Docker harness under ``docker/`` to validate and debug the Neovim
config in a reproducible environment.

At a high level, the flow is:

1. Build an image from an OS-specific ``Dockerfile``.
2. Build a ``base`` stage for OS packages, then a ``runtime`` stage for harness
   scripts and Neovim/tool installation.

3. Install Neovim from the upstream AppImage release via
   ``docker/install-neovim.sh``.

   - AppImage lets us pin an exact Neovim version independent of the version
     available from the OS package manager.

4. Install CLI search tools via ``docker/install-cli-tools.sh``:

   - Arch installs ``fd`` and ``ripgrep`` with ``pacman``.
   - Ubuntu installs ``fd`` and ``ripgrep`` from upstream GitHub release
     archives.

Neovim checksum verification is optional in the installer script. It runs only
when a checksum value is passed as argument 2.

Version defaults for Neovim/``fd``/``ripgrep`` are centralized in
``docker/docker-compose.yaml`` build args and can be overridden through
environment variables.
4. Run either:

   - a headless smoke check (``arch-smoke``, ``ubuntu-smoke``, or
     ``ubuntu-smoke-minimal``), or
   - an interactive shell session (``arch-shell``, ``ubuntu-shell``, or
     ``ubuntu-shell-minimal``).

The harness points Neovim at our actual checkout (not a copied config), so
image runs and interactive sessions validate the same files we are editing.


CLI Tool Installation
=====================

``docker/install-cli-tools.sh`` is the single entrypoint for ``fd`` and
``ripgrep`` installation.

How it works:

- Accepts ``target_os`` as argument 1 (``arch`` or ``ubuntu``).
- Accepts repeatable ``--tool 'tool-name:tool-version'`` flags.
- Supported tools are ``fd`` and ``ripgrep``.
- ``tool-version`` can be a pinned version or ``latest``.
- If no ``--tool`` flags are passed, defaults are used for both tools.
- On Arch, tools are installed with ``pacman``.
- On Ubuntu, tools are downloaded from GitHub release archives.


Neovim Installation
===================

``docker/install-neovim.sh`` installs Neovim from the upstream AppImage release.

How it works:

- Accepts version as argument 1 (default: ``v0.11.6``).
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
corresponding services in parallel via one compose command.

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
- ``TERM``/``COLORTERM`` set a stable terminal baseline for Neovim runtime.

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

For command usage, see :doc:`../how-to/test-in-docker`.
