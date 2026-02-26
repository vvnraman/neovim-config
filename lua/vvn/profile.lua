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
  local from_nvim_profile = normalize_profile(vim.env.NVIM_PROFILE)
  if from_nvim_profile then
    return from_nvim_profile
  end

  local from_dotfiles_profile = normalize_profile(vim.env.DOTFILES_PROFILE)
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

return M
