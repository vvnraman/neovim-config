-- Common options we'll pass to vim.keymap.set() method
NOREMAP = function(desc)
  return { noremap = true, desc = desc }
end

NOREMAP_SILENT = function(desc)
  return { noremap = true, silent = true, desc = desc }
end

COND_KEYAMP = function(plugin, mode, lhs, rhs, opts)
  local ok, _ = pcall(require, plugin)
  if ok then
    vim.keymap.set(mode, lhs, rhs, opts)
  end
end
