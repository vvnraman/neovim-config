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

  vim.keymap.set("n", "\\d", vim.diagnostic.open_float, { desc = "[d]iagnostics under cursor" })
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

---@return table<string, table>
local get_server_configs = function()
  return {
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
          diagnostics = {
            globals = { "Snacks" },
          },
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
end

---@param servers table<string, table>
local update_server_configs = function(servers)
  local capabilities = require("plugins.pde.attach").capabilities
  for name, conf in pairs(servers) do
    local config = conf or {}
    config.capabilities =
      vim.tbl_deep_extend("force", {}, capabilities, config.capabilities or {})
    vim.lsp.config(name, config)
  end
end

---@param server_names string[]
---@param servers table<string, table>
local enable_servers = function(server_names, servers)
  for _, name in ipairs(server_names) do
    if servers[name] then
      vim.lsp.enable(name)
    else
      vim.notify("Skipping unknown LSP server in profile: " .. name, vim.log.levels.WARN)
    end
  end
end

---@param package_names string[]
local install_mason_packages = function(package_names)
  if #package_names == 0 then
    return
  end

  local registry = require("mason-registry")
  registry.refresh()

  for _, package_name in ipairs(package_names) do
    local ok, pkg = pcall(registry.get_package, package_name)
    if ok and not pkg:is_installed() then
      pkg:install()
    end
  end
end

local lsp_setup = function()
  local profile_config = require("vvn.profile_config")

  local server_configs = get_server_configs()
  update_server_configs(server_configs)
  enable_servers(profile_config.get_enabled_lsp_servers(), server_configs)

  if profile_config.enable_mason_installs() then
    install_mason_packages(profile_config.get_mason_packages())
  end

  setup_lsp_keymaps()
  setup_diagnostic_config()

  require("which-key").add({
    "<leader>l",
    group = "[L]SP",
  })
end

local M = {
  {
    -- https://github.com/mason-org/mason.nvim
    "mason-org/mason.nvim",
    cmd = {
      "Mason",
      "MasonInstall",
      "MasonInstallAll",
      "MasonUninstall",
      "MasonUninstallAll",
      "MasonUpdate",
    },
    opts = {
      ui = {
        icons = {
          server_installed = "✓",
          server_pending = "➜",
          server_uninstalled = "✗",
        },
      },
    },
  },
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
