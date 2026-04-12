.. _treesitter-setup:

*********************
Treesitter Setup Flow
*********************

This page explains how the Treesitter setup resolves parser lists, loads the
plugins, and installs parsers during headless bootstrap runs.

High-level structure
====================

.. code-block:: text

   lua/plugins/treesitter/config.lua
   |-- get_ensure_installed()
   |-- ensure_treesitter_parsers()
   `-- setup_treesitter()

   lua/vvn/profile_config.lua
   `-- get_treesitter_ensure_installed()

High-level flow
===============

- ``vvn.profile`` resolves the active profile from ``VVN_NVIM_PROFILE`` or
  ``VVN_DOTFILES_PROFILE``.
- ``vvn.profile_config`` returns the parser list for that profile.
- ``setup_treesitter()`` sets up ``nvim-treesitter``, starts Treesitter for
  loaded buffers, and enables the textobject mappings.
- Headless bootstrap runs can wait for parser installation with
  ``NVIM_TREESITTER_SYNC_INSTALL=1``.

Plugin load model
=================

.. literalinclude:: ../../lua/plugins/treesitter/config.lua
   :language: lua
   :lines: 160-175
   :lineno-match:
   :emphasize-lines: 4,5,8,10,14,15
   :caption: config.lua

``nvim-treesitter`` and ``nvim-treesitter-textobjects`` both load eagerly, and
both use the ``main`` branch.

Headless parser install flow
============================

.. literalinclude:: ../../lua/plugins/treesitter/config.lua
   :language: lua
   :lines: 133-147
   :lineno-match:
   :emphasize-lines: 4,9,14
   :caption: config.lua

The install helper skips empty parser lists, requests the configured parsers,
and waits only when the caller set ``NVIM_TREESITTER_SYNC_INSTALL=1``.

Relevant changelogs
===================

- :ref:`changelog-2026-04-apr-prepare-neovim-0-12-migration`
- :ref:`changelog-2026-02-feb-runtime-config-profiles`
