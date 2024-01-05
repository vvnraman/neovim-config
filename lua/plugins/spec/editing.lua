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
    -- https://github.com/monaqa/dial.nvim
    "monaqa/dial.nvim",
    event = "VeryLazy",
    dependencies = {
      "folke/which-key.nvim",
    },
    config = function()
      local dial_map = require("dial.map")

      require("which-key").register({
        ["<C-a>"] = {
          function()
            dial_map.manipulate("increment", "normal")
          end,
          "dial: increment",
        },
        ["<C-x>"] = {
          function()
            dial_map.manipulate("decrement", "normal")
          end,
          "dial: decrement",
        },
        ["g<C-a>"] = {
          function()
            dial_map.manipulate("increment", "gnormal")
          end,
          "dial: g increment",
        },
        ["g<C-x>"] = {
          function()
            dial_map.manipulate("decrement", "gnormal")
          end,
          "dial: g decrement",
        },
      }, { mode = "n" })

      require("which-key").register({
        ["<C-a>"] = {
          function()
            dial_map.manipulate("increment", "visual")
          end,
          "dial: visual increment",
        },
        ["<C-x>"] = {
          function()
            dial_map.manipulate("decrement", "visual")
          end,
          "dial: visual decrement",
        },
        ["g<C-a>"] = {
          function()
            dial_map.manipulate("increment", "gvisual")
          end,
          "dial: g visual increment",
        },
        ["g<C-x>"] = {
          function()
            dial_map.manipulate("decrement", "gvisual")
          end,
          "dial: g visual decrement",
        },
      }, { mode = "v" })
    end,
  },
}

return M
