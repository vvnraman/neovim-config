****************
Neovim lsp setup
****************

Basic workflow
==============

LSP setup is primarily done by 2 methods, as mentioned in the `lsp-config`_ docs.

.. _`lsp-config`: https://neovim.io/doc/user/lsp.html#lsp-config

* ``vim.lsp.config("name", "config")``

* ``vim.lsp.enable("name")``

where ``name`` is the LSP server name.

When an LSP client starts, it resolves its configuration by merging the
following sources (merge semantics) defined by `vim.tbl.deep_extend`_, with
force behaviour, in order of increasing priority.

.. _`vim.tbl.deep_extend`: https://neovim.io/doc/user/lua.html#vim.tbl_deep_extend()

.. code-block:: lua

   -- Defined in init.lua
   vim.lsp.config('*', {
     capabilities = {
       textDocument = {
         semanticTokens = {
           multilineTokenSupport = true,
         }
       }
     },
     root_markers = { '.git' },
   })
   -- Defined in <rtp>/lsp/clangd.lua
   return {
     cmd = { 'clangd' },
     root_markers = { '.clangd', 'compile_commands.json' },
     filetypes = { 'c', 'cpp' },
   }
   -- Defined in init.lua
   vim.lsp.config('clangd', {
     filetypes = { 'c' },
   })


The merged result is

.. code-block:: lua


   {
     -- From the clangd configuration in <rtp>/lsp/clangd.lua
     cmd = { 'clangd' },
     -- From the clangd configuration in <rtp>/lsp/clangd.lua
     -- Overrides the "*" configuration in init.lua
     root_markers = { '.clangd', 'compile_commands.json' },
     -- From the clangd configuration in init.lua
     -- Overrides the clangd configuration in <rtp>/lsp/clangd.lua
     filetypes = { 'c' },
     -- From the "*" configuration in init.lua
     capabilities = {
       textDocument = {
         semanticTokens = {
           multilineTokenSupport = true,
         }
       }
     }
   }




