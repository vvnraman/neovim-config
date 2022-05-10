-- 'nvim-lualine/lualine.nvim'
local ok, lualine = pcall(require, "lualine")
if not ok then
    print('"nvim-lualine/lualine.nvim" not available')
    return
end
lualine.setup()
