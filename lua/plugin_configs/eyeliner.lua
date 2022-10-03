-- https://github.com/jinh0/eyeliner.nvim
local ok, eyeliner = pcall(require, "eyeliner")
if not ok then
    return
end
eyeliner.setup({
    highlight_on_key = true,
})
