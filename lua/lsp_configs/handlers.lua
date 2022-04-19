local M = {}

M.setup = function()
  local signs = {
    { name = "DiagnosticSignError", text = "" },
    { name = "DiagnosticSignWarn", text = "" },
    { name = "DiagnosticSignHint", text = "" },
    { name = "DiagnosticSignInfo", text = "" },
  }

  for _, sign in ipairs(signs) do
    vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
  end

  -- Neovim has a built in diagnostic abstraction. We're only setting it up
  -- here
  local diagnostic_config = {
    update_in_insert = false,
    underline = true,
    virtual_text = {
      severity = vim.diagnostic.severity.ERROR,
      source = true,
      spacing = 10
    },
    -- show signs
    signs = {
      active = signs,
    },
    severity_sort = true,
    float = {
      focusable = false,
      style = "minimal",
      border = "rounded",
      source = "always",
      header = "",
      prefix = "",
    },
  }

  vim.diagnostic.config(diagnostic_config)

  vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
    border = "rounded",
  })

  vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
    border = "rounded",
  })
end

local ok_telescope, _ = pcall(require, 'telescope')
if not ok_telescope then
  print '"nvim-telescope/telescope.nvim" not available, for use in "lsp_configs/handlers"'
end

local function set_lsp_keymaps(bufnr)
  vim.keymap.set({"n"}, "<leader>K", vim.lsp.buf.hover, {buffer = bufnr})
  vim.keymap.set({"n"}, "<leader>gd", vim.lsp.buf.definition, {buffer = bufnr})
  vim.keymap.set({"n"}, "<leader>gt", vim.lsp.buf.type_definition, {buffer = bufnr})
  vim.keymap.set({"n"}, "<leader>gi", vim.lsp.buf.implementation, {buffer = bufnr})
  vim.keymap.set({"n"}, "<leader>r", vim.lsp.buf.rename, {buffer = bufnr})
  vim.keymap.set({"n"}, "<leader>dn", vim.diagnostic.goto_next, {buffer = bufnr})
  vim.keymap.set({"n"}, "<leader>dp", vim.diagnostic.goto_prev, {buffer = bufnr})
  vim.keymap.set({"n"}, "<leader>dy", vim.diagnostic.show, {buffer = bufnr})
  vim.keymap.set({"n"}, "<leader>de", vim.diagnostic.hide, {buffer = bufnr})
  if ok_telescope then
    vim.keymap.set({"n"}, "<leader>fd", "<Cmd>Telescope diagnostics<Cr>", {buffer = bufnr})
  end
end

local function set_lsp_highlight_document(client)
  -- Set autocommands conditional on server_capabilities
  if client.resolved_capabilities.document_highlight then
    local group = vim.api.nvim_create_augroup("lsp_document_highlight", { clear = true })
    vim.api.nvim_create_autocmd({ "CursorHold" }, {
      group = group,
      buffer = 0,
      callback = vim.lsp.buf.document_highlight
    })
    vim.api.nvim_create_autocmd({ "CursorMoved" }, {
      group = group,
      buffer = 0,
      callback = vim.lsp.buf.clear_references})
  end
end

M.on_attach = function(client, bufnr)
  set_lsp_keymaps(bufnr)
  set_lsp_highlight_document(client)
end

M.capabilities = nil
local ok_cmp_nvim_lsp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if ok_cmp_nvim_lsp then
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  M.capabilities = cmp_nvim_lsp.update_capabilities(capabilities)
end

return M
