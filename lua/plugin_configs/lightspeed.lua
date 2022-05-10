-- https://github.com/ggandor/lightspeed.nvim
local ok, lightspeed = pcall(require, "lightspeed")
if not ok then
    if PLUGIN_MISSING_NOTIFY then
        print('"ggandor/lightspeed.nvim" not available')
    end
    return
end
lightspeed.setup({})
