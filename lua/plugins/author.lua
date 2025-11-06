local M = {
  {
    -- https://github.com/kylechui/nvim-surround
    "kylechui/nvim-surround",
    version = "*", -- Use for stability; omit to use `main` branch for the latest features
    event = "VeryLazy",
    config = function()
      --[[
      AI summary from brave around the conflict between `nvim-surround` and
      `leap.nvim`

      The conflict between leap.nvim's capital S key and nvim-surround's visual
      mode mappings arises because both plugins use the same key combination in
      Visual mode, leading to functionality overlap.

      In leap.nvim, the S key is used for visual mode motions, while
      nvim-surround uses S for visual surround operations.

      This conflict can be resolved by reconfiguring one of the plugins to use
      different key mappings.

      A recommended solution is to configure mini.surround to use
      vim-surround-style mappings such as ys, cs, ds, and vs, which avoids the
      conflict with leap.nvim's default S key.

      Alternatively, users can remap leap.nvim's visual mode keys to use x and
      X instead of s and S, as suggested in discussions where x/X are proposed
      to avoid conflicts with surround plugins, even though this may affect
      muscle memory.

      Another approach is to use gz or gZ for surround operations in
      nvim-surround, which can be set via configuration to prevent conflicts
      with leap.nvim's s/S mappings.

      `leap.nvim` disucssion - https://github.com/ggandor/leap.nvim/discussions/59
      Reddit discussion - https://www.reddit.com/r/neovim/comments/15y4xlj/kylechuinvimsurround_vs_minisurround/


      --]]
      require("nvim-surround").setup()
    end,
  },
  {
    -- https://github.com/windwp/nvim-autopairs
    "windwp/nvim-autopairs",
    event = "VeryLazy",
    opts = {},
  },
  {
    -- https://github.com/numToStr/Comment.nvim
    "numToStr/Comment.nvim",
    event = "VeryLazy",
    opts = {},
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
  {
    -- https://github.com/NMAC427/guess-indent.nvim
    "NMAC427/guess-indent.nvim",
    opts = {},
  },
  {
    -- https://github.com/Wansmer/treesj
    "Wansmer/treesj",
    opts = {},
    keys = {
      { "<leader>sj", "<Cmd>TSJToggle<Cr>", desc = "[s]plit-[j]oin toggle" },
    },
  },
}

return M
