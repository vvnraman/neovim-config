local M = {
  {
    -- https://github.com/folke/trouble.nvim
    "folke/trouble.nvim",
    event = "VeryLazy",
    dependencies = {
      {
        -- spec elsewhere
        "nvim-tree/nvim-web-devicons",
      },
      {
        -- spec elsewhere
        "folke/which-key.nvim",
      },
    },
    config = function()
      local trouble = require("trouble")
      require("which-key").register({
        ["[q"] = {
          function()
            trouble.previous({ skip_groups = true, jump = true })
          end,
          "trouble: previous",
        },
        ["]q"] = {
          function()
            trouble.next({ skip_groups = true, jump = true })
          end,
          "trouble: next",
        },
      }, {})

      require("which-key").register({
        x = {
          name = "+Trouble",
          x = {
            function()
              trouble.toggle()
            end,
            "Trouble: Toggle",
          },
          f = {
            function()
              trouble.toggle("lsp_references")
            end,
            "Trouble: LSP Re[f]erences",
          },
          d = {
            function()
              trouble.toggle("document_diagnostics")
            end,
            "Trouble: [D]document Diagnostics",
          },
          w = {
            function()
              trouble.toggle("workspace_diagnostics")
            end,
            "Trouble: [W]orkspace Diagnostics",
          },
          q = {
            function()
              trouble.toggle("quickfix")
            end,
            "Trouble: Toggle [Q]uickfix",
          },
          l = {
            function()
              trouble.toggle("loclist")
            end,
            "Trouble: Toggle [L]ocation List",
          },
        },
      }, { prefix = "<leader>" })
    end,
  },
}

return M
