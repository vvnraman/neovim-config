.. _changelog-2026-03-mar-vvn-util-modules:

***************************************************
2026-03 mar - refactor shared vvn helper modules
***************************************************

2026-03-29 - Sunday
===================

Moved path, git, and buffer helpers into dedicated ``lua/vvn`` utility modules.

Change summary
--------------

- Added ``vvn.pathutil``, ``vvn.gitutil``, and ``vvn.bufutil`` modules with
  typed helper APIs for path resolution, git root detection, and buffer/window
  targeting.
- Updated ``vvn.util``, ``vvn.yank``, ``lua/keymaps.lua``, and
  ``lua/plugins/session.lua`` to use module helpers instead of global helper
  functions.
- Removed ``lua/vvn/path.lua`` and the global ``GET_CURRENT_LINE`` /
  ``GET_CURRENT_FILE_PATH`` helpers from ``lua/globals.lua``.

Related docs
------------

- :ref:`yank-enhanced`
