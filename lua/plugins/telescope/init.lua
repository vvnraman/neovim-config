local M = {
  {
    -- https://github.com/nvim-telescope/telescope.nvim
    "nvim-telescope/telescope.nvim",
    event = "VeryLazy",
    branch = "0.1.x",
    config = function()
      require("plugins.config.telescope").setup()
    end,
    dependencies = {
      {
        "nvim-lua/plenary.nvim",
      },
      {
        -- spec elsewhere
        "folke/which-key.nvim",
      },
      {
        -- spec elsewhere
        "folke/trouble.nvim",
      },
      {
        "nvim-tree/nvim-web-devicons",
      },
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
        cond = function()
          return vim.fn.executable("make") == 1
        end,
      },
      {
        "nvim-telescope/telescope-file-browser.nvim",
      },
      {
        "benfowler/telescope-luasnip.nvim",
      },
      {
        "nvim-telescope/telescope-symbols.nvim",
      },
    },
  },
}

return M
