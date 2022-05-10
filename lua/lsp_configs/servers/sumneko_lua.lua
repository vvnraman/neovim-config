local M = {}

-- We're not using a `pcall()` here since we're called only from where this is
-- required.
local lspconfig = require("lspconfig")
local lsp_handlers = require("lsp_configs.lsp_handlers")
local diagnostics = require("lsp_configs.diagnostics")

local runtime_path = vim.split(package.path, ";")
table.insert(runtime_path, "lua/?.lua")
table.insert(runtime_path, "lua/?/init.lua")

-- https://github.com/folke/lua-dev.nvim
local ok_lua_dev, lua_dev = pcall(require, "lua-dev")

local on_attach = function(client, bufnr)
    -- formatting is done by null-ls
    client.resolved_capabilities.document_formatting = false
    lsp_handlers.set_mappings(client, bufnr)
    lsp_handlers.set_autocmds(client, bufnr)
    diagnostics.set_mappings(client, bufnr)
end

local settings = {
    Lua = {
        runtime = {
            path = runtime_path,
        },
        diagnostics = {
            globals = { "vim" },
        },
        workspace = {
            library = vim.api.nvim_get_runtime_file("", true),
        },
        telemetry = {
            enable = false,
        },
    },
}

M.setup = function()
    if ok_lua_dev then
        local luadev = lua_dev.setup({
            lspconfig = {
                on_attach = on_attach,
                capabilities = lsp_handlers.capabilities,
                settings = settings,
            },
        })
        lspconfig.sumneko_lua.setup(luadev)
    else
        lspconfig.sumneko_lua.setup({
            on_attach = on_attach,
            capabilities = lsp_handlers.capabilities,
            settings = settings,
        })
    end
end

return M
