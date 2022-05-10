-- https://github.com/williamboman/nvim-lsp-installer/
local ok_lsp_installer, lsp_installer = pcall(require, "nvim-lsp-installer")
if not ok_lsp_installer then
    print('"williamboman/nvim-lsp-installer" not available')
    return
end

lsp_installer.settings({
    ui = {
        icons = {
            server_installed = "✓",
            server_pending = "➜",
            server_uninstalled = "✗",
        },
    },
})

lsp_installer.setup({
    ensure_installed = { "clangd", "sumneko_lua" },
    automatic_installation = true,
})

-- https://github.com/neovim/nvim-lspconfig
-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
local ok_lspconfig, lspconfig = pcall(require, "lspconfig")
if not ok_lspconfig then
    print('"neovim/nvim-lspconfig" not available')
    return
end

local diagnostics = require("lsp_configs.diagnostics")
diagnostics.setup()

require("lsp_configs.servers.clangd").setup()
require("lsp_configs.servers.sumneko_lua").setup()

local setup_lsps = function()
    local lsp_handlers = require("lsp_configs.lsp_handlers")
    lsp_handlers.setup()

    local opts = {
        on_attach = function(client, bufnr)
            lsp_handlers.set_mappings(client, bufnr)
            lsp_handlers.set_autocmds(client, bufnr)
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
