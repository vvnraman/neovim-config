-- Change current working directory to that of the current buffer
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

change_current_working_directory_to_that_of_current_buffer()

-- Return to last edit position when opening files
vim.cmd([[
augroup augroup_all_files_vimscript
  autocmd!
  autocmd BufReadPost *.*
      \ if line("'\"") > 0 && line("'\"") <= line("$") |
      \   exe "normal! g`\"" |
      \ endif
augroup END
]])
