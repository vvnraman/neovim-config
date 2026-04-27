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




Runtime flow in this config
===========================

This repository wires LSP setup through ``lua/plugins/pde/lsp.lua`` and applies
buffer-local behavior in a single ``LspAttach`` callback.

.. code-block:: text

   lua/plugins/pde/lsp.lua
   |-- lsp_setup()
   |   |-- enabled_servers = profile_config.get_enabled_lsp_servers()
   |   |-- get_server_configs()
   |   |-- restrict_lsp_configs_to_allowlist(enabled_servers)
   |   |-- update_server_configs(server_configs)
   |   |-- enable_servers(enabled_servers, server_configs)
   |   |-- if profile_config.enable_mason_installs()
   |   |   `-- install_mason_packages(profile_config.get_mason_packages())
   |   |-- setup_lsp_keymaps()
   |   `-- setup_diagnostic_config()
   `-- LspAttach callback
       |-- setup_native_buffer_mappings(bufnr)
       |-- setup_plugin_buffer_mappings(bufnr)
       |-- setup_autocmds(client, bufnr)
       `-- setup_clangd_extensions(bufnr) for clangd

Before profile enablement, this config applies a strict allowlist to runtime
LSP configs.

.. literalinclude:: ../../lua/plugins/pde/lsp.lua
   :language: lua
   :lines: 138-154
   :lineno-match:
   :emphasize-lines: 1,10,12,13
   :caption: lsp.lua

This helper clears ``filetypes`` for every runtime config that is not in the
current profile allowlist, so broad ``:lsp enable`` and ``:LspStart`` flows can
only match servers that this config intentionally enables.

LspAttach autocommand
---------------------

.. literalinclude:: ../../lua/plugins/pde/lsp.lua
   :language: lua
   :lines: 31-34
   :lineno-match:
   :emphasize-lines: 2
   :caption: lsp.lua

This registers the ``LspAttach`` callback entry point.

.. literalinclude:: ../../lua/plugins/pde/lsp.lua
   :language: lua
   :lines: 50-64
   :lineno-match:
   :emphasize-lines: 13,14
   :caption: lsp.lua

Inside the callback, the ``clangd`` branch applies clangd-specific extensions.

Profile-driven server and Mason policy
--------------------------------------

.. literalinclude:: ../../lua/plugins/pde/lsp.lua
   :language: lua
   :lines: 195-206
   :lineno-match:
   :emphasize-lines: 3
   :caption: lsp.lua

The Mason plugin reads its install root from ``vvn.profile_config`` through
``get_mason_install_root_dir()``.

Relevant changelogs
-------------------

- :ref:`changelog-2025-11-nov-use-native-lsp-setup`
- :ref:`changelog-2026-02-feb-runtime-config-profiles`
