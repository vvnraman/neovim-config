local M = {}

M.capabilities = require("cmp_nvim_lsp").default_capabilities()

---@param bufnr integer Local buffer which this mapping applies to
M.setup_native_buffer_mappings = function(bufnr)
  local help = function(desc)
    return { desc = "[l]sp: " .. desc, buffer = bufnr }
  end

  vim.keymap.set("n", "<leader>lh", vim.lsp.buf.hover, help("[h]over docs"))
  vim.keymap.set("n", "<leader>lk", vim.lsp.buf.signature_help, help("[k] - signature help"))
  vim.keymap.set("n", "<leader>ld", vim.lsp.buf.definition, help("[d]efinition"))
  vim.keymap.set("n", "<leader>lD", vim.lsp.buf.declaration, help("[D]eclaration"))
  vim.keymap.set("n", "<leader>lt", vim.lsp.buf.type_definition, help("[t]ype definition"))
  vim.keymap.set("n", "<leader>li", vim.lsp.buf.implementation, help("[i]mplementation"))
  vim.keymap.set("n", "<leader>lr", vim.lsp.buf.rename, help("[r]ename identifier"))

  vim.keymap.set("n", "<leader>ll", function()
    vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
    Snacks.notifier.notify(
      vim.lsp.inlay_hint.is_enabled() and "Inlay Hints Enabled" or "Inlay Hints Disabled",
      "info"
    )
  end, help("in[l]ay hints"))

  -- `Format` user command is setup during `conform` setup.
  vim.keymap.set({ "n", "v" }, "<leader><leader>f", "<Cmd>Format<Cr>", help("[f]ormat buffer"))
end

---@param bufnr integer Local buffer which this mapping applies to
M.setup_plugin_buffer_mappings = function(bufnr)
  local help = function(desc)
    return { desc = "[l]sp: " .. desc, buffer = bufnr }
  end

  -----------------------------------------------------------------------------
  -- https://github.com/nvim-telescope/telescope.nvim
  local telescope_builtin = require("telescope.builtin")
  vim.keymap.set("n", "<leader>lf", function()
    telescope_builtin.lsp_references(require("telescope.themes").get_ivy({
      winblend = 20,
    }))
  end, help("re[f]erences"))

  vim.keymap.set("n", "<leader>sd", function()
    telescope_builtin.lsp_document_symbols(require("telescope.themes").get_ivy({
      winblend = 20,
    }))
  end, { desc = "lsp: [s]ymbols in [d]ocument", buffer = bufnr })

  -----------------------------------------------------------------------------
  -- https://github.com/aznhe21/actions-preview.nvim
  vim.keymap.set(
    "n",
    "<leader>la",
    require("actions-preview").code_actions,
    help("code [a]ctions")
  )
end

---@param client vim.lsp.Client
---@param bufnr integer Local buffer which this mapping applies to
M.setup_autocmds = function(client, bufnr)
  if client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight, bufnr) then
    local highlight_augroup =
      vim.api.nvim_create_augroup("lsp_document_highlight", { clear = false })
    vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
      group = highlight_augroup,
      buffer = bufnr,
      callback = vim.lsp.buf.document_highlight,
    })

    vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
      group = highlight_augroup,
      buffer = bufnr,
      callback = vim.lsp.buf.clear_references,
    })

    vim.api.nvim_create_autocmd("LspDetach", {
      group = vim.api.nvim_create_augroup("vvnraman_lsp_detach", { clear = true }),
      callback = function(event2)
        vim.lsp.buf.clear_references()
        vim.api.nvim_clear_autocmds({ group = "lsp_document_highlight", buffer = event2.buf })
      end,
    })
  end
end

---@param bufnr integer Local buffer which this mapping applies to
M.setup_clangd_extensions = function(bufnr)
  -- https://github.com/p00f/clangd_extensions.nvim
  --[[
  User commands from `p00f/clangd_extensions.nvim`

  - `ClangdAST`
  - `ClangdTypeHierarchy`
  - `ClangdSymbolInfo`
  - `ClangdMemoryUsage`
  - `ClangdSwitchSourceHeader`

  --]]
  vim.keymap.set(
    "n",
    "\\s",
    "<Cmd>ClangdSwitchSourceHeader<Cr>",
    { desc = "Clangd: [s]witch Cpp/Header file", buffer = bufnr }
  )
  vim.keymap.set(
    "n",
    "<leader><leader>s",
    "<Cmd>ClangdSymbolInfo<Cr>",
    { desc = "Clangd: [s]ymbol info", buffer = bufnr }
  )
end

return M
