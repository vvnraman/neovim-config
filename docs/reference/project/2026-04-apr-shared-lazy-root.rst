.. _changelog-2026-04-apr-shared-lazy-root:

*******************************************
2026-04 apr - add shared lazy root guard
*******************************************

2026-04-03 - Friday
===================

Added an opt-in shared lazy plugin root with a guard for lockfile-changing updates.

Change summary
--------------

- ``lua/vvn/profile.lua`` resolves ``VVN_NVIM_LAZY_INSTALL_ROOT`` and the
  explicit shared-update override.
- ``init.lua`` bootstraps ``lazy.nvim`` and plugin installs from the resolved
  lazy root.
- ``lua/autocommands.lua`` blocks ``:Lazy update`` and ``:Lazy sync`` for a
  shared lazy root unless ``VVN_NVIM_ALLOW_SHARED_LAZY_UPDATE=1`` is set.

Related docs
------------

- :ref:`config-profiles`
