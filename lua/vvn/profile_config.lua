local profile = require("vvn.profile")

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

---@return VvnProfileConfig
local get_profile_config = function()
  local current = profile.get_name()
  return CONFIG_BY_PROFILE[current] or CONFIG_BY_PROFILE.standard
end

---@return string[]
M.get_treesitter_ensure_installed = function()
  return vim.deepcopy(get_profile_config().treesitter.ensure_installed)
end

---@return string[]
M.get_enabled_lsp_servers = function()
  return vim.deepcopy(get_profile_config().lsp.enabled_servers)
end

---@return boolean
M.enable_mason_installs = function()
  ---@type VvnProfileLspConfig
  local cfg = get_profile_config().lsp
  if not cfg.allow_mason_installs then
    return false
  end

  return vim.env.NVIM_MASON_AUTO_INSTALL == "1"
end

---@return string[]
M.get_mason_packages = function()
  return vim.deepcopy(get_profile_config().lsp.ensure_mason_packages)
end

return M
