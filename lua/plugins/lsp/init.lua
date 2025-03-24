local setup_diagnostic_config = function()
  local signs = {
    { name = "DiagnosticSignError", text = "" },
    { name = "DiagnosticSignWarn", text = "" },
    { name = "DiagnosticSignHint", text = "" },
    { name = "DiagnosticSignInfo", text = "" },
  }

  for _, sign in ipairs(signs) do
    vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
  end

  vim.diagnostic.config({
    underline = true,
    virtual_text = {
      severity = vim.diagnostic.severity.ERROR,
      source = true,
      spacing = 5,
    },
    signs = {
      active = signs,
    },
    severity_sort = true,
  })

  vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Next [d]iagnostic" })
  vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Prev [d]iagnostic" })
  vim.keymap.set(
    "n",
    "<leader>d",
    vim.diagnostic.open_float,
    { desc = "[d]iagnostics under cursor" }
  )
end

local setup_custom_handlers = function()
  vim.lsp.handlers["textDocument/hover"] =
    vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" })

  vim.lsp.handlers["textDocument/signatureHelp"] =
    vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" })
end

local setup_other_lsps = function(lspconfig)
  local vanilla = require("plugins.lsp.vanilla")

  --[[
    For a server which we want to customize significantly, like we are doing for
    `clangd` and `lua`, we would move it out of the list below, and have a file
    adjacent to this with the name of the server. See `clangd.lua` and
    `lua_ls.lua` for examples.
    --]]
  for _, server in ipairs({
    "bashls",
    "cmake",
    "dockerls",
    "dotls",
    "pyright",
    "ts_ls",
    "vimls",
    "yamlls",
  }) do
    lspconfig[server].setup({
      on_attach = function(client, bufnr)
        vanilla.setup_native_buffer_mappings(client, bufnr)
        vanilla.setup_plugin_buffer_mappings(client, bufnr)
        vanilla.setup_autocmds(client, bufnr)
      end,
      capabilities = vanilla.capabilities,
    })
  end

  lspconfig["jsonls"].setup({
    settings = {
      json = {
        schemas = require("schemastore").json.schemas(),
        validate = { enable = true },
      },
    },
    on_attach = function(client, bufnr)
      vanilla.setup_native_buffer_mappings(client, bufnr)
      vanilla.setup_plugin_buffer_mappings(client, bufnr)
      vanilla.setup_autocmds(client, bufnr)
    end,
    capabilities = vanilla.capabilities,
  })
end

local lsp_setup = function()
  local mason = require("mason")
  local mason_lspconfig = require("mason-lspconfig")
  local lspconfig = require("lspconfig")
  --[[
  The sequence of operations in this method is important as per mason docs
  - https://github.com/williamboman/mason.nvim
  - https://github.com/williamboman/mason-lspconfig.nvim
  --]]

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
    -- TODO: these two options should be configurable based on the environment
    ensure_installed = { "clangd", "lua_ls" },
    automatic_installation = true,
  })

  setup_diagnostic_config()
  setup_custom_handlers()

  require("which-key").add({
    "<leader>l",
    group = "[L]SP",
  })

  -- TODO: these 3 should be called conditionally based on the environment
  require("plugins.lsp.clangd").setup()
  require("plugins.lsp.lua_ls").setup()
  setup_other_lsps(lspconfig)
end

local M = {
  {
    "folke/lazydev.nvim",
    ft = "lua", -- only load on lua files
    opts = {
      library = {
        -- See the configuration section for more details
        -- Load luvit types when the `vim.uv` word is found
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
      },
    },
  },
  {
    -- https://github.com/neovim/nvim-lspconfig
    -- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      {
        -- https://github.com/williamboman/mason.nvim
        "williamboman/mason.nvim",
      },
      {
        -- https://github.com/williamboman/mason-lspconfig.nvim
        "williamboman/mason-lspconfig.nvim",
      },
      {
        -- https://github.com/folke/lazydev.nvim
        "folke/lazydev.nvim",
      },
      {
        -- https://github.com/b0o/SchemaStore.nvim
        "b0o/schemastore.nvim",
      },
      {
        -- spec elsewhere
        "folke/which-key.nvim",
      },
      {
        -- spec elsewhere
        "nvim-telescope/telescope.nvim",
      },
      {
        -- spec elsewhere
        "hrsh7th/cmp-nvim-lsp",
      },
      {
        -- spec elsewhere
        "ray-x/lsp_signature.nvim",
      },
      {
        -- spec below
        "aznhe21/actions-preview.nvim",
      },
      {
        -- spec below
        "p00f/clangd_extensions.nvim",
      },
    },
    config = lsp_setup,
  },
  {
    -- https://github.com/aznhe21/actions-preview.nvim
    "aznhe21/actions-preview.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      {
        -- spec elsewhere
        "nvim-telescope/telescope.nvim",
      },
    },
    config = function()
      require("actions-preview").setup({
        telescope = require("telescope.themes").get_dropdown({
          winblend = 20,
        }),
      })
    end,
  },
  {
    -- https://github.com/p00f/clangd_extensions.nvim
    "p00f/clangd_extensions.nvim",
    event = { "BufReadPre", "BufNewFile" },
    -- The `filetypes` come from the default `filetypes` specified for
    -- `clangd` in `lspconfig` documentation
    ft = { "c", "cpp", "objc", "objcpp", "cuda", "proto" },
    opts = {
      inlay_hints = {
        only_current_line = true,
        only_current_line_autocmd = { "CursorHold" },
      },
    },
  },
}

return M
