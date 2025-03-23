local M = {
  {
    -- https://github.com/kylechui/nvim-surround
    "kylechui/nvim-surround",
    version = "*", -- Use for stability; omit to use `main` branch for the latest features
    event = "VeryLazy",
    config = true,
  },
  {
    -- https://github.com/windwp/nvim-autopairs
    "windwp/nvim-autopairs",
    event = "VeryLazy",
    config = true,
  },
  {
    -- https://github.com/numToStr/Comment.nvim
    "numToStr/Comment.nvim",
    event = "VeryLazy",
    config = true,
  },
  {
    -- https://github.com/mzlogin/vim-markdown-toc
    "mzlogin/vim-markdown-toc",
    event = "VeryLazy",
    ft = "markdown",
  },
  {
    -- https://github.com/farmergreg/vim-lastplace
    "farmergreg/vim-lastplace",
  },
}

return M
