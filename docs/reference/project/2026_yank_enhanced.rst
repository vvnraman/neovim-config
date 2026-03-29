.. _changelog-2026-02-feb-yank-enhanced-module:

******************
2026 Yank enhanced
******************

2026-02
=======

This update introduces a dedicated yank module for path, line-range, and
diagnostic-aware clipboard workflows.

Overview
--------

- Added ``lua/vvn/yank.lua`` and wired setup from ``init.lua`` via
  ``require("vvn.yank").setup()``.

- Added shared helpers in ``lua/vvn/util.lua`` for clipboard operations, visual
  mode checks, relative path resolution, and command option parsing.

- Moved line-diagnostics clipboard helpers out of ``lua/plugins/pde/lsp.lua``
  into the new yank module.

Detailed behavior, keymaps, and command usage are documented at
:ref:`yank-enhanced`.
