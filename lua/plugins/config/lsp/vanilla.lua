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
  local lsp_prefix = function(desc)
    return "LSP: " .. desc
  end

  local which_key = require("which-key")
  which_key.register({
    ["lh"] = { vim.lsp.buf.hover, lsp_prefix("[h]over documentation") },
    ["lk"] = { vim.lsp.buf.signature_help, lsp_prefix("[k] signature help") },
    ["ld"] = { vim.lsp.buf.definition, lsp_prefix("goto [d]efinition") },
    ["lD"] = { vim.lsp.buf.declaration, lsp_prefix("goto [D]eclaration") },
    ["lt"] = {
      vim.lsp.buf.type_definition,
      lsp_prefix("goto [t]ype definition"),
    },
    ["li"] = {
      vim.lsp.buf.implementation,
      lsp_prefix("goto [i]mplementation"),
    },
    ["rn"] = {
      vim.lsp.buf.rename,
      lsp_prefix("[r]e[n]ame identifier under cursor"),
    },
    -- `Format` user command is setup during `conform` setup.
    ["<leader>f"] = { "<Cmd>Format<Cr>", lsp_prefix("[f]ormat buffer") },
  }, { prefix = "<leader>", buffer = bufnr })
end

M.setup_plugin_buffer_mappings = function(
  _, --[[ client --]]
  bufnr
)
  local which_key = require("which-key")

  --============================================================================
  -- https://github.com/nvim-telescope/telescope.nvim
  local telescope_builtin = require("telescope.builtin")
  which_key.register({
    ["lf"] = {
      function()
        telescope_builtin.lsp_references(require("telescope.themes").get_ivy({
          winblend = 20,
        }))
      end,
      "LSP: re[f]erences in telescope",
    },
    ["sd"] = {
      function()
        telescope_builtin.lsp_document_symbols(
          require("telescope.themes").get_ivy({
            winblend = 20,
          })
        )
      end,
      "LSP: search [s]ymbols in [d]ocument",
    },
  }, { prefix = "<leader>", buffer = bufnr })

  -----------------------------------------------------------------------------

  --============================================================================
  -- https://github.com/aznhe21/actions-preview.nvim
  which_key.register({
    ["ca"] = {
      require("actions-preview").code_actions,
      "LSP: [c]ode [a]ctions",
    },
  }, { prefix = "<leader>", buffer = bufnr })

  -----------------------------------------------------------------------------

  --============================================================================
  -- https://github.com/ray-x/lsp_signature.nvim
  require("which-key").register({
    ["<C-k>"] = {
      function()
        require("ray-x/lsp_signature.nvim").toggle_float_win()
      end,
      "LSP: Signature help",
    },
  }, { buffer = bufnr })

  -----------------------------------------------------------------------------

  --============================================================================
  -- https://github.com/simrat39/symbols-outline.nvim
  which_key.register({
    ["lo"] = { "<Cmd>SymbolsOutline<Cr>", "[L]SP: symbols [o]utline" },
  }, { prefix = "<leader>", buffer = bufnr })

  -----------------------------------------------------------------------------
end

M.setup_autocmds = function(client, bufnr)
  -- TODO: Replace following with an approproate plugin
  -- Set autocommands conditional on server_capabilities
  if client.server_capabilities.document_highlight then
    local group = vim.api.nvim_create_augroup(
      "lsp_document_highlight",
      { clear = true }
    )
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
