local M = {}

M.setup = function()
    vim.lsp.handlers["textDocument/hover"] =
        vim.lsp.with(
            vim.lsp.handlers.hover,
            {
                border = "rounded",
            }
        )

    vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(
        vim.lsp.handlers.signature_help,
        {
            border = "rounded",
        }
    )
end

M.set_mappings = function(_, bufnr) -- (client, bufnr)
    vim.keymap.set({ "n" }, "<leader>K", vim.lsp.buf.hover, { buffer = bufnr })
    vim.keymap.set(
        { "n" },
        "<leader>gd",
        vim.lsp.buf.definition,
        { buffer = bufnr }
    )
    vim.keymap.set(
        { "n" },
        "<leader>gt",
        vim.lsp.buf.type_definition,
        { buffer = bufnr }
    )
    vim.keymap.set(
        { "n" },
        "<leader>gi",
        vim.lsp.buf.implementation,
        { buffer = bufnr }
    )
    vim.keymap.set(
        { "n" },
        "<leader>rn",
        vim.lsp.buf.rename,
        { buffer = bufnr }
    )
    vim.keymap.set(
        { "n" },
        "<leader>gf",
        vim.lsp.buf.formatting_sync,
        { buffer = bufnr }
    )
end

M.set_autocmds = function(client, _) -- (client, bufnr)
    -- Set autocommands conditional on server_capabilities
    if client.resolved_capabilities.document_highlight then
        local group = vim.api.nvim_create_augroup(
            "lsp_document_highlight",
            { clear = true }
        )
        vim.api.nvim_create_autocmd({ "CursorHold" }, {
            group = group,
            buffer = 0,
            callback = vim.lsp.buf.document_highlight,
        })
        vim.api.nvim_create_autocmd({ "CursorMoved" }, {
            group = group,
            buffer = 0,
            callback = vim.lsp.buf.clear_references,
        })
    end
end

M.capabilities = nil
local ok_cmp_nvim_lsp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if ok_cmp_nvim_lsp then
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    M.capabilities = cmp_nvim_lsp.update_capabilities(capabilities)
end

return M
