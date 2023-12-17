local M = {
  {
    -- https://github.com/nvim-neorg/neorg
    "nvim-neorg/neorg",
    ft = "norg",
    cmd = "Neorg",
    event = "VeryLazy",
    build = ":Neorg sync-parsers",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-treesitter/nvim-treesitter-textobjects",
      "nvim-cmp",
      "nvim-lua/plenary.nvim",
    },
    config = function()
      require("plugins.config.neorg").setup()
    end,
  },
}

return M
