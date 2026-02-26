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

Profile behavior model
======================

Profile specific behavior is centralized in ``lua/vvn/profile_config.lua``.

Right now we control:

- Treesitter parser lists
- Enabled LSP server names
- Mason package install policy

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

We still use ``mason.nvim``, but install behavior is now explicit.

Install flow is gated by both profile policy and
``NVIM_MASON_AUTO_INSTALL=1``.

This is important for ``minimal`` because we can validate startup and baseline
editing behavior without Neovim trying to install servers.

We removed:

- ``mason-lspconfig.nvim``
- ``mason-tool-installer.nvim``

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
