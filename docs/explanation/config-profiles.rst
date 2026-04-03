.. _config-profiles:

***************
Config Profiles
***************

Overview
========

We have two runtime profiles to control how Neovim configuration occurs:

- ``standard`` for the full setup behavior.
- ``minimal`` for a lean setup that avoids Neovim-managed external tool
  installs.

Profile resolution
==================

Profile resolution lives in ``lua/vvn/profile.lua``.

We resolve the active profile with this precedence:

1. ``NVIM_PROFILE``
2. ``DOTFILES_PROFILE``
3. ``CODESPACES=true`` implies ``minimal``
4. fallback ``standard``

If a profile value is invalid, we ignore it and continue to the next source.

This gives us three customization points, plus OS/user overlays.

1. Treesitter parser lists
2. Enabled LSP server names
3. Mason package install policy

It also supports plugin specs that are specific to the current OS and user.

Shared lazy plugin root
=======================

``lua/vvn/profile.lua`` also resolves the lazy plugin install root.

- Default: ``stdpath("data") .. "/lazy"``
- Override: ``VVN_NVIM_LAZY_INSTALL_ROOT``

This is useful when multiple worktrees share one plugin checkout set during
config development.

When the override is active, ``init.lua`` uses that directory for:

- the lazy.nvim bootstrap clone
- the lazy plugin install root passed to ``require("lazy").setup()``

Lockfile drift guard
--------------------

Sharing plugin clones does not share ``lazy-lock.json``.

Each Neovim config still keeps its own lockfile under ``stdpath("config")``.
This means ``:Lazy update`` or ``:Lazy sync`` in one config can update the
shared plugin checkout set while also writing a different local lockfile.

To prevent accidental drift, ``lua/autocommands.lua`` blocks ``LazyUpdatePre``
and ``LazySyncPre`` when ``VVN_NVIM_LAZY_INSTALL_ROOT`` points at a non-default
plugin root and ``VVN_NVIM_ALLOW_SHARED_LAZY_UPDATE`` is not ``1``.

When ``VVN_NVIM_ALLOW_SHARED_LAZY_UPDATE=1`` is set, the update proceeds and
Neovim still warns that the shared plugin checkout set can drift from other
configs.

OS and user specific overlays
-----------------------------

.. code-block::

   init.lua
   └─ lazy.nvim spec
      └─ import "plugins.override"
         └─ which calls vvn.profile_config.get_plugin_specs()
            ├─ loads vvn.os-config.plugin_specs
            └─ loads vvn.user-config.plugin_specs

``init.lua`` imports ``plugins.override`` for overlay plugin specs.

``plugins.override`` calls ``vvn.profile_config.get_plugin_specs()`` and
returns one merged plugin spec list to lazy.nvim.

This keeps lazy plugin imports profile-aware while preserving the existing
``NVIM_APPNAME`` worktree behavior.


Telescope filter integration
----------------------------

``lua/vvn/profile_config.lua`` resolves base telescope filters and merges
user overrides from ``vvn.user-config.telescope_filters``.

``lua/plugins/expedition/telescope.lua`` consumes that merged result to build
``rg`` and ``fd`` arguments.

Profile behavior model
======================

Profile specific behavior is centralized in ``lua/vvn/profile_config.lua``.

Because this is centralized, we can change profile behavior without spreading
logic across many plugin files.

LSP integration
---------------

Profile-aware LSP behavior is implemented in ``lua/plugins/pde/lsp.lua``.

- server configs are registered first
- enabled servers are selected from profile config
- Mason installs are optional and profile gated

Treesitter integration
----------------------

Profile-aware Treesitter behavior is implemented in
``lua/plugins/treesitter/config.lua``.

- parser install list is profile driven
- headless smoke runs can force sync install with
  ``NVIM_TREESITTER_SYNC_INSTALL=1``

Mason behavior
--------------

We still use ``mason.nvim``, and install behavior is explicit.

Install flow is gated by both profile policy and
``NVIM_MASON_AUTO_INSTALL=1``.

This is important for ``minimal`` because we can validate startup and baseline
editing behavior without Neovim trying to install servers.

The profile setup does not use:

- ``mason-lspconfig.nvim``
- ``mason-tool-installer.nvim``

Plugin specs
------------

Profile-aware plugin spec behavior is implemented in
``lua/vvn/profile_config.lua``.

Overlay plugin specs resolve through:

- ``vvn.os-config.plugin_specs``
- ``vvn.user-config.plugin_specs``

``get_plugin_specs()`` merges base profile specs with OS and user overlays and
returns one list to ``plugins.override``.

Future change checklist
=======================

When we add or change language support, we should update profiles in this order:

1. Update server config in ``lua/plugins/pde/lsp.lua``.
2. Decide whether the server belongs in ``standard`` only, or in both
   ``standard`` and ``minimal``.
3. If it should auto-install, add the Mason package name in
   ``lua/vvn/profile_config.lua``.
4. Run Docker smoke checks for both profiles to confirm behavior still matches
   expectations.

When we change profile defaults, we should keep ``minimal`` conservative and
add things there only when they are essential to baseline editing.

This gives us a stable place to evolve the config without losing clarity about
what each profile is supposed to do.

Relevant changelog
------------------

- :ref:`changelog-2026-04-apr-shared-lazy-root`
- :ref:`changelog-2026-03-mar-vvn-overlay-imports`
- :ref:`changelog-2026-03-mar-file-nav-pickers`
