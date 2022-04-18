-- 'neovim/nvim-lspconfig'
local ok_lspconfig, _ = pcall(require, "lspconfig")
-- We don't actually need to use lspconfig. It gets used indirectly via the
-- lsp_installer below.
if not ok_lspconfig then
  print '"neovim/nvim-lspconfig" not available'
  return
end

-- 'williamboman/nvim-lsp-installer'
local ok_lsp_installer, lsp_installer = pcall(require, "nvim-lsp-installer")
if not ok_lsp_installer then
  print '"williamboman/nvim-lsp-installer" not available'
  return
end

lsp_installer.settings({
  ui = {
    icons = {
      server_installed = "✓",
      server_pending = "➜",
      server_uninstalled = "✗"
    },
  },
})

local lsp_handlers = require('lsp_configs.handlers')
lsp_handlers.setup()

lsp_installer.on_server_ready(function(server)
  local opts = {}

  if server.name == "sumneko_lua" then
    local sumneko_opts = require("lsp_configs.servers.sumneko_lua")
    opts = vim.tbl_deep_extend("force", sumneko_opts, opts)
  end

  server:setup(opts)
end)
