.. _changelog-2026-04-apr-prepare-neovim-0-12-migration:

*************************************************
2026-04 apr - prepare neovim 0.12 migration
*************************************************

2026-04-12 - Sunday
===================

Prepared the config and docs for a Neovim 0.12.1 rollout without replacing the host binary first.

Change summary
--------------

- Moved Treesitter to the Neovim 0.12 ``main`` branch flow in ``lua/plugins/treesitter/config.lua`` and kept profile parser lists aligned with that setup.
- Updated the Docker harness to pin Neovim ``v0.12.1``, install ``tree-sitter-cli``, split smoke runs into install and launch stages, and preserve colors plus tmux clipboard behavior in interactive shells.
- Standardized runtime profile selection on ``VVN_NVIM_PROFILE`` and ``VVN_DOTFILES_PROFILE`` across wrappers, Docker scripts, and docs.
- Updated ``nvim`` and ``nvim-init`` to prefer a repo-local ``nvim-appimage`` when present so worktrees can validate new Neovim releases before the system binary changes.
- Refreshed the related docs for Treesitter, Docker validation, isolated installs, and worktree iteration.

Related docs
------------

- :ref:`treesitter-setup`
- :ref:`docker-setup`
- :ref:`config-profiles`
- :ref:`test-in-docker`
- :ref:`install-nvim`
- :ref:`isolated-install`
- :ref:`iterate-on-config`
- :ref:`project-plan`
