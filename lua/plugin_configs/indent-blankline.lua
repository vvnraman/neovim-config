-- 'lukas-reineke/indent-blankline.nvim'
local ok, indent_blankline = pcall(require, "indent_blankline")
if not ok then
    print('"lukas-reineke/indent-blankline.nvim" not available')
    return
end
indent_blankline.setup({
    char = "┊",
})
