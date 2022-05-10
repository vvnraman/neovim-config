-- https://github.com/folke/twilight.nvim
local ok, twilight = pcall(require, "twilight")
if not ok then
    if PLUGIN_MISSING_NOTIFY then
        print("'folke/zen-mode.nvim not available")
    end
    return
end
twilight.setup()
