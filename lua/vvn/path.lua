local M = {}

local Path = require("plenary.path")

M.exists = function(path)
  return Path:new(path).exists()
end

M.is_file = function(path)
  return Path:new(path).is_file()
end

M.is_dir = function(path)
  return Path:new(path).is_dir()
end

M.dir_or_parent = function(filepath)
  local p = Path:new(filepath)
  if not p:exists() then
    return nil
  end
  if p:is_dir() then
    return filepath
  elseif p:is_file() then
    return vim.fn.fnamemodify(filepath, ":h")
  else
    return nil
  end
end

return M
