-- Only generic keymaps are set here. Most of the other ones are set alongside
-- the corresponding plugin setup.

-- These two are useful for navigating very long lines which wrap around
VIM_KEYMAP_SET({ "n" }, "j", "gj", NOREMAP)
VIM_KEYMAP_SET({ "n" }, "k", "gk", NOREMAP)

-- Esc on jk as well
VIM_KEYMAP_SET({ "i" }, "jk", "<Esc>", NOREMAP)

-- Resize with arrows
VIM_KEYMAP_SET({ "n" }, "<C-Up>", "<Cmd>resize -4<Cr>", NOREMAP_SILENT)
VIM_KEYMAP_SET({ "n" }, "<C-Down>", "<Cmd>resize +4<Cr>", NOREMAP_SILENT)
VIM_KEYMAP_SET(
    { "n" },
    "<C-Left>",
    "<Cmd>vertical resize -4<Cr>",
    NOREMAP_SILENT
)
VIM_KEYMAP_SET(
    { "n" },
    "<C-Right>",
    "<Cmd>vertical resize +4<Cr>",
    NOREMAP_SILENT
)
