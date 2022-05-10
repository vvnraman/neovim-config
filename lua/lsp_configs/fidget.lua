-- https://github.com/j-hui/fidget.nvim
local ok, fidget = pcall(require, "fidget")
if not ok then
    return
end
fidget.setup()
