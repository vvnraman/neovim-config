-- Only generic keymaps are set here. Most of the other ones are set alongside
-- the corresponding plugin setup.


-- These two are useful for navigating very long lines which wrap around
VIM_KEYMAP_SET({'n'}, 'j', 'gj', NOREMAP)
VIM_KEYMAP_SET({'n'}, 'k', 'gk', NOREMAP)

-- Esc on jk as well
VIM_KEYMAP_SET({'i'}, 'jk', '<Esc>', NOREMAP)

-- Change current working directory to that of the current buffer
VIM_KEYMAP_SET({'n'}, '<leader>cd', ':cd %:p:h<cr>:pwd<cr>', NOREMAP_SILENT)

-- Resize with arrows
VIM_KEYMAP_SET({"n"}, "<C-Up>", "<Cmd>resize -2<Cr>", NOREMAP_SILENT)
VIM_KEYMAP_SET({"n"}, "<C-Down>", "<Cmd>resize +2<Cr>", NOREMAP_SILENT)
VIM_KEYMAP_SET({"n"}, "<C-Left>", "<Cmd>vertical resize -2<Cr>", NOREMAP_SILENT)
VIM_KEYMAP_SET({"n"}, "<C-Right>", "<Cmd>vertical resize +2<Cr>", NOREMAP_SILENT)

-- Move text up and down
-- FIXME: Doesn't work as I expect it to
-- VIM_KEYMAP_SET({"n"}, "<A-j>", "<Esc><Cmd>move .+1<CR>==gi", NOREMAP_SILENT)
-- VIM_KEYMAP_SET({"n"}, "<A-k>", "<Esc><Cmd>move .-2<CR>==gi", NOREMAP_SILENT)
-- VIM_KEYMAP_SET({"v"}, "<A-j>", "<Cmd>move .+1<CR>==", NOREMAP_SILENT)
-- VIM_KEYMAP_SET({"v"}, "<A-k>", "<Cmd>move .-2<CR>==", NOREMAP_SILENT)
-- VIM_KEYMAP_SET({"v"}, "p", '"_dP', NOREMAP_SILENT)
-- VIM_KEYMAP_SET({"x"}, "J", "<Cmd>move '>+1<CR>gv-gv", NOREMAP_SILENT)
-- VIM_KEYMAP_SET({"x"}, "K", "<Cmd>move '<-2<CR>gv-gv", NOREMAP_SILENT)
-- VIM_KEYMAP_SET({"x"}, "<A-j>", "<Cmd>move '>+1<CR>gv-gv", NOREMAP_SILENT)
-- VIM_KEYMAP_SET({"x"}, "<A-k>", "<Cmd>move '<-2<CR>gv-gv", NOREMAP_SILENT)
