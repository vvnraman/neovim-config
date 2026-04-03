local M = {
  {
    -- https://github.com/folke/snacks.nvim
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    config = function()
      ---@module "snacks"
      ---@type snacks.Config
      local opts = {
        input = {
          enabled = true,
          win = {
            relative = "cursor",
          },
        },
        notifier = {
          enabled = true,
        },
        picker = {
          enabled = true,
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
            list = { wo = { winblend = 20 } },
            preview = { wo = { winblend = 10 } },
          },
        },
      }
      require("snacks").setup(opts)

      vim.keymap.set("n", "<leader>nh", function()
        Snacks.notifier.show_history()
      end, { desc = "Show notification history", noremap = true })

      vim.keymap.set("n", "<leader>ne", function()
        Snacks.notifier.show_history({ filter = vim.log.levels.ERROR })
      end, { desc = "Show error history", noremap = true })

      vim.keymap.set("n", "<leader>nn", function()
        Snacks.scratch()
      end, { desc = "Toggle Scratch buffer" })
      vim.keymap.set("n", "<leader>ns", function()
        Snacks.scratch.select()
      end, { desc = "Select Scratch buffer" })
    end,
  },
}

return M
