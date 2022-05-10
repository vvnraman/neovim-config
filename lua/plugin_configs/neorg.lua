-- https://github.com/nvim-neorg/neorg
local ok, neorg = pcall(require, "neorg")
if not ok then
    return
end

neorg.setup({
    load = {
        ["core.defaults"] = {},
        ["core.norg.dirman"] = {
            config = {
                workspaces = {
                    home = "~/code/neorg/",
                },
            },
        },
        ["core.norg.journal"] = {
            config = {
                workspace = "home",
                journal_folder = "journal",
            },
        },
        ["core.gtd.base"] = {
            config = {
                workspace = "home",
            },
        },
    },
})
