**********************************
Prateek's ``Neovim`` configuration
**********************************

These are kept in sync with my `dotfiles`_. The ``dotfiles`` are managed using
`chezmoi`_.

The ``Neovim`` configuration here is extracted out for trying it out on other
platforms, without necesarily depending upon the rest of my ``dotfiles``.

.. _dotfiles: https://github.com/vvnraman/dotfiles
.. _chezmoi: https://github.com/twpayne/chezmoi

----

How to install Neovim AppImage on Linux
=======================================

Assumes github release link
https://github.com/neovim/neovim/releases/download/v0.9.4/nvim.appimage

.. code-block:: sh

   # download
   mkdir -p ~/downloads/neovim/v0.9.4/
   cd ~/downloads/neovim/v0.9.4/
   curl --fail --location --remote-name https://github.com/neovim/neovim/releases/download/stable/nvim.appimage

   # verify
   sha256sum nvim.appimage
   # compare the sha256 checksum by copying it and CTRL+F on the release page.

   # install
   chmod +x nvim.appimage
   sudo cp nvim.appimage /usr/bin/nvim

----

How to try this config non-intrusively
======================================

The instructions below apply to a **linux** environment. Using them will not
interfere with an existing Neovim setup. Its uses the builtin ``Neovim``
feature ``$NVIM_APPNAME``
https://neovim.io/doc/user/starting.html#%24NVIM_APPNAME.

Pre-requisites
--------------

`ripgrep`_ and `fd`_ are installed on the system

.. _ripgrep: https://github.com/BurntSushi/ripgrep
.. _fd: https://github.com/sharkdp/fd

Assumptions
-----------

1. ``~/.local/bin/`` already exists in user's $PATH
2. Neovim executable is present at ``/usr/bin/nvim`` (see previous section)

If these assumptions are not met, one can alter the instructions as needed.

Steps
-----

1. Clone this repo at ``~/.config/pvim``

   .. code-block:: sh

      git clone https://github.com/vvnraman/neovim-config ~/.config/pvim

2. Create a file ``~/.local/bin/pvim`` and mark it executable

   .. code-block:: sh

      mkdir -p ~/.local/bin/
      touch ~/.local/bin/pvim
      chmod +x ~/.local/bin/pvim

3. Add the following contents to ``~/.local/bin/pvim``
 
   .. code-block:: sh

      #/usr/bin/env bash
      NVIM_APPNAME=pvim /usr/bin/nvim $@

4. Run ``pvim``

----

