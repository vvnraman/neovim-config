--[[
Called by "lua/plugins/spec/lsp.lua"
]]
--

local M = {}

local setup_diagnostic_config = function()
  local signs = {
    { name = "DiagnosticSignError", text = "" },
    { name = "DiagnosticSignWarn", text = "" },
    { name = "DiagnosticSignHint", text = "" },
    { name = "DiagnosticSignInfo", text = "" },
  }

  for _, sign in ipairs(signs) do
    vim.fn.sign_define(
      sign.name,
      { texthl = sign.name, text = sign.text, numhl = "" }
    )
  end

  vim.diagnostic.config({
    underline = true,
    virtual_text = {
      severity = vim.diagnostic.severity.ERROR,
      source = true,
      spacing = 5,
    },
    signs = {
      active = signs,
    },
    severity_sort = true,
  })

  local which_key = require("which-key")
  which_key.register({
    ["]d"] = { vim.diagnostic.goto_next, "Next [d]iagnostic" },
    ["[d"] = { vim.diagnostic.goto_prev, "Prev [d]iagnostic" },
    ["<leader>d"] = {
      vim.diagnostic.open_float,
      "[d]iagnostics under cursor",
    },
  })
end

local setup_custom_handlers = function()
  vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
    vim.lsp.handlers.hover,
    { border = "rounded" }
  )

  vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(
    vim.lsp.handlers.signature_help,
    { border = "rounded" }
  )
end

local setup_other_lsps = function(lspconfig)
  local vanilla = require("plugins.config.lsp.vanilla")

  --[[
    For a server which we want to customize significantly, like we are doing for
    `clangd` and `lua`, we would move it out of the list below, and have a file
    adjacent to this with the name of the server. See `clangd.lua` and
    `lua_ls.lua` for examples.
    --]]
  for _, server in ipairs({
    "bashls",
    "cmake",
    "dockerls",
    "dotls",
    "pyright",
    "tsserver",
    "vimls",
    "yamlls",
  }) do
    lspconfig[server].setup({
      on_attach = function(client, bufnr)
        vanilla.setup_native_buffer_mappings(client, bufnr)
        vanilla.setup_plugin_buffer_mappings(client, bufnr)
        vanilla.setup_autocmds(client, bufnr)
      end,
      capabilities = vanilla.capabilities,
    })
  end

  lspconfig["jsonls"].setup({
    settings = {
      json = {
        schemas = require("schemastore").json.schemas(),
        validate = { enable = true },
      },
    },
    on_attach = function(client, bufnr)
      vanilla.setup_native_buffer_mappings(client, bufnr)
      vanilla.setup_plugin_buffer_mappings(client, bufnr)
      vanilla.setup_autocmds(client, bufnr)
    end,
    capabilities = vanilla.capabilities,
  })
end

M.setup = function(mason, mason_lspconfig, lspconfig, neodev)
  --[[
  The sequence of operations in this method is important as per mason and
  neodev documentaiton
  - https://github.com/williamboman/mason.nvim
  - https://github.com/williamboman/mason-lspconfig.nvim
  - https://github.com/folke/lua-dev.nvim
  --]]

  mason.setup({
    ui = {
      icons = {
        server_installed = "✓",
        server_pending = "➜",
        server_uninstalled = "✗",
      },
    },
  })

  -- local ensure_installed = { "lua_ls" }
  mason_lspconfig.setup({
    ensure_installed = { "clangd", "lua_ls" },
    automatic_installation = true,
  })

  setup_diagnostic_config()
  setup_custom_handlers()

  -- `neodev` should be setup before we setup `lua_ls`
  neodev.setup()

  require("which-key").register({
    ["<leader>l"] = { name = "[L]SP", _ = "which_key_ignore" },
  })

  require("plugins.config.lsp.clangd").setup()
  require("plugins.config.lsp.lua_ls").setup()

  setup_other_lsps(lspconfig)
end

return M
