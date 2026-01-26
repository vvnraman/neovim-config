local M = {
  {
    -- https://github.com/j-hui/fidget.nvim
    "j-hui/fidget.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = true,
  },
  -- Disabled 2026-02-01
  -- {
  --   -- https://github.com/aznhe21/actions-preview.nvim
  --   "aznhe21/actions-preview.nvim",
  --   event = { "BufReadPre", "BufNewFile" },
  --   dependencies = {
  --     {
  --       -- spec elsewhere
  --       "nvim-telescope/telescope.nvim",
  --     },
  --   },
  --   config = function()
  --     require("actions-preview").setup({
  --       telescope = require("telescope.themes").get_dropdown({
  --         winblend = 20,
  --       }),
  --     })
  --   end,
  -- },
  {
    -- https://github.com/rachartier/tiny-inline-diagnostic.nvim
    "rachartier/tiny-inline-diagnostic.nvim",
    event = "VeryLazy",
    priority = 1000,
    config = function()
      require("tiny-inline-diagnostic").setup({
        preset = "powerline",
        options = {
          show_source = {
            enabled = false,
            if_many = true,
          },
          add_messages = {
            display_count = true,
          },
          multilines = {
            enabled = true,
          },
        },
        override_open_float = true,
      })
      vim.diagnostic.config({ virtual_text = false })
    end,
  },
  {
    -- https://github.com/rachartier/tiny-code-action.nvim
    "rachartier/tiny-code-action.nvim",
    dependencies = {
      { "nvim-lua/plenary.nvim" },
      { "folke/snacks.nvim" },
    },
    event = "LspAttach",
    opts = {
      picker = "snacks",
    },
  },
  {
    -- https://github.com/stevearc/aerial.nvim
    "stevearc/aerial.nvim",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
    },
    -- event = "LspAttach",
    config = function()
      require("aerial").setup({
        on_attach = function(bufnr)
          vim.keymap.set(
            "n",
            "{",
            "<Cmd>AerialPrev<CR>",
            { buffer = bufnr, desc = "Aerial Previous" }
          )
          vim.keymap.set(
            "n",
            "}",
            "<Cmd>AerialNext<CR>",
            { buffer = bufnr, desc = "Aerial Next" }
          )
        end,
      })
      vim.keymap.set("n", "\\a", "<Cmd>AerialToggle!<CR>", { desc = "Aerial Toggle" })
    end,
  },
}

return M
