.. _install-nvim:

**************
Install Neovim
**************

Install Neovim AppImage on Linux
================================

This is the preferred release artifact for me on linux. I've been using it for
5+ years without any issues on Ubuntu, Red Hat 7 and 8, CentOs.

Assuming github release link
https://github.com/neovim/neovim/releases/download/v0.11.5/nvim-linux-x86_64.appimage

* Download appimage from github

  .. code-block:: sh

     export nvim_version="stable"
     # or nvim_version="v0.11.5"
     # download
     mkdir -p ~/downloads/nvim/"${nvim_version}"
     cd ~/downloads/nvim/"${nvim_version}"/
     curl --fail --location --remote-name https://github.com/neovim/neovim/releases/download/"${nvim_version}"/nvim-linux-x86_64.appimage
  
* Verify checksum

  .. code-block:: sh

     sha256sum nvim-linux-x86_64.appimage
     # compare the sha256 checksum by copying it and CTRL+F on the release page.
  
* Install using symlinks

  .. code-block:: sh

     chmod +x nvim-linux-x86_64.appimage
     sudo cp nvim-linux-x86_64.appimage "/usr/bin/nvim-${nvim_version}"
     sudo ln -s /usr/bin/nvim "/usr/bin/nvim-${nvim_version}"
