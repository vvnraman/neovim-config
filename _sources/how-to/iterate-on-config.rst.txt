.. _iterate-on-config:

*****************
Iterate on config
*****************

When making changes which will likely break the config temorarily, use ``git
worktrees`` to keep both the current version and the in-flux version available
for use.

This is also the default setup, where the config is cloned as a bare repo at
``~/.config/neovim-config.git``.

.. code-block:: sh

   git clone github:vvnraman/neovim-config.git --bare ~/.config/neovim-config.git
   cd ~/.config/neovim-config.git
   git worktree add ~/.config/nvim master

The active branch is checked out at ``~/.config/nvim``, in this case the
``master`` branch.

Making minimal changes
======================

During steady state, when no changes are happening, or minimal changes are
being made.

.. code-block:: sh

   cd ~/.config/nvim
   git checkout -b spring-clean

Major refactoring
=================

First make ``master`` available as an alternate config, before doing any refactor.

* Make sure no uncommitted changes are present in ``~/.config/nvim``

  .. code-block:: sh

     cd ~/.config/nvim
     git status

* Move ``master`` to ``~/.config/neovim-config.git/master``

  .. code-block:: sh

     cd ~/.config/neovim-config.git
     git worktree remove ~/.config/nvim
     git worktree add master

* Make an ``mvim`` alias (``m`` for ``master`` branch)

  .. code-block:: fish
     :caption: ~/.config/fish/config.fish

     function mvim
       # Use the master branch of my config with the current version
       NVIM_APPNAME="neovim-config.git/master" /usr/bin/nvim $argv
     end

  This should already be setup in my ``fish`` config.

* Checkout new branch at ``~/.config/nvim`` for making changes

  .. code-block:: sh

     cd ~/.config/neovim-config.git
     git worktree add -b holiday-update ~/.config/nvim
