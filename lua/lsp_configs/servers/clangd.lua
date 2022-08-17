-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#clangd
-- https://github.com/p00f/clangd_extensions.nvim
local M = {}

-- We're not using a `pcall()` here since we're called only from where this is
-- required.
local lspconfig = require("lspconfig")
local lspconfig_util = require("lspconfig.util")
local lsp_handlers = require("lsp_configs.lsp_handlers")
local diagnostics = require("lsp_configs.diagnostics")

local root_files = {
    "compile_commands.json",
}

local set_mappings = function(_, bufnr)
    VIM_KEYMAP_SET(
        { "n" },
        "<leader>gs",
        "<Cmd>ClangdSwitchSourceHeader<Cr>",
        { buffer = bufnr }
    )
end

local opts = {
    on_attach = function(client, bufnr)
        lsp_handlers.set_mappings(client, bufnr)
        lsp_handlers.set_autocmds(client, bufnr)
        diagnostics.set_mappings(client, bufnr)
        set_mappings(client, bufnr)
    end,
    capabilities = lsp_handlers.capabilities,
    root_dir = function(fname)
        return lspconfig_util.root_pattern(unpack(root_files))(fname)
    end,
    single_file_support = false,
}

local ok_clangd_extensions, clangd_extensions = pcall(
    require,
    "clangd_extensions"
)

M.setup = function()
    if ok_clangd_extensions then
        clangd_extensions.setup({
            server = opts,
            extensions = {
                autoSetHints = true,
                inlay_hints = {
                    only_current_line = true,
                },
            },
        })
    else
        lspconfig.clangd.setup(opts)
    end
end

return M
