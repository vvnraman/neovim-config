---@class VvnBufUtilModule
---@field find_window_for_buffer fun(bufnr: integer): integer|nil
---@field focus_buffer fun(bufnr: integer): boolean
---@field current_buffer_dir fun(): string

---@type VvnBufUtilModule
local M = {}

---@param bufnr integer
---@return integer|nil
M.find_window_for_buffer = function(bufnr)
  for _, tabpage in ipairs(vim.api.nvim_list_tabpages()) do
    for _, winid in ipairs(vim.api.nvim_tabpage_list_wins(tabpage)) do
      if vim.api.nvim_win_get_buf(winid) == bufnr then
        return winid
      end
    end
  end

  return nil
end

---@param bufnr integer
---@return boolean
M.focus_buffer = function(bufnr)
  if not vim.api.nvim_buf_is_valid(bufnr) then
    return false
  end

  local winid = M.find_window_for_buffer(bufnr)
  if winid and vim.api.nvim_win_is_valid(winid) then
    vim.api.nvim_set_current_win(winid)
    return true
  end

  vim.api.nvim_set_current_buf(bufnr)
  return true
end

---@return string
M.current_buffer_dir = function()
  return vim.fn.expand("%:p:h")
end

return M
