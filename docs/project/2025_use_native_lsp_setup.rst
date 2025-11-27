*************************
2025 Use native lsp setup
*************************

2025 November
=============

Migrate to new lsp config
-------------------------

``require('lspconfig')`` is deprecated in favour of ``vim.lsp.config()``

* See ``:help lspconfig-nvim-0.11``.

* Read about it at https://neovim.io/doc/user/lsp.html#lsp-config

* gpanders blog: https://gpanders.com/blog/whats-new-in-neovim-0-11/#lsp

* Reddit: https://www.reddit.com/r/neovim/comments/1nmh99k/beware_the_old_nvimlspconfig_setup_api_is/

We should not use the regular ``on_attach`` setting as it will overwrite the
default config we get from ``nvim-lspconfig``. As per the help docs, we should
use the `LspAttach`_ event and do the buffer specific mappings in this
callback.

.. _`LspAttach`: https://neovim.io/doc/user/lsp.html#lsp-attach

See the reference :ref:`lsp_attach` output to see the shape of data
we can operate on in this callback.

There is no longer a need to use ``neovim/nvim-lspconfig`` plugin at all. It is
a data only plugin at this point. However those changes are better made
separately.

``nvim-0.11`` defaults
^^^^^^^^^^^^^^^^^^^^^^

For now we'll be referencing ``nvim-lua/kickstart.nvim`` LSP configuration to
update our lsp config. It does use the new ``LspAttach`` method but it still
does not have ``vim.lsp.config()`` and ``vim.lsp.enable()`` use.

We'll also get rid of the current structure of having ``clangd`` and ``lua_ls``
setup be done separately at ``{runtimepath}/lua/plugins/lsp/*.lua``.

From ``:help lsp-defaults``, these GLOBAL keymaps are created unconditionally when Nvim starts:

* ``grn`` is mapped in Normal mode to ``vim.lsp.buf.rename()``

* ``gra`` is mapped in Normal and Visual mode to ``vim.lsp.buf.code_action()``

* ``grr`` is mapped in Normal mode to ``vim.lsp.buf.references()``

* ``gri`` is mapped in Normal mode to ``vim.lsp.buf.implementation()``

* ``grt`` is mapped in Normal mode to ``vim.lsp.buf.type_definition()``

* ``gO`` is mapped in Normal mode to ``vim.lsp.buf.document_symbol()``

* ``CTRL-S`` is mapped in Insert mode to ``vim.lsp.buf.signature_help()``

We'll be keeping our own keymaps as well, at least for now.

----

``clangd``
^^^^^^^^^^

Instead of having configuration specific to a language server, the
customization will occur on the basis of the extended LSP feature we get from
``clangd``, inside the common ``LspAttach`` event handler. ``clangd`` supports
a bunch of `protocol extensions`_ not present in the official `LSP spec`_. The
handling for these come from ``p00f/clangd_extensions.nvim`` plugin at
`clangd_extensions.nvim`_.

.. _`protocol extensions`: https://clangd.llvm.org/extensions
.. _`LSP spec`: https://microsoft.github.io/language-server-protocol/specification
.. _`clangd_extensions.nvim`: https://github.com/p00f/clangd_extensions.nvim

We can encapsulate the config and the method handling in the
``plugins/lsp/clangd.lua`` module and use them in the event handler in
``plugins/lsp/lsp.lua`` module.

I'm currently using ``client.server_info.name`` to setup the customizations, inside the ``LspAttach`` event handler. Perhaps there is a different way.

.. code-block:: lua
   :caption: clangd custom setup

   if "clangd" == client.server_info.name then
     log.info("Setting up clangd extensions")
     require("plugins.lsp.attach").setup_clangd_extensions(bufnr)
   end

User commands from ``p00f/clangd_extensions.nvim``
""""""""""""""""""""""""""""""""""""""""""""""""""

#. ``ClangdAST``

#. ``ClangdTypeHierarchy``

#. ``ClangdSymbolInfo``

#. ``ClangdMemoryUsage``

#. ``ClangdSwitchSourceHeader``

The only two protocol extensions for ``clangd`` which had some handling code in
``nvim-lspconfig`` are shown below. They weren't being used before in our
config anyways.

#. ``textDocument/switchSourceHeader``

#. ``textDocument/symbolInfo``

These are being mentioned only for completeness sake. We're not losing anything
by not using this flavour.

----

Remove deprecated config
------------------------

Run ``:checkhealth vim.deprecated``

``vim.diagnostic``
^^^^^^^^^^^^^^^^^^

* ``vim.diagnostic.goto_next()`` - Use ``vim.diagnostic.jump()`` with
  ``{count=1, float=true}`` instead.

* ``vim.diagnostic.goto_prev()`` - Use ``vim.diagnostic.jump()`` with
  ``{count=-1, float=true}`` instead.

``vim.lsp.with()``
^^^^^^^^^^^^^^^^^^

Help says to pass configuration to equivalent functions in ``vim.lsp.buf.*``

I was using these in ``setup_custom_handlers()`` method in
``lua/plugins/lsp/lsp.lua`` to get rounded borders. Getting rid of this
customization for now.

``:sign-define`` or ``sign_define()``
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Use the "signs" key of ``vim.diagnostic.config()`` instead.

See ``:help diagnostic-signs``.

----

Plugins TLC
-----------

* Plugins TLC

Fix ``trouble.nvim``
^^^^^^^^^^^^^^^^^^^^

https://github.com/folke/trouble.nvim

* The api is now driven by commands instead of function calls. Updated the
  config accordingly.

* TODO: Send telecope results to trouble

Adopt ``stevearc/quicker.nvim``
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

https://github.com/stevearc/quicker.nvim

* ``<leader>q`` to toggle quickfix list

* ``<leader>l`` to toggle location list

* ``>`` and ``<`` to expand and collapse an entry in the list, respectively.

Adopt ``dgagn/diagflow.nvim``
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

https://github.com/dgagn/diagflow.nvim

Displays diagnostics in a floating window on the top right, only for the
current line.

This makes them less noisy when I have a bunch of diagnostics. I already have
the gutter showing the errors inline.

Deprecate ``stevearc/dressing.nvim``, use ``snacks.nvim``
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

https://github.com/stevearc/dressing.nvim 

https://github.com/folke/snacks.nvim

I'm not really using ``snacks.nvim``.

Adopt ``sindrets/diffview.nvim``
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

https://github.com/sindrets/diffview.nvim

* Updated ``gitsigns.nvim`` to have ``<leader>h`` shortcuts, so that
  ``<leader>g`` can be used for ``diffview.nvim``.

* Created config to open ``diffview.nvim`` using ``<leader>g`` based
  shortcuts.

Adopt ``Wansmer/treesj``
^^^^^^^^^^^^^^^^^^^^^^^^

https://github.com/Wansmer/treesj

Added ``<leader>sj`` for ``[s]plit [j]oin``.

Update ``telescope`` config
^^^^^^^^^^^^^^^^^^^^^^^^^^^

* Send ``telescope`` results to ``trouble``

  I was already doing this.

* Make ``telescope`` file browser open ``oil`` at a given location.

  This is now done. Used the examples from configuration recipies in the
  telescope wiki.

  See https://github.com/nvim-telescope/telescope.nvim/wiki/Configuration-Recipes#performing-an-arbitrary-command-by-extending-existing-find_files-picker

* Removed ``file-browser`` telescope extension

* Removed ``luasnip`` telescope extension
