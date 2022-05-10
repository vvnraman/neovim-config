-- https://github.com/folke/zen-mode.nvim
local ok, zen_mode = pcall(require, "zen-mode")
if not ok then
    if PLUGIN_MISSING_NOTIFY then
        print("'folke/zen-mode.nvim not available")
    end
    return
end
zen_mode.setup()
VIM_KEYMAP_SET({ "n" }, "<leader>zm", "<Cmd>ZenMode<Cr>", NOREMAP_SILENT)
