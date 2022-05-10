-- https://github.com/lukas-reineke/virt-column.nvim
local ok, virt_column = pcall(require, "virt-column")
if not ok then
    return
end
virt_column.setup({})
