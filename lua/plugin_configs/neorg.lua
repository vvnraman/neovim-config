-- https://github.com/nvim-neorg/neorg
local ok, neorg = pcall(require, "neorg")
if not ok then
    return
end

neorg.setup({
    load = {
        ["core.defaults"] = {},
        ["core.concealer"] = {},
        ["core.dirman"] = {
            config = {
                workspaces = {
                    home = "~/code/neorg/",
                },
                default_workspace = "home",
                index = "index.norg",
            },
        },
        ["core.journal"] = {
            config = {
                workspace = "home",
                journal_folder = "journal",
            },
        },
    },
})
