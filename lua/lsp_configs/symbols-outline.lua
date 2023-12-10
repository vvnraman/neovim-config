-- https://github.com/simrat39/symbols-outline.nvim
local ok, symbols_outline = pcall(require, "symbols-outline")
if not ok then
    return
end

symbols_outline.setup()

VIM_KEYMAP_SET({ "n" }, "<leader>so", "<Cmd>SymbolsOutline<Cr>")
