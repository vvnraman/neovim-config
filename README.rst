***************************
Prateek's ``Neovim`` config
***************************

These are kept in sync with my `dotfiles`_. The ``dotfiles`` are managed using
`chezmoi`_.

Visit the `generated-docs`_ page to learn more.

.. _`generated-docs`: https://vvnraman.github.io/neovim-config/

Keymaps are documented at `keymaps-reference`_.

.. _`keymaps-reference`: https://vvnraman.github.io/neovim-config/reference/keymaps.html

Generated via our ``:GenerateKeymapDocs`` user command from within Neovim.

----

The ``Neovim`` configuration here is extracted out for trying it out on other
platforms, without necesarily depending upon the rest of my ``dotfiles``.

.. _dotfiles: https://github.com/vvnraman/dotfiles
.. _chezmoi: https://github.com/twpayne/chezmoi

----

Install Neovim AppImage on Linux
================================

Visit `install-neovim`_ to see how I do this.

.. _`install-neovim`: https://vvnraman.github.io/neovim-config/how-to/install-neovim.html

How to try this config non-intrusively
======================================

Visit `isolated-install`_ page to see how to do this.

.. _`isolated-install`: https://vvnraman.github.io/neovim-config/how-to/isolated-install.html

----

***********************
python project workflow
***********************

This is also a python project for generating docs, publish to github pages,
etc..

- ``uv sync`` to install python dependencies for generating docs.

  Run ``uv run nvim-config --help`` to see available commands

- ``make docs``

  Runs ``uv run nvim-config docs`` to genrate docs

- ``make live``

  Runs ``uv run nvim-config live`` to for live docs as we're updating them.
