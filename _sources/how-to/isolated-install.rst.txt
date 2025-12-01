.. _isolated-install:

****************
Isolated Install
****************

This uses 2 techniques to use a neovim version with a specific config without
conflicting with whatever our current stable setup is:

* Using symlinks to manage ``nvim`` versions.

  See **Install using symlinks** step in :ref:`install-nvim` page on how we
  install a versioned binary.

* Using ``Neovim``'s built-in ``$NVIM_APPNAME`` feature to isolate
  configurations as we iterate on our own config's, or try out new configs.

``$NVIM_APPNAME``
-----------------

Neovim executable is present at ``/usr/bin/nvim``

*  For ``bash``, assumes ``~/.local/bin/`` already exists in user's `$PATH`

   Create a file ``~/.local/bin/pvim`` and mark it executable

   .. code-block:: console

      mkdir -p ~/.local/bin/
      touch ~/.local/bin/pvim
      chmod +x ~/.local/bin/pvim

   Add the following contents to ``~/.local/bin/pvim``

   .. code-block:: sh

      #/usr/bin/env bash
      NVIM_APPNAME=pvim /usr/bin/nvim $@


*  For `fish`

   Create a function inside `~/.config/fish/config.fish`

   .. code-block:: fish

      function pvim
        NVIM_APPNAME="pvim" /usr/bin/nvim $argv
      end

The path to ``nvim`` above could also be to a versioned binary, when we
migrating from one version to another and do not want to break our existing
setup.

.. code-block:: sh

   /usr/bin/nvim-v0.11.5

Another example using ``kickstart.nvim``
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Let us say we want to try `kickstart.nvim`_ without affecting our own setup.

.. _`kickstart.nvim`: https://github.com/nvim-lua/kickstart.nvim

We'll only show the :program:`fish` variant, :program:`bash` can be adapted in
a similar fashion.

.. code-block:: sh
   :caption: clone to `~/.config/kickstart.nvim`

   git clone https://github.com/nvim-lua/kickstart.nvim ~/.config/kickstart.nvim

.. code-block:: fish
   :caption: create `kvim` function to use it

   function kvim
     # Use the minimal `kickstart.nvim` distro with a specific binary version
     NVIM_APPNAME="kickstart.nvim" /usr/bin/nvim_0.11.5 $argv
   end

We now have both :program:`kvim` and :program:`nvim` available to use.

