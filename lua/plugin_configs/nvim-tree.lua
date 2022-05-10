-- 'kyazdani42/nvim-tree.lua'

local ok, nvim_tree = pcall(require, "nvim-tree")
if not ok then
    print('"kyazdani42/nvim-tree.lua" not available')
    return
end
nvim_tree.setup({
    disable_netrw = true,
    hijack_netrw = true,
    update_cwd = true,
    update_focused_file = {
        enable = true,
        update_cwd = true,
        ignore_list = {},
    },
    diagnostics = {
        enable = true,
        icons = {
            hint = "",
            info = "",
            warning = "",
            error = "",
        },
    },
    actions = {
        open_file = {
            resize_window = true,
        },
    },
})
