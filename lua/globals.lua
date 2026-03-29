-- Common options we'll pass to vim.keymap.set() method
NOREMAP = function(desc)
  return { noremap = true, desc = desc }
end

NOREMAP_SILENT = function(desc)
  return { noremap = true, silent = true, desc = desc }
end
