local M = {
  {
    "L3MON4D3/LuaSnip",
    config = function()
      require("plugins.config.snippets").setup()
    end,
    event = "InsertEnter",
    dependencies = {
      "rafamadriz/friendly-snippets",
    },
  },
}

return M
