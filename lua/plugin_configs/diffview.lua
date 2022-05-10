-- https://github.com/sindrets/diffview.nvim
local ok, diffview = pcall(require, "zen-mode")
if not ok then
    return
end
diffview.setup({})
