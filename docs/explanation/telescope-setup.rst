.. _telescope-setup:

************************
Telescope Setup and Flow
************************

This page explains how ``lua/plugins/expedition/telescope.lua`` resolves
filters, builds runtime state, and wires picker actions and keymaps.

High-level structure
====================

.. code-block:: text

   lua/plugins/expedition/telescope.lua
   |-- filter argument helpers
   |   |-- to_rg_glob_args()
   |   `-- to_fd_exclude_args()
   |-- runtime and action builders
   |   |-- build_telescope_runtime()
   |   `-- create_telescope_actions()
   |-- setup sections
   |   |-- setup_telescope_plugin()
   |   |-- setup_uncategorized_keymaps()
   |   |-- setup_standard_keymaps()
   |   `-- setup_favourite_location_keymaps()
   `-- telescope_setup() as plugin config callback

High-level flow
===============

- The module reads telescope filter settings from ``vvn.profile_config``.
- It builds ``rg`` and ``fd`` command arguments from those filters.
- It creates one runtime context that shares telescope dependencies.
- It registers picker defaults and custom picker actions.
- It applies keymaps in focused groups (general, standard, and favorite paths).

Profile-driven filter wiring
============================

Profile config import
---------------------

.. literalinclude:: ../../lua/plugins/expedition/telescope.lua
   :language: lua
   :lines: 1-3
   :lineno-match:
   :emphasize-lines: 2
   :caption: telescope.lua

The module imports ``vvn.profile_config`` as the source for telescope filter
values.

Filter values into picker commands
----------------------------------

.. literalinclude:: ../../lua/plugins/expedition/telescope.lua
   :language: lua
   :lines: 28-40
   :lineno-match:
   :emphasize-lines: 4,8
   :caption: telescope.lua

The highlighted lines build ``rg`` and ``fd`` command arguments from profile
filter values.

Relevant changelogs
===================

- :ref:`changelog-2026-03-mar-file-nav-pickers`
- :ref:`changelog-2026-02-feb-runtime-config-profiles`
