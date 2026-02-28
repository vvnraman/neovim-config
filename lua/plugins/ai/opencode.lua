local M = {
  {
    -- https://github.com/nickjvandyke/opencode.nvim
    "nickjvandyke/opencode.nvim",
    dependencies = {
      {
        -- https://github.com/folke/snacks.nvim
        "folke/snacks.nvim",
      },
    },
    config = function()
      ---@type opencode.Opts
      vim.g.opencode_opts = vim.tbl_deep_extend("force", vim.g.opencode_opts or {}, {
        server = {
          start = false,
          stop = false,
          toggle = false,
        },
        select = {
          sections = {
            server = false,
          },
        },
      })

      local opencode = require("opencode")

      vim.keymap.set({ "n", "x" }, "<leader>ai", function()
        opencode.ask("@this: ")
      end, { desc = "[a]i ask about @this" })

      vim.keymap.set({ "n", "x" }, "<leader>aa", function()
        opencode.prompt("@this\n", { submit = false, clear = false })
      end, { desc = "[a]i [a]ppend @this with a new line" })

      vim.keymap.set("n", "<leader>as", function()
        opencode.command("prompt.submit")
      end, { desc = "[a]i [s]ubmit prompt" })

      vim.keymap.set("n", "<leader>ac", function()
        opencode.command("prompt.clear")
      end, { desc = "[a]i [c]lear prompt" })

      vim.keymap.set("n", "<leader>al", function()
        opencode.select()
      end, { desc = "[a]i [s]elect action" })

      vim.keymap.set({ "n", "x" }, "<leader>ae", function()
        opencode.prompt("explain")
      end, { desc = "[a]i [e]xplain @this" })

      -- TODO: This should be tied to my :VvnYank setup to allow batch reviewing of all changes
      -- vim.keymap.set({ "n", "x" }, "<leader>ar", function()
      --   opencode.prompt("review")
      -- end, { desc = "[a]i [r]eview @this" })

      vim.keymap.set("n", "<leader>af", function()
        opencode.prompt("fix")
      end, { desc = "[a]i [f]ix diagnostics" })

      -- TODO: Add `gl` to my `:VvnYank` setup to do the same without leader
      vim.keymap.set({ "n", "x" }, "go", function()
        return opencode.operator("@this ")
      end, { desc = "opencode add range", expr = true })

      -- TODO: Add `gll` to my `:VvnYank` setup to do the same without leader
      vim.keymap.set("n", "goo", function()
        return opencode.operator("@this ") .. "_"
      end, { desc = "opencode add line", expr = true })

      --[[
      We have integration with snacks picker, but we're not using it for everything.
      What it does is send selected entries from the picker to opencode, so its useful when
      we're using it filter files, or lines of code and keep sending interesting items to
      opencode.

      actions = {
        opencode_send = function(...)
          return require("opencode").snacks_picker_send(...)
        end,
      },
      win = {
        input = {
          keys = {
            ["<A-a>"] = { "opencode_send", mode = { "n", "i" } },
          },
        },
      },
      --]]
    end,
  },
}

return M
