-- https://github.com/neovim/nvim-lspconfig
-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
local ok_lspconfig, lspconfig = pcall(require, "lspconfig")
if not ok_lspconfig then
    print('"neovim/nvim-lspconfig" not available')
    return
end

-- https://github.com/williamboman/mason.nvim
local ok_mason, mason = pcall(require, "mason")
if not ok_mason then
    print('"williamboman/mason.nvim" not available')
    return
end

-- https://github.com/williamboman/mason-lspconfig.nvim
local ok_mason_lspconfig, mason_lspconfig = pcall(require, "mason-lspconfig")
if not ok_mason_lspconfig then
    print('"williamboman/mason-lspconfig.nvim" not available')
    return
end

mason.setup({
    ui = {
        icons = {
            server_installed = "✓",
            server_pending = "➜",
            server_uninstalled = "✗",
        },
    },
})

mason_lspconfig.setup({
    ensure_installed = { "clangd", "lua_ls" },
    automatic_installation = true,
})

local diagnostics = require("lsp_configs.diagnostics")
diagnostics.setup()

require("lsp_configs.servers.clangd").setup()
require("lsp_configs.servers.lua_ls").setup()

local setup_lsps = function()
    local lsp_handlers = require("lsp_configs.lsp_handlers")
    lsp_handlers.setup()

    local opts = {
        on_attach = function(client, bufnr)
            lsp_handlers.set_mappings(client, bufnr)
            lsp_handlers.set_autocmds(client, bufnr)
            lsp_handlers.set_additional_plugins(client, bufnr)
            diagnostics.set_mappings(client, bufnr)
        end,
        capabilities = lsp_handlers.capabilities,
    }

    for _, server in ipairs({
        "bashls",
        "cmake",
        "dockerls",
        "dotls",
        "gopls",
        "jsonls",
        "pyright",
        "tsserver",
        "vimls",
        "yamlls",
    }) do
        lspconfig[server].setup(opts)
    end
end

setup_lsps()
