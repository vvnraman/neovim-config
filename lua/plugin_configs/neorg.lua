-- https://github.com/nvim-neorg/neorg
local ok, neorg = pcall(require, "neorg")
if not ok then
    return
end

neorg.setup({
    load = {
        ["core.defaults"] = {},
        ["core.norg.concealer"] = {},
        ["core.norg.dirman"] = {
            config = {
                workspaces = {
                    home = "~/code/neorg/",
                },
                default_workspace = "home",
                index = "index.norg",
            },
        },
        ["core.norg.journal"] = {
            config = {
                workspace = "home",
                journal_folder = "journal",
            },
        },
    },
})
