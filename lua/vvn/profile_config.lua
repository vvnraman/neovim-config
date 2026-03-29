local profile = require("vvn.profile")

---@class VvnProfileTreesitterConfig
---@field ensure_installed string[]

---@class VvnProfileLspConfig
---@field enabled_servers string[]
---@field allow_mason_installs boolean
---@field ensure_mason_packages string[]

---@class VvnTelescopeFilters
---@field rg_globs string[]
---@field fd_excludes string[]

---@class VvnProfileConfig
---@field treesitter VvnProfileTreesitterConfig
---@field lsp VvnProfileLspConfig
---@field telescope_filters VvnTelescopeFilters
---@field plugin_specs table[]

local M = {}

---@type table<string, VvnProfileConfig>
local CONFIG_BY_PROFILE = {
  minimal = {
    treesitter = {
      ensure_installed = {
        "bash",
        "c",
        "cpp",
        "fish",
        "go",
        "gotmpl",
        "ini",
        "json",
        "json",
        "lua",
        "markdown",
        "rst",
        "ssh_config",
        "templ",
        "tmux",
        "toml",
        "typescript",
        "vim",
        "yaml",
      },
    },
    lsp = {
      enabled_servers = {
        "basedpyright",
        "bashls",
        "clangd",
        "cmake",
        "gopls",
        "lua_ls",
        "ts_ls",
      },
      allow_mason_installs = false,
      ensure_mason_packages = {},
    },
    telescope_filters = {
      rg_globs = {
        "!**/.git/*",
      },
      fd_excludes = {
        ".git/",
      },
    },
    plugin_specs = {},
  },
  standard = {
    treesitter = {
      ensure_installed = {
        "bash",
        "c",
        "cmake",
        "comment",
        "cpp",
        "desktop",
        "fish",
        "go",
        "gotmpl",
        "hjson",
        "hyprlang",
        "html",
        "ini",
        "json",
        "jq",
        "lua",
        "markdown",
        "mermaid",
        "norg",
        "regex",
        "rst",
        "sql",
        "ssh_config",
        "templ",
        "tmux",
        "toml",
        "typescript",
        "udev",
        "vim",
        "yaml",
        "zig",
      },
    },
    lsp = {
      enabled_servers = {
        "clangd",
        "lua_ls",
        "jsonls",
        "bashls",
        "gopls",
        "cmake",
        "dockerls",
        "dotls",
        "basedpyright",
        "ts_ls",
        "vimls",
        "yamlls",
      },
      allow_mason_installs = true,
      ensure_mason_packages = {
        "clangd",
        "lua-language-server",
        "json-lsp",
        "bash-language-server",
        "gopls",
        "cmake-language-server",
        "dockerfile-language-server",
        "dot-language-server",
        "basedpyright",
        "typescript-language-server",
        "vim-language-server",
        "yaml-language-server",
        "stylua",
        "shfmt",
        "shellcheck",
      },
    },
    telescope_filters = {
      rg_globs = {
        "!**/.git/*",
      },
      fd_excludes = {
        ".git/",
      },
    },
    plugin_specs = {},
  },
}

---@param context string
---@return VvnProfileConfig
---@diagnostic disable-next-line: unused-local
local get_profile_config = function(context)
  local current = profile.get_name()
  local resolved_profile = current
  if not CONFIG_BY_PROFILE[current] then
    resolved_profile = "standard"
  end

  -- log.info(string.format("Using profile '%s' for context '%s'", resolved_profile, context))
  return CONFIG_BY_PROFILE[resolved_profile]
end

---@return string[]
M.get_treesitter_ensure_installed = function()
  return vim.deepcopy(get_profile_config("treesitter").treesitter.ensure_installed)
end

---@return string[]
M.get_enabled_lsp_servers = function()
  return vim.deepcopy(get_profile_config("enabled_lsp_servers").lsp.enabled_servers)
end

---@return boolean
M.enable_mason_installs = function()
  ---@type VvnProfileLspConfig
  local cfg = get_profile_config("mason_installs").lsp
  local env_auto_install = vim.env.NVIM_MASON_AUTO_INSTALL

  if env_auto_install ~= nil then
    return env_auto_install == "1"
  end

  return cfg.allow_mason_installs
end

---@return string[]
M.get_mason_packages = function()
  return vim.deepcopy(get_profile_config("mason_packages").lsp.ensure_mason_packages)
end

---@param base string[]
---@param extra string[]
---@return string[]
local merge_unique = function(base, extra)
  ---@type table<string, boolean>
  local seen = {}
  ---@type string[]
  local merged = {}

  for _, item in ipairs(base) do
    if not seen[item] then
      seen[item] = true
      table.insert(merged, item)
    end
  end

  for _, item in ipairs(extra) do
    if not seen[item] then
      seen[item] = true
      table.insert(merged, item)
    end
  end

  return merged
end

---@return VvnTelescopeFilters
M.get_telescope_filters = function()
  local base = vim.deepcopy(get_profile_config("telescope_filters").telescope_filters)

  local ok, user_filters = pcall(require, "vvn.user-config.telescope_filters")
  if not ok or type(user_filters) ~= "table" then
    return base
  end

  ---@type string[]
  local user_rg_globs = type(user_filters.rg_globs) == "table" and user_filters.rg_globs or {}
  ---@type string[]
  local user_fd_excludes = type(user_filters.fd_excludes) == "table"
      and user_filters.fd_excludes
    or {}

  return {
    rg_globs = merge_unique(base.rg_globs, user_rg_globs),
    fd_excludes = merge_unique(base.fd_excludes, user_fd_excludes),
  }
end

---@param values table[]
---@return table[]
local merge_specs = function(values)
  ---@type table[]
  local merged = {}
  for _, value in ipairs(values) do
    table.insert(merged, value)
  end
  return merged
end

---@return table[]
M.get_plugin_specs = function()
  local base = vim.deepcopy(get_profile_config("plugin_specs").plugin_specs)

  local ok_os, os_specs = pcall(require, "vvn.os-config.plugin_specs")
  if not ok_os or type(os_specs) ~= "table" then
    os_specs = {}
  end

  local ok_user, user_specs = pcall(require, "vvn.user-config.plugin_specs")
  if not ok_user or type(user_specs) ~= "table" then
    user_specs = {}
  end

  local merged = merge_specs(base)
  vim.list_extend(merged, merge_specs(os_specs))
  vim.list_extend(merged, merge_specs(user_specs))
  return merged
end

---@return string
M.get_mason_install_root_dir = function()
  local install_root
  local global_install_enabled = vim.env.VVN_NVIM_MASON_GLOBAL_INSTALL == "1"

  if global_install_enabled then
    local env_root = vim.env.VVN_NVIM_MASON_INSTALL_ROOT
    local global_root = env_root or "~/.local/share/nvim/mason-global/"
    install_root = vim.fs.normalize(vim.fn.expand(global_root))
    -- log.info(string.format("Using global mason install root '%s'", install_root))
  else
    install_root = vim.fs.joinpath(vim.fn.stdpath("data"), "mason")
  end

  return install_root
end

return M
