---@class VvnPathUtilModule
---@field exists fun(path: string): boolean
---@field is_file fun(path: string): boolean
---@field is_dir fun(path: string): boolean
---@field dir_or_parent fun(filepath: string): string|nil
---@field relative_to_dir fun(parent_dir: string, abs_path: string): string
---@field get_current_file_path fun(): string|nil

---@type VvnPathUtilModule
local M = {}

local uv = vim.uv or vim.loop

---@param path string
---@return string|nil
local get_path_type = function(path)
  if type(path) ~= "string" or path == "" then
    return nil
  end

  local stat = uv.fs_stat(path)
  return stat and stat.type or nil
end

---@param path string
---@return boolean
M.exists = function(path)
  return get_path_type(path) ~= nil
end

---@param path string
---@return boolean
M.is_file = function(path)
  return get_path_type(path) == "file"
end

---@param path string
---@return boolean
M.is_dir = function(path)
  return get_path_type(path) == "directory"
end

---@param filepath string
---@return string|nil
M.dir_or_parent = function(filepath)
  if not M.exists(filepath) then
    return nil
  end

  if M.is_dir(filepath) then
    return filepath
  end

  if M.is_file(filepath) then
    return vim.fn.fnamemodify(filepath, ":h")
  end

  return nil
end

---@param s string
---@return string
local escape_lua_pattern = function(s)
  return (s:gsub("([^%w])", "%%%1"))
end

---@param parent_dir string
---@param abs_path string
---@return string
M.relative_to_dir = function(parent_dir, abs_path)
  return abs_path:gsub("^" .. escape_lua_pattern(parent_dir) .. "/", "")
end

---@return string|nil
M.get_current_file_path = function()
  local bufname = vim.api.nvim_buf_get_name(0)
  if bufname == "" then
    return nil
  end

  local resolved_name = vim.uv.fs_realpath(bufname)
  return resolved_name or bufname
end

return M
