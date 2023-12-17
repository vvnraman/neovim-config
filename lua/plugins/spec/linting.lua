local M = {
  {
    -- https://github.com/stevearc/conform.nvim
    "stevearc/conform.nvim",
    event = "VeryLazy",
    cmd = { "ConformInfo" },
    config = function()
      require("plugins.config.format").setup_conform()
    end,
  },
}

return M
