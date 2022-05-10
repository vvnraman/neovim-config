-- 'lewis6991/gitsigns.nvim'
local ok, gitsigns = pcall(require, "gitsigns")
if not ok then
    print('"lewis6991/gitsigns.nvim" not available')
    return
end
gitsigns.setup()
