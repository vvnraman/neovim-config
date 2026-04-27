.. _changelog-2026-02-feb-miscellaneous-updates:

**************************
2026 Miscellaneous changes
**************************

Any set of changes which do not need a dedicated page go here.

2026-02
=======

Telescope search updates
------------------------

- Reworked Telescope file-search command setup in
  ``lua/plugins/expedition/telescope.lua`` so ``rg`` and ``fd`` exclusions are
  centralized and reused.

- Updated exclusions to consistently skip nested metadata locations:
  ``.git/``, Obsidian's ``.obsidian/``, and Dropbox cache/state paths.

- Made the ``rg`` exclusion paths derive from ``$HOME`` (via relative path
  normalization), so the same config works across different machines.

- Fixed favorite-directory keymaps to use expanded absolute paths, which makes
  recursive lookups stable for ``find_files`` and ``live_grep``.

Plugin management and load updates
----------------------------------

- Switched ``lazy.nvim`` setup in ``init.lua`` to use ``spec = { import = ... }``
  imports and enabled ``defaults.version = "*"``.

- Added placeholder import groups for OS/user overlays:
  ``plugins.os-config`` and ``plugins.user-config``.

Plugin changes
--------------

Removed
^^^^^^^

- Removed snippet stack from Neovim completion setup:

  - ``L3MON4D3/LuaSnip``
  - ``saadparwaiz1/cmp_luasnip``
  - ``rafamadriz/friendly-snippets``
