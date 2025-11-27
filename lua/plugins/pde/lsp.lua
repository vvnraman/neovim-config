local setup_diagnostic_config = function()
  vim.diagnostic.config({
    underline = true,
    virtual_text = {
      severity = vim.diagnostic.severity.ERROR,
      source = true,
      spacing = 5,
    },
    signs = {
      text = {
        [vim.diagnostic.severity.ERROR] = "",
        [vim.diagnostic.severity.WARN] = "",
        [vim.diagnostic.severity.INFO] = "",
        [vim.diagnostic.severity.HINT] = "",
      },
    },
    severity_sort = true,
  })

  vim.keymap.set("n", "]d", function()
    vim.diagnostic.jump({ count = 1, float = true })
  end, { desc = "Next [d]iagnostic" })

  vim.keymap.set("n", "[d", function()
    vim.diagnostic.jump({ count = -1, float = true })
  end, { desc = "Prev [d]iagnostic" })

  vim.keymap.set(
    "n",
    "<leader>d",
    vim.diagnostic.open_float,
    { desc = "[d]iagnostics under cursor" }
  )
end

local setup_lsp_keymaps = function()
  vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("vvnraman.lsp.config", { clear = true }),
    callback = function(event)
      ---@diagnostic disable-next-line: unused-local
      local log = require("vvn.log")
      --[[
      log.info(vim.inspect(event))
      {
        buf = 1,
        data = {
          client_id = 1
        },
        event = "LspAttach",
        file = "path/to/code",
        group = 32,
        id = 63,
        match = "path/to/code"
      }
      --]]

      local bufnr = event.buf
      require("plugins.pde.attach").setup_native_buffer_mappings(bufnr)
      require("plugins.pde.attach").setup_plugin_buffer_mappings(bufnr)

      local client = vim.lsp.get_client_by_id(event.data.client_id)
      if not client then
        return
      end

      require("plugins.pde.attach").setup_autocmds(client, bufnr)

      ---@param name string
      local client_is = function(name)
        local client_exists = false
        if client.server_info and name == client.server_info.name then
          client_exists = true
        end
        if client.name and name == client.name then
          client_exists = true
        end

        -- Log the payload when the server connect, once.
        -- log.info("Logging payload for " .. name)
        -- local client_logged_dict = vim.g.vvn_client_logged_dict
        -- client_logged_dict = client_logged_dict or {}
        -- if not client_logged_dict[name] then
        --   log.info(vim.inspect(client))
        --   client_logged_dict[name] = false
        --   vim.g.vvn_client_logged_dict = client_logged_dict
        -- end

        return client_exists
      end

      if client_is("clangd") then
        require("plugins.pde.attach").setup_clangd_extensions(bufnr)
      end
    end,
  })
end

local lsp_setup = function()
  --[[
  The sequence of operations in this method is important as per mason docs
  - https://github.com/williamboman/mason.nvim
  - https://github.com/williamboman/mason-lspconfig.nvim
  --]]

  require("mason").setup({
    ui = {
      icons = {
        server_installed = "✓",
        server_pending = "➜",
        server_uninstalled = "✗",
      },
    },
  })

  local servers = {
    clangd = {
      root_markers = {
        -- Intentionally only attach when I have a project CMake configured.
        "compile_commands.json",
      },
      single_file_support = false,
      InlayHints = {
        Designators = true,
        Enabled = true,
        ParameterNames = true,
        DeducedTypes = true,
      },
    },

    lua_ls = {
      settings = {
        Lua = {
          workspace = {
            checkThirdParty = false,
            library = vim.api.nvim_get_runtime_file("", true),
          },
          telemetry = {
            enable = false,
          },
        },
      },
    },

    jsonls = {
      settings = {
        json = {
          schemas = require("schemastore").json.schemas(),
          validate = { enable = true },
        },
      },
    },
    bashls = {},
    gopls = {},
    cmake = {},
    dockerls = {},
    dotls = {},
    basedpyright = {},
    ts_ls = {},
    vimls = {},
    yamlls = {},
  }

  local capabilities = require("plugins.pde.attach").capabilities

  for name, conf in pairs(servers) do
    local config = conf or {}
    config.capabilities =
      vim.tbl_deep_extend("force", {}, capabilities, config.capabilities or {})
    vim.lsp.config(name, config)
  end

  setup_lsp_keymaps()
  setup_diagnostic_config()

  -----------------------------------------------------------------------------
  --- LSP SETUP IS COMPLETE AT THIS POINT.
  ---
  --- The rest of the setup below is to configure and install LSP servers and
  --- other tools.
  -----------------------------------------------------------------------------

  require("mason-lspconfig").setup({
    -- to avoid lint warning even though this is already the default
    -- as per their docs. This to driven by `mason-tool-installer`.
    ensure_installed = {},
    automatic_enable = true,
  })

  --- TODO: Have the tool installation be gated by environment variables.
  ---       In some cases, we'll not install any tools because they are already
  ---       available on the system, and we only need to call
  ---       `vim.lsp.enable()` for those servers.
  -- Install all language servers and other tools
  local ensure_installed = vim.tbl_keys(servers)
  vim.list_extend(ensure_installed, {
    "stylua",
    "shfmt",
    "shellcheck",
  })

  require("mason-tool-installer").setup({
    ensure_installed = ensure_installed,
  })

  require("which-key").add({
    "<leader>l",
    group = "[L]SP",
  })
end

local M = {
  {
    -- https://github.com/folke/lazydev.nvim
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
        -- https://github.com/mason-org/mason.nvim
        "mason-org/mason.nvim",
      },
      {
        -- https://github.com/mason-org/mason-lspconfig.nvim
        "mason-org/mason-lspconfig.nvim",
      },
      {
        -- https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim
        "WhoIsSethDaniel/mason-tool-installer.nvim",
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
        "hrsh7th/cmp-nvim-lsp",
      },
    },
    config = lsp_setup,
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
