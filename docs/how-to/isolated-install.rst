.. _isolated-install:

****************
Isolated Install
****************

Use this when you want one config or worktree to run without touching your
default Neovim state.

Use this repo's wrappers
========================

From a worktree under ``~/.config/``, run:

.. code-block:: sh

   ./nvim
   ./nvim-init
   ./nvim-init --reset

The wrappers do four things for you:

- Resolve ``NVIM_APPNAME`` from the worktree path through ``nvim.env``.
- Export ``VVN_NVIM_PROFILE`` with default ``standard``.
- Prefer a repo-local ``nvim-appimage`` and otherwise fall back to
  ``/usr/bin/nvim``.
- Let ``./nvim-init --reset`` remove the app-local data and state directories
  before ``+Lazy! restore`` rebuilds them.

Use ``NVIM_APPNAME`` for another config
=======================================

For Bash, create a small wrapper script:

.. code-block:: sh

   #!/usr/bin/env bash
   NVIM_APPNAME="pvim" /usr/bin/nvim "$@"

For Fish, create a shell function:

.. code-block:: fish

   function pvim
     NVIM_APPNAME="pvim" /usr/bin/nvim $argv
   end

The binary path can be ``/usr/bin/nvim``, a versioned AppImage such as
``~/.local/bin/nvim-v0.12.1``, or another wrapper script.

Try another config
==================

Let us say we want to try `kickstart.nvim`_ without affecting our own setup.

.. _`kickstart.nvim`: https://github.com/nvim-lua/kickstart.nvim

.. code-block:: sh
   :caption: clone to ~/.config/kickstart.nvim

   git clone https://github.com/nvim-lua/kickstart.nvim ~/.config/kickstart.nvim

.. code-block:: fish
   :caption: create kvim

   function kvim
     NVIM_APPNAME="kickstart.nvim" ~/.local/bin/nvim-v0.12.1 $argv
   end

We now have both ``kvim`` and ``nvim`` available to use.
