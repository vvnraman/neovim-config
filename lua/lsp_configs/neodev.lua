-- https://github.com/folke/neodev.nvim
local ok, neodev = pcall(require, "neodev")
if not ok then
    return
end

neodev.setup({})
