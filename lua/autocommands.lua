-- [[ Highlight on yank ]]
local setup_highlight_on_yank = function()
  -- See `:help vim.highlight.on_yank()`
  local augroup = vim.api.nvim_create_augroup("vvn.YankHighlight", { clear = true })
  vim.api.nvim_create_autocmd("TextYankPost", {
    callback = function()
      vim.highlight.on_yank()
    end,
    group = augroup,
    pattern = "*",
  })
end

local highlight_active_buffer_cursor_line = function()
  local augroup = vim.api.nvim_create_augroup("vvn.cursor_line", { clear = true })
  vim.api.nvim_create_autocmd({"VimEnter", "WinEnter", "BufWinEnter"}, {
    desc = "Highlight cursor line in active window",
    pattern = "*",
    command = "setlocal cursorline",
    group = augroup,
  })

  vim.api.nvim_create_autocmd("WinLeave", {
    desc = "Clear cursor line highlight when leaving window",
    pattern = "*",
    command = "if &bt != 'quickfix' | setlocal nocursorline | endif",
    group = augroup,
  })
end

setup_highlight_on_yank()
highlight_active_buffer_cursor_line()

