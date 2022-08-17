-- https://github.com/folke/trouble.nvim
-- SIMPLY AMAZING
local ok, trouble = pcall(require, "trouble")
if not ok then
    print('"folke/trouble.nvim" not available')
    return
end
trouble.setup()

VIM_KEYMAP_SET({ "n" }, "<leader>xx", "<Cmd>TroubleToggle<Cr>", NOREMAP_SILENT)
VIM_KEYMAP_SET(
    { "n" },
    "<leader>xd",
    "<Cmd>TroubleToggle document_diagnostics<Cr>",
    NOREMAP_SILENT
)
VIM_KEYMAP_SET(
    { "n" },
    "<leader>xw",
    "<Cmd>TroubleToggle workspace_diagnostics<Cr>",
    NOREMAP_SILENT
)
VIM_KEYMAP_SET(
    { "n" },
    "<leader>xl",
    "<Cmd>TroubleToggle loclist<Cr>",
    NOREMAP_SILENT
)
VIM_KEYMAP_SET(
    { "n" },
    "<leader>xq",
    "<Cmd>TroubleToggle quickfix<Cr>",
    NOREMAP_SILENT
)
VIM_KEYMAP_SET({ "n" }, "gR", "<Cmd>Trouble lsp_references<Cr>", NOREMAP_SILENT)
