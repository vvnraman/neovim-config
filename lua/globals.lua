-- Common options we'll pass to vim.keymap.set() method
NOREMAP = function(desc)
  return { noremap = true, desc = desc }
end

NOREMAP_SILENT = function(desc)
  return { noremap = true, silent = true, desc = desc }
end

GET_CURRENT_LINE = function()
  return vim.fn.line(".") - 1 -- 0 based
end

GET_CURRENT_FILE_PATH = function()
  local bufname = vim.api.nvim_buf_get_name(0)
  if bufname == "" then
    return nil
  end
  local resolved_name = vim.uv.fs_realpath(bufname)
  return resolved_name or bufname
end
