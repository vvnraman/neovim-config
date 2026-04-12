.. _project-plan:

****
Plan
****

Current active plan
===================

The active project plan is to prepare the config for Neovim 0.12.1 before the host system switches away from the current stable binary.

Active checklist
================

- Keep Treesitter on the Neovim 0.12 ``main`` branch flow and verify parser installs for both ``standard`` and ``minimal`` profiles.
- Keep the Docker Arch and Ubuntu images pinned to ``v0.12.1`` and install ``tree-sitter-cli`` so parser builds work in clean environments.
- Keep smoke tests split between install and launch so delayed plugin failures stay visible.
- Keep interactive shell behavior aligned with the host terminal, including colors and tmux clipboard bridging.
- Keep ``nvim`` and ``nvim-init`` able to prefer a repo-local ``nvim-appimage`` during validation.

Primary verification
====================

- ``./docker/run-workflow.sh --workflow smoke-test arch,standard``
- ``./docker/run-workflow.sh --workflow smoke-test ubuntu,standard``
- ``./docker/run-workflow.sh --workflow smoke-test ubuntu,minimal``
- ``make docs``

Source of truth
===============

- The current rollout checklist is tracked on this page.
- Completed project history is tracked in :ref:`changelog-2026-04-apr-prepare-neovim-0-12-migration`.

Related docs
============

- :ref:`treesitter-setup`
- :ref:`docker-setup`
- :ref:`config-profiles`
- :ref:`test-in-docker`
