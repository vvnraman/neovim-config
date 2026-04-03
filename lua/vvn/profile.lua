local M = {}

local VALID_PROFILES = {
  minimal = true,
  standard = true,
}

---@param value string|nil
---@return string|nil
local normalize_profile = function(value)
  if not value then
    return nil
  end

  local normalized = string.lower(vim.trim(value))
  if VALID_PROFILES[normalized] then
    return normalized
  end

  return nil
end

---@return string
M.get_name = function()
  local from_nvim_profile = normalize_profile(vim.env.VVN_NVIM_PROFILE)
  if from_nvim_profile then
    return from_nvim_profile
  end

  local from_dotfiles_profile = normalize_profile(vim.env.VVN_DOTFILES_PROFILE)
  if from_dotfiles_profile then
    return from_dotfiles_profile
  end

  if vim.env.CODESPACES == "true" then
    return "minimal"
  end

  return "standard"
end

---@return boolean
M.is_minimal = function()
  return M.get_name() == "minimal"
end

---@return boolean
M.is_standard = function()
  return M.get_name() == "standard"
end

---@return string
M.get_default_lazy_install_root_dir = function()
  return vim.fs.joinpath(vim.fn.stdpath("data"), "lazy")
end

---@return string
M.get_lazy_install_root_dir = function()
  local env_root = vim.env.VVN_NVIM_LAZY_INSTALL_ROOT
  if not env_root or vim.trim(env_root) == "" then
    return M.get_default_lazy_install_root_dir()
  end

  return vim.fs.normalize(vim.fn.expand(env_root))
end

---@return boolean
M.is_shared_lazy_install_root_enabled = function()
  return M.get_lazy_install_root_dir() ~= M.get_default_lazy_install_root_dir()
end

---@return boolean
M.is_shared_lazy_update_allowed = function()
  return vim.env.VVN_NVIM_ALLOW_SHARED_LAZY_UPDATE == "1"
end

return M
