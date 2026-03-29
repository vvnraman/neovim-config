.. _changelog-2023-12-dec-migrate-packer-to-lazy:

********************************
2023 Migrate from packer to lazy
********************************

2023-12-29
==========

Rewrite: Migrate from `packer`_ to `lazy`_

Summary
-------

- Complete rewrite using `lazy`_, with almost the same set of plugins.

- Got rid of some of the plugins, installed via `packer`_, which I never used

- Also went through the options and revised them.

- Modular plugin specification and configuration as per lazy

- Use `which-key`_ directly to setup keymaps where possible

- Disabled `treesitter`_ based ``highlight`` as it was terribly slow when
  scrolling.

----

TODO
----

- Options

  - `formatoptions`_ needs work to automatically move to next line depending
    upon file type.

  - `filetype` specific shiftwidth

- Lazy

  - Have a central place to specify which plugins to exclude from being used.

  - Also find out better about ``event = "VeryLazy"`` setup so that I can
    further delay when the plugins get loaded.

    I am currently using ``vim.defer_fn()`` for setting up ``treesitter``,
    something which I copied from ``nvim-lua/kickstart.nvim``.

- colourschemes

  I would like to just specify the primary colourschemes which I want, and it
  should automatically get a ``1000`` priority with the rest of the plugins
  being loaded on ``event = "VeryLazy"``.

- 

----

Lazy setup
----------

With `lazy`_, all the plugins are specified in ``lua/plugins/spec`` folder, and
most of them also configured alongside the spec.

For some of the plugins, the configuration has been extracted out into
``lua/plugins/config`` folder. I did this for either of the following reasons

- A plugin specific config was getting quite large, or I intended it to grow
  larger in the future.

- lsp configuration. I would quickly like to navigate to a specific part using
  ``telescope`` files.

Import ordering
^^^^^^^^^^^^^^^

For a plugin configuration, where another plugin gets used, I've meticulously
specified the dependency so that I don't ever have to use ``pcall()``. This
makes the setup flow for a plugin straightforward, but perhaps at the expense
of some lazy loading speed.

`which-key`_ is a plugin which is a dependency for almost any plugin where I'm
setting a keymap in the configuration.

Directory structure
^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   lua/plugins/
   ├── config
   │   ├── format.lua
   │   ├── lsp
   │   │   ├── clangd.lua
   │   │   ├── init.lua
   │   │   ├── lua_ls.lua
   │   │   └── vanilla.lua
   │   ├── neorg.lua
   │   ├── snippets.lua
   │   ├── telescope.lua
   │   └── treesitter.lua
   └── spec
       ├── buffers_tabs.lua
       ├── cardio.lua
       ├── cmp.lua
       ├── colourschemes.lua
       ├── editing.lua
       ├── filenav.lua
       ├── git.lua
       ├── linting.lua
       ├── looks.lua
       ├── lsp.lua
       ├── luasnip.lua
       ├── neorg.lua
       ├── neovim.lua
       ├── nifty_lsp.lua
       ├── telescope.lua
       ├── tmux.lua
       ├── treesitter.lua
       ├── trouble.lua
       ├── ui.lua
       └── which-key.lua

----

Which-Key
---------

The key mappings are now set via `which-key`_ directly wherever possible. This
lets us have proper labels with a heirarchical setup. I have tried to be
consistent with using a single letter for a set of related mappings. This was
however only possible rouhgly 80% of the times.

Some of the most frequent mappings are triggered via ``<leader><leader>``

- ``<leader><leader>b`` - Open ``telescope`` fuzzy find on the directory of the
  current buffer.

- ``<leader><leader>d`` - Open diagnostics under cursor in a float.

- ``<leader><leader>t`` - Toggle last tab

- ``<leader><leader>w`` - Open top level ``WhichKey``

In addition, a set of mappings I think I'm going to use a lot is ``]t`` and
``[t`` to navigate to next and previous tabs.

----

Oil
---

A great plugin to navigate and edit files in bulk. This specially replaces my
workflow of going to the shell, ``touch newfile.md`` and then opening it up in
Neovim.

Instead, I now do ``<leader>oo`` to open ``Oil`` in a floating windows, and
edit the buffer to create/rename files.

``<leader>ol`` to open ``Oil`` as a regular buffer.

----

Conform.nvim
------------

New plugin to auto-format a buffer on save, also on demand via
``<leader><leader>f``.

----

Gitsigns
--------

This is not a new plugin, but I wasn't really using it in the older setup. I
now have keymaps triggered via ``<leader>h``, and I'm hoping that I use it more
often.

----

Same as before
--------------

``telescope``, ``lsp``, ``tresitter``, ``completion`` and most of the other
configuration remained the same, with some minor changes.


.. _packer: https://github.com/wbthomason/packer.nvim
.. _lazy: https://github.com/folke/lazy.nvim
.. _which-key: https://github.com/folke/which-key.nvim/
.. _formatoptions: https://neovim.io/doc/user/options.html#'formatoptions'
.. _treesitter: https://github.com/nvim-treesitter/nvim-treesitter
