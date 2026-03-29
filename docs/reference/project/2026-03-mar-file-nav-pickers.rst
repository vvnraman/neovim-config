.. _changelog-2026-03-mar-file-nav-pickers:

**********************************************
2026-03 mar - refine file-nav and lsp pickers
**********************************************

2026-03-29 - Sunday
===================

Refined telescope, oil, and snacks picker behavior for faster file navigation and clearer previews.

Change summary
--------------

- Refactored ``lua/plugins/expedition/telescope.lua`` into smaller runtime/action setup helpers and added picker actions for copying selected entries and opening buffers in existing windows.
- Updated ``lua/plugins/expedition/rucking.lua`` oil float behavior so preview toggles can resize and keep preview readability consistent.
- Tuned LSP picker and snacks preview transparency in ``lua/plugins/pde/attach.lua`` and ``lua/plugins/snacks.lua`` with profile-aware telescope filter resolution via ``vvn.profile_config`` + ``vvn.user-config.telescope_filters``.

Related docs
------------

- :ref:`config-profiles`
