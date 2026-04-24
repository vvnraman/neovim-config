.. _test-in-docker:

**************
Test in Docker
**************

See :ref:`docker-setup`.

Smoke test workflow
===================

Run smoke tests first when you want reproducible pass/fail output.

.. code-block:: sh

   ./docker/run-workflow.sh --workflow smoke-test arch,standard
   ./docker/run-workflow.sh --workflow smoke-test ubuntu,standard
   ./docker/run-workflow.sh --workflow smoke-test ubuntu,minimal
   ./docker/run-workflow.sh --workflow smoke-test arch,standard ubuntu,standard ubuntu,minimal

Smoke workflow notes:

- The ``install`` stage runs ``+Lazy! restore`` with
  ``NVIM_TREESITTER_SYNC_INSTALL=1``.
- The ``launch`` stage reopens Neovim and triggers ``CmdlineEnter`` to catch
  delayed startup errors.
- Smoke mode can run multiple ``os,profile`` targets in one command.

Interactive workflow
====================

Use interactive mode when you need to inspect colors, clipboard behavior, or
plugin UI manually.

.. code-block:: sh

   ./docker/run-workflow.sh arch,standard
   ./docker/run-workflow.sh ubuntu,standard
   ./docker/run-workflow.sh ubuntu,minimal

.. code-block:: sh

   make docker-shell-arch
   make docker-shell-ubuntu
   make docker-shell-ubuntu-minimal

Inside the container shell, run ``nvim``.

Operational notes
=================

- Interactive mode accepts exactly one ``os,profile`` target per run.
- Shell services reuse the current worktree through ``NVIM_APPNAME``, so
  ``nvim`` reads the same files you are editing.
- Containers run as the current host user, so files written into the mounted
  worktree keep host ownership.
- Host ``TERM`` and ``COLORTERM`` pass through for interactive shells.
- When launched from tmux, the harness mounts the live tmux socket and uses a
  tmux-backed clipboard bridge.
- Outside tmux, the shell harness keeps ``NVIM_CLIPBOARD=osc52``.
