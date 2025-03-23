local M = {}

local get_capabilities = function()
  local cmp_nvim_lsp = require("cmp_nvim_lsp")
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  return cmp_nvim_lsp.default_capabilities(capabilities)
end

M.capabilities = get_capabilities()

M.setup_native_buffer_mappings = function(
  _, --[[ client --]]
  bufnr
)
  local l_desc = function(desc)
    return { "[l]sp: " .. desc, buffer = bufnr }
  end

  vim.keymap.set("n", "<leader>lh", vim.lsp.buf.hover, l_desc("[h]over docs"))
  vim.keymap.set("n", "<leader>lk", vim.lsp.buf.signature_help, l_desc("[k] - signature help"))
  vim.keymap.set("n", "<leader>ld", vim.lsp.buf.definition, l_desc("[d]efinition"))
  vim.keymap.set("n", "<leader>lD", vim.lsp.buf.declaration, l_desc("[D]eclaration"))
  vim.keymap.set("n", "<leader>lt", vim.lsp.buf.type_definition, l_desc("[t]ype definition"))
  vim.keymap.set("n", "<leader>li", vim.lsp.buf.implementation, l_desc("[i]mplementation"))
  vim.keymap.set("n", "<leader>lr", vim.lsp.buf.rename, l_desc("[r]ename identifier"))

  -- `Format` user command is setup during `conform` setup.
  vim.keymap.set("v", "<leader><leader>f", "<Cmd>Format<Cr>", l_desc("[f]ormat buffer"))
end

M.setup_plugin_buffer_mappings = function(
  _, --[[ client --]]
  bufnr
)
  local l_desc = function(desc)
    return { "[l]sp: " .. desc, buffer = bufnr }
  end

  -----------------------------------------------------------------------------
  -- https://github.com/nvim-telescope/telescope.nvim
  local telescope_builtin = require("telescope.builtin")
  vim.keymap.set("n", "<leader>lf", function()
    telescope_builtin.lsp_references(require("telescope.themes").get_ivy({
      winblend = 20,
    }))
  end, l_desc("re[f]erences"))
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
    l_desc("code [a]ctions")
  )

  -----------------------------------------------------------------------------
  -- https://github.com/ray-x/lsp_signature.nvim
  vim.keymap.set("n", "<C-h>", function()
    require("lsp_signature").toggle_float_win()
  end, { desc = "lsp: Signature help", buffer = bufnr })
end

M.setup_autocmds = function(client, bufnr)
  -- TODO: Replace following with an approproate plugin
  -- Set autocommands conditional on server_capabilities
  if client.server_capabilities.document_highlight then
    local group = vim.api.nvim_create_augroup("lsp_document_highlight", { clear = true })
    vim.api.nvim_create_autocmd({ "CursorHold" }, {
      group = group,
      buffer = bufnr,
      callback = vim.lsp.buf.document_highlight,
    })
    vim.api.nvim_create_autocmd({ "CursorMoved" }, {
      group = group,
      buffer = bufnr,
      callback = vim.lsp.buf.clear_references,
    })
  end
end

return M
