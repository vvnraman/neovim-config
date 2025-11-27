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
    -- https://github.com/ggandor/leap.nvim
    "ggandor/leap.nvim",
    event = "VeryLazy",
    config = function()
      local leap = require("leap")
      leap.opts.highlight_unlabeled_phase_one_targets = true
      leap.opts.case_sensitive = true
    end,
  },
}

return M
