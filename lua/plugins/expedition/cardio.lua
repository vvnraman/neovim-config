local M = {
  {
    -- https://github.com/jinh0/eyeliner.nvim
    "jinh0/eyeliner.nvim",
    event = "VeryLazy",
    config = function()
      require("eyeliner").setup({
        highlight_on_key = true,
        dim = true,
      })
    end,
  },
  {
    -- https://github.com/tpope/vim-repeat
    "tpope/vim-repeat",
  },
  {
    -- https://github.com/folke/flash.nvim
    "folke/flash.nvim",
    event = "VeryLazy",
    config = function()
      ---@module "flash"
      ---@type Flash.Config
      local opts = {}
      local flash = require("flash")
      flash.setup(opts)
      vim.keymap.set({ "n", "x", "o" }, "s", function()
        flash.jump({ search = { forward = true, wrap = false, multi_window = false } })
      end, { desc = "Flash forward" })
      vim.keymap.set({ "n", "x", "o" }, "S", function()
        flash.jump({ search = { forward = false, wrap = false, multi_window = false } })
      end, { desc = "Flash backward" })
      vim.keymap.set({ "n", "x", "o" }, "<C-m>", function()
        flash.jump({ pattern = vim.fn.expand("<cword>") })
      end, { desc = "Flash current word" })
      vim.keymap.set({ "n", "x", "o" }, "<C-t>", function()
        flash.treesitter()
      end, { desc = "Flash Treesitter" })
      vim.keymap.set({ "n", "x", "o" }, "<C-h>", function()
        flash.jump({
          search = { mode = "search", max_length = 0 },
          label = { after = { 0, 0 } },
          pattern = "^",
        })
      end, { desc = "Flash lines" })
      vim.keymap.set("o", "r", function()
        flash.remote()
      end, { desc = "Remote Flash" })
      vim.keymap.set({ "x", "o" }, "R", function()
        flash.treesitter_search()
      end, { desc = "Treesitter Search" })
      vim.keymap.set("c", "<C-s>", function()
        flash.toggle()
      end, { desc = "Toggle Flash Search" })
    end,
  },
}

return M
