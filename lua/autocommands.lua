-- Change current working directory to that of the current buffer
local change_cwd_to_curr_file = vim.api.nvim_create_augroup(
    "au_all_files",
    { clear = true }
)
vim.api.nvim_create_autocmd({ "BufEnter" }, {
    group = change_cwd_to_curr_file,
    pattern = "*",
    command = "lcd %:p:h",
})
