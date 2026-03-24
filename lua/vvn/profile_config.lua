local profile = require("vvn.profile")
local log = require("vvn.log")

---@class VvnProfileTreesitterConfig
---@field ensure_installed string[]

---@class VvnProfileLspConfig
---@field enabled_servers string[]
---@field allow_mason_installs boolean
---@field ensure_mason_packages string[]

---@class VvnProfileConfig
---@field treesitter VvnProfileTreesitterConfig
---@field lsp VvnProfileLspConfig

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
  },
}

---@param context string
---@return VvnProfileConfig
local get_profile_config = function(context)
  local current = profile.get_name()
  local resolved_profile = current
  if not CONFIG_BY_PROFILE[current] then
    resolved_profile = "standard"
  end

  log.info(string.format("Using profile '%s' for context '%s'", resolved_profile, context))
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

---@return string
M.get_mason_install_root_dir = function()
  local install_root
  local global_install_enabled = vim.env.VVN_NVIM_MASON_GLOBAL_INSTALL == "1"

  if global_install_enabled then
    local env_root = vim.env.VVN_NVIM_MASON_INSTALL_ROOT
    local global_root = env_root or "~/.local/share/nvim/mason-global/"
    install_root = vim.fs.normalize(vim.fn.expand(global_root))
  else
    install_root = vim.fs.joinpath(vim.fn.stdpath("data"), "mason")
  end

  log.info(string.format("Using mason install root '%s'", install_root))
  return install_root
end

return M
