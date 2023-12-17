-- [[ Change current working directory to that of the current buffer ]]
local change_current_working_directory_to_that_of_current_buffer = function()
  local augroup_all_files = vim.api.nvim_create_augroup(
    "augroup_all_files",
    { clear = true }
  )
  vim.api.nvim_create_autocmd({ "BufEnter" }, {
    group = augroup_all_files,
    pattern = "*.*",
    command = "lcd %:p:h",
  })
end

-- [[ Highlight on yank ]]
local setup_highlight_on_yank = function()
  -- See `:help vim.highlight.on_yank()`
  local highlight_group = vim.api.nvim_create_augroup(
    "YankHighlight",
    { clear = true }
  )
  vim.api.nvim_create_autocmd("TextYankPost", {
    callback = function()
      vim.highlight.on_yank()
    end,
    group = highlight_group,
    pattern = "*",
  })
end

setup_highlight_on_yank()
