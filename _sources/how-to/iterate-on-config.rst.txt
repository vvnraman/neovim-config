.. _iterate-on-config:

*****************
Iterate on config
*****************

When making changes which will likely break the config temporarily, use ``git
worktrees`` to keep both the current version and the in-flux version available
for use.

This is also the default setup, where the config is cloned as a bare repo at
``~/.config/neovim-config.git/bare``.

.. code-block:: sh

   git clone github:vvnraman/neovim-config.git --bare ~/.config/neovim-config.git/bare
   cd ~/.config/neovim-config.git/bare
   git worktree add ~/.config/nvim dev
   git worktree add ~/.config/neovim-config.git/master master

The active branch is checked out at ``~/.config/nvim``, in this case the
``dev`` branch.

Making minimal changes
======================

During steady state, when no changes are happening, or minimal changes are
being made.

.. code-block:: sh

   cd ~/.config/nvim
   git switch -c spring-clean

Major refactoring
=================

First make sure ``master`` is available as an alternate config, before doing any
refactor.

* Make sure no uncommitted changes are present in ``~/.config/nvim``

  .. code-block:: sh

     cd ~/.config/nvim
     git status

* Make sure ``master`` is checked out at ``~/.config/neovim-config.git/master``
  (add it if missing)

  .. code-block:: sh

     cd ~/.config/neovim-config.git/bare
     git worktree list
     git worktree add ~/.config/neovim-config.git/master master

* Make an ``mvim`` function (``m`` for ``master`` branch)

  .. tabs::

     .. group-tab:: Bash

         .. code-block:: bash
            :caption: ~/.bashrc

            function mvim {
              ~/.config/neovim-config.git/master/nvim "$@"
            }

     .. group-tab:: Fish

         .. code-block:: fish
            :caption: ~/.config/fish/config.fish

            function mvim
              ~/.config/neovim-config.git/master/nvim $argv
            end

  Using the worktree-local wrapper keeps ``NVIM_APPNAME`` tied to that worktree
  and automatically picks up a local ``nvim-appimage`` if present.

* Create a new worktree for the refactor branch and leave ``~/.config/nvim``
  (``dev``) untouched

  .. code-block:: sh

     cd ~/.config/neovim-config.git/bare
     git worktree add -b holiday-update ~/.config/neovim-config.git/holiday-update dev

* Do the refactor in ``~/.config/neovim-config.git/holiday-update``

* Validate changes using :doc:`test-in-docker`

* Fast-forward merge ``holiday-update`` into ``dev`` once satisfied

  .. code-block:: sh

     cd ~/.config/nvim
     git status
     git merge-base --is-ancestor dev holiday-update
     git merge --ff-only holiday-update

* Remove temporary refactor worktree and branch after merge

  .. code-block:: sh

     cd ~/.config/neovim-config.git/bare
     git worktree remove ~/.config/neovim-config.git/holiday-update
     git branch -d holiday-update
