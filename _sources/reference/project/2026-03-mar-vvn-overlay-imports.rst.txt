.. _changelog-2026-03-mar-vvn-overlay-imports:

*********************************************
2026-03 mar - move overlay imports under vvn
*********************************************

2026-03-29 - Sunday
===================

Moved OS and user lazy overlay import resolution into ``lua/vvn`` profile modules.

Change summary
--------------

- ``init.lua`` now imports ``plugins.override`` for overlay plugin specs.
- ``plugins.override`` resolves overlays via ``vvn.profile_config`` and
  ``vvn.os-config``/``vvn.user-config`` modules.
- ``nvim`` and ``nvim-init`` continue to resolve ``NVIM_APPNAME`` from the
  worktree path, and ``nvim-init`` now supports ``--reset`` for app-local data
  and state cleanup.

Related docs
------------

- :ref:`config-profiles`
