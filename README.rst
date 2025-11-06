***************************
Prateek's ``Neovim`` config
***************************

These are kept in sync with my `dotfiles`_. The ``dotfiles`` are managed using
`chezmoi`_.

The ``Neovim`` configuration here is extracted out for trying it out on other
platforms, without necesarily depending upon the rest of my ``dotfiles``.

.. _dotfiles: https://github.com/vvnraman/dotfiles
.. _chezmoi: https://github.com/twpayne/chezmoi

----

Pre-requisites
==============

`ripgrep`_ and `fd`_ are installed on the system

* `ripgrep`_ - ``grep`` replacement

* `fd`_ - ``find`` replacement

.. _ripgrep: https://github.com/BurntSushi/ripgrep
.. _fd: https://github.com/sharkdp/fd

----

Install Neovim AppImage on Linux
================================

Assumes github release link
https://github.com/neovim/neovim/releases/download/v0.11.5/nvim-linux-x86_64.appimage

.. code-block:: sh

   nvim_version="stable"
   # or nvim_version="v0.11.5"
   # download
   mkdir -p ~/downloads/nvim/"${nvim_version}"
   cd ~/downloads/nvim/"${nvim_version}"/
   curl --fail --location --remote-name https://github.com/neovim/neovim/releases/download/"${nvim_version}"/nvim-linux-x86_64.appimage

   # verify
   sha256sum nvim-linux-x86_64.appimage
   # compare the sha256 checksum by copying it and CTRL+F on the release page.

   # install
   chmod +x nvim-linux-x86_64.appimage
   sudo cp nvim-linux-x86_64.appimage "/usr/bin/nvim-${nvim_version}"
   sudo ln -s /usr/bin/nvim "/usr/bin/nvim-${nvim_version}"

----

How to try this config non-intrusively
======================================

The instructions below apply to a **linux** environment. Using them will not
interfere with an existing Neovim setup. Its uses the builtin ``Neovim``
feature ``$NVIM_APPNAME``
https://neovim.io/doc/user/starting.html#%24NVIM_APPNAME.

Assumptions
-----------

1. Neovim executable is present at ``/usr/bin/nvim`` (see previous section)

2. `bash` - ``~/.local/bin/`` already exists in user's `$PATH`

   `fish` - We'll use a fish function instead

If these assumptions are not met, one can alter the instructions as needed.

Steps
-----

1. Clone this repo at ``~/.config/pvim``

   .. code-block:: sh

      git clone https://github.com/vvnraman/neovim-config ~/.config/pvim

2. For `bash`

   Create a file ``~/.local/bin/pvim`` and mark it executable

   .. code-block:: sh

      mkdir -p ~/.local/bin/
      touch ~/.local/bin/pvim
      chmod +x ~/.local/bin/pvim

   Add the following contents to ``~/.local/bin/pvim``
   .. code-block:: sh

      #/usr/bin/env bash
      NVIM_APPNAME=pvim /usr/bin/nvim $@
 

3. For `fish`

   Create a function inside `~/.config/fish/config.fish`

   .. code-block:: fish

      function pvim
        NVIM_APPNAME="pvim" /usr/bin/nvim $argv
      end

4. Run ``pvim``
