-- Only generic keymaps are set here. Most of the other ones are set alongside
-- the corresponding plugin setup.

-- These two are useful for navigating very long lines which wrap around
VIM_KEYMAP_SET({ "n" }, "j", "gj", NOREMAP)
VIM_KEYMAP_SET({ "n" }, "k", "gk", NOREMAP)

-- Esc on jk as well
VIM_KEYMAP_SET({ "i" }, "jk", "<Esc>", NOREMAP)

-- Change current working directory to that of the current buffer
local augroup_all_files = vim.api.nvim_create_augroup(
    "augroup_all_files",
    { clear = true }
)
vim.api.nvim_create_autocmd({ "BufEnter" }, {
    group = augroup_all_files,
    pattern = "*",
    command = "lcd %:p:h",
})

-- Return to last edit position when opening files
vim.cmd([[
augroup augroup_all_files_vimscript
  autocmd!
  autocmd BufReadPost *
      \ if line("'\"") > 0 && line("'\"") <= line("$") |
      \   exe "normal! g`\"" |
      \ endif
augroup END
]])

-- Resize with arrows
VIM_KEYMAP_SET({ "n" }, "<C-Up>", "<Cmd>resize -2<Cr>", NOREMAP_SILENT)
VIM_KEYMAP_SET({ "n" }, "<C-Down>", "<Cmd>resize +2<Cr>", NOREMAP_SILENT)
VIM_KEYMAP_SET(
    { "n" },
    "<C-Left>",
    "<Cmd>vertical resize -2<Cr>",
    NOREMAP_SILENT
)
VIM_KEYMAP_SET(
    { "n" },
    "<C-Right>",
    "<Cmd>vertical resize +2<Cr>",
    NOREMAP_SILENT
)
