.. _install-nvim:

**************
Install Neovim
**************

Test a new AppImage in this repo
================================

Use this when you want to validate a new Neovim release in the current
worktree before replacing ``/usr/bin/nvim``.

.. code-block:: sh

   cd ~/.config/neovim-config.git/v0.12
   curl --fail --location \
     --output nvim-appimage \
     https://github.com/neovim/neovim/releases/download/v0.12.1/nvim-linux-x86_64.appimage
   chmod +x nvim-appimage
   ./nvim --version
   ./nvim-init
   ./nvim --headless "+checkhealth" +qa

The repo-local ``./nvim`` and ``./nvim-init`` wrappers prefer
``./nvim-appimage`` when it exists and otherwise fall back to ``/usr/bin/nvim``.

Use ``./nvim-init --reset`` only when you want to remove the app-local data and
state directories for that worktree before rebuilding them.

Keep a standalone AppImage binary
=================================

Use this when you want an explicit Neovim binary outside the repo wrappers.

.. code-block:: sh

   export nvim_version="v0.12.1"
   mkdir -p ~/downloads/nvim/"${nvim_version}"
   cd ~/downloads/nvim/"${nvim_version}"
   curl --fail --location \
     --output nvim-linux-x86_64.appimage \
     "https://github.com/neovim/neovim/releases/download/${nvim_version}/nvim-linux-x86_64.appimage"
   sha256sum nvim-linux-x86_64.appimage
   chmod +x nvim-linux-x86_64.appimage
   install -m 0755 nvim-linux-x86_64.appimage ~/.local/bin/nvim-v0.12.1

This keeps the binary versioned and explicit. Use :ref:`isolated-install` when
you want to pair that binary with a separate ``NVIM_APPNAME`` config.
