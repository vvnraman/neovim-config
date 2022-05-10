-- 'windwp/nvim-autopairs'
local ok, _ = pcall(require, "nvim-autopairs")
if not ok then
    print('"windwp/nvim-autopairs.nvim" not available')
    return
end
require("nvim-autopairs").setup()
