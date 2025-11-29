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
    -- https://github.com/MeanderingProgrammer/render-markdown.nvim
    "MeanderingProgrammer/render-markdown.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      local rm = require("render-markdown")
      rm.setup({
        completions = {
          lsp = {
            enabled = true,
          },
        },
        anti_conceal = {
          above = 1,
          below = 1,
        },
        link = {
          enabled = false,
        },
      })
      vim.keymap.set(
        "n",
        "<leader>rt",
        rm.toggle,
        { desc = "[r]ender markdown [t]oggle", noremap = true }
      )
    end,
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
  {
    -- https://github.com/norcalli/nvim-colorizer.lua
    -- https://github.com/catgoose/nvim-colorizer.lua
    "catgoose/nvim-colorizer.lua",
    event = "BufReadPre",
    config = function()
      require("colorizer").setup({
        user_default_options = {
          -- Options are "background", "foreground", and "virtualtext"
          mode = "virtualtext",
          virtualtext_inline = "after",
        },
      })

      vim.keymap.set(
        "n",
        "<leader>cc",
        "<Cmd>ColorizerToggle<Cr>",
        { desc = "[c]olorizer [c]olour toggle", noremap = true }
      )

      vim.keymap.set("n", "<leader>cb", function()
        require("colorizer").attach_to_buffer(0, { mode = "background" })
      end, { desc = "[c]olorizer [b]ackground", noremap = true })

      vim.keymap.set("n", "<leader>cf", function()
        require("colorizer").attach_to_buffer(0, { mode = "foreground" })
      end, { desc = "[c]olorizer [f]oreground", noremap = true })

      vim.keymap.set(
        "n",
        "<leader>cd",
        "<Cmd>ColorizerDetachFromBuffer<Cr>",
        { desc = "[c]olorizer [d]etach", noremap = true }
      )
    end,
  },
  {
    -- https://github.com/nvzone/minty
    "nvzone/minty",
    dependencies = {
      -- https://github.com/nvzone/volt
      "nvzone/volt",
    },
    cmd = { "Shades", "Huefy" },
  },
  {
    "nvim-lualine/lualine.nvim", -- status line
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("lualine").setup({})
    end,
  },
  {
    -- https://github.com/folke/snacks.nvim
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = {
      input = {
        enabled = true,
        win = {
          relative = "cursor",
        },
      },
      notifier = {
        enabled = true,
      },
    },
    init = function()
      vim.keymap.set("n", "<leader>nh", function()
        Snacks.notifier.show_history()
      end, { desc = "Show notification history", noremap = true })

      vim.keymap.set("n", "<leader>ne", function()
        Snacks.notifier.show_history({ filter = vim.log.levels.ERROR })
      end, { desc = "Show error history", noremap = true })
    end,
  },
}

return M
