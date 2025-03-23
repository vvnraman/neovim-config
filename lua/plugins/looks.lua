local M = {
  {
    -- https://github.com/folke/zen-mode.nvim
    "folke/zen-mode.nvim",
    event = "VeryLazy",
    config = function()
      require("zen-mode").setup()
      vim.keymap.set(
        { "n" },
        "<leader>zm",
        "<Cmd>ZenMode<Cr>",
        NOREMAP_SILENT("Toggle ZenMode")
      )
    end,
  },
  {
    -- https://github.com/folke/twilight.nvim
    "folke/twilight.nvim",
    event = "VeryLazy",
    config = function()
      require("twilight").setup({
        context = 15, -- amount of lines to show around the current line
      })
    end,
  },
  {
    -- https://github.com/lukas-reineke/indent-blankline.nvim
    "lukas-reineke/indent-blankline.nvim",
    event = "VeryLazy",
    config = function()
      require("ibl").setup({
        indent = { char = "▏" },
      })
    end,
  },
  {
    -- https://github.com/lukas-reineke/virt-column.nvim
    "lukas-reineke/virt-column.nvim",
    event = "VeryLazy",
    config = function()
      require("virt-column").setup()
      -- TODO: Set this up to a specific column for interesting file types
      --       Also, look up my old vim config's `colorcolumn` for inspiration
    end,
  },
  {
    -- https://github.com/folke/todo-comments.nvim
    "folke/todo-comments.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = true,
  },
  {
    -- https://github.com/lukas-reineke/headlines.nvim
    "lukas-reineke/headlines.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = true,
  },
  {
    -- https://github.com/RRethy/vim-illuminate
    "RRethy/vim-illuminate",
    event = "VeryLazy",
    config = function()
      local ilmn = require("illuminate")
      ilmn.configure({
        delay = 250,
        filetype_denylist = {
          "markdown",
          "rst",
        },
        min_count_to_highlight = 2,
      })

      vim.keymap.set("n", "<C-p>", ilmn.goto_prev_reference, { desc = "illuminate: [p]rev" })
      vim.keymap.set("n", "<C-n>", ilmn.goto_next_reference, { desc = "illuminate: [n]ext" })
    end,
  },
}

return M
