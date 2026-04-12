local M = {}

M.capabilities = require("cmp_nvim_lsp").default_capabilities()

---@param bufnr integer Local buffer which this mapping applies to
M.setup_native_buffer_mappings = function(bufnr)
  local help = function(desc)
    return { desc = "[l]sp: " .. desc, buffer = bufnr }
  end

  vim.keymap.set("n", "<leader>lk", vim.lsp.buf.signature_help, help("[k] - signature help"))
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

  ---@return table
  local lsp_ivy_picker_opts = function()
    -- Keep the input and result list airy, but make the preview less
    -- transparent so code/details are easier to read.
    return {
      layout = {
        preset = "ivy",
        layout = {
          width = 0.95,
        },
      },
      win = {
        input = { wo = { winblend = 30 } },
        list = { wo = { winblend = 30 } },
        preview = { wo = { winblend = 10 } },
      },
    }
  end

  -----------------------------------------------------------------------------
  -- https://github.com/folke/snacks.nvim/blob/main/docs/picker.md

  vim.keymap.set("n", "<leader>ld", function()
    Snacks.picker.lsp_definitions(lsp_ivy_picker_opts())
  end, help("[d]efinition"))

  vim.keymap.set("n", "<leader>lD", function()
    Snacks.picker.lsp_declarations(lsp_ivy_picker_opts())
  end, help("[D]eclaration"))

  vim.keymap.set("n", "<leader>lh", function()
    Snacks.picker.lsp_config({
      attached = bufnr,
    })
  end, help("[h]over docs"))

  vim.keymap.set("n", "<leader>lt", function()
    Snacks.picker.lsp_type_definitions(lsp_ivy_picker_opts())
  end, help("[t]ype definition"))

  vim.keymap.set("n", "<leader>lm", function()
    Snacks.picker.lsp_implementations(lsp_ivy_picker_opts())
  end, help("i[m]plementation"))

  vim.keymap.set("n", "<leader>li", function()
    Snacks.picker.lsp_incoming_calls(lsp_ivy_picker_opts())
  end, help("[i]ncoming calls"))

  vim.keymap.set("n", "<leader>lo", function()
    Snacks.picker.lsp_outgoing_calls(lsp_ivy_picker_opts())
  end, help("[o]utgoing calls"))

  vim.keymap.set("n", "<leader>lf", function()
    Snacks.picker.lsp_references(lsp_ivy_picker_opts())
  end, help("re[f]erences"))

  vim.keymap.set("n", "<leader>ls", function()
    Snacks.picker.lsp_symbols(lsp_ivy_picker_opts())
  end, help("[s]ymbols"))

  -----------------------------------------------------------------------------
  -- local telescope_builtin = require("telescope.builtin")
  -- vim.keymap.set("n", "<leader>lf", function()
  --   telescope_builtin.lsp_references(require("telescope.themes").get_ivy({
  --     winblend = 20,
  --   }))
  -- end, help("re[f]erences"))

  -- vim.keymap.set("n", "<leader>sd", function()
  --   telescope_builtin.lsp_document_symbols(require("telescope.themes").get_ivy({
  --     winblend = 20,
  --   }))
  -- end, { desc = "lsp: [s]ymbols in [d]ocument", buffer = bufnr })

  -----------------------------------------------------------------------------
  -- https://github.com/rachartier/tiny-code-action.nvim
  vim.keymap.set(
    { "n", "x" },
    "<leader>la",
    require("tiny-code-action").code_action,
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
