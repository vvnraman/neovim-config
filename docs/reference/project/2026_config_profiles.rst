.. _changelog-2026-02-feb-runtime-config-profiles:

********************
2026 Config profiles
********************

2026-02
=======

We have added runtime profiles so we can run the same Neovim config in two
clear modes: ``standard`` and ``minimal``.

The goal is to make behavior intentional, especially around tool installation.
In ``minimal`` we do less LSP and Treesitter setup, but the main rule is that
Neovim should not install external tools for LSP, linting, or formatting. We
assume a higher-level orchestration layer has already made those tools
available out of band.

For profile-oriented validation runs in Docker, see
:ref:`test-in-docker`.

Detailed profile resolution, integration behavior, and future update checklist
are documented at :ref:`config-profiles`.
