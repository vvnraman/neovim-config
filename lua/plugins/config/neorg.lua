local M = {}

M.setup = function()
  local neorg = require("neorg")
  neorg.setup({
    load = {
      ["core.defaults"] = {},
      ["core.dirman"] = {
        config = {
          workspaces = {
            home = "~/code/neorg/",
          },
          default_workspace = "home",
          index = "index.norg",
        },
      },
      ["core.concealer"] = { config = { icon_preset = "diamond" } },
      ["core.completion"] = {
        config = { engine = "nvim-cmp", name = "[Norg]" },
      },
      ["core.integrations.nvim-cmp"] = {},
    },
  })
end

return M
