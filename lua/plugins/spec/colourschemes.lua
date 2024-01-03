--[[
There has to be a better way to pick a colorscheme. I would like to just
specify the colorscheme, which in turn would just make all the other ones be
loaded very lazily.
--]]

local M = {
  {
    "navarasu/onedark.nvim",
    event = "VeryLazy",
    -- priority = 1000,
    config = function()
      -- vim.cmd.colorscheme "onedark"
    end,
  },
  {
    "folke/tokyonight.nvim",
    event = "VeryLazy",
    -- priority = 1000,
    config = function()
      -- vim.cmd.colorscheme "tokyonight"
    end,
  },
  {
    "marko-cerovac/material.nvim",
    event = "VeryLazy",
    -- priority = 1000,
    config = function()
      -- darker
      -- lighter
      -- oceanic
      -- palenight
      -- deep ocean
      vim.g.material_style = "darker"
      require("material").setup({
        contrast = {
          floating_windows = true,
          cursor_line = true,
          non_current_windows = true,
        },
      })
      -- vim.cmd.colorscheme "material"
    end,
  },
  {
    "sam4llis/nvim-tundra",
    event = "VeryLazy",
    -- priority = 1000,
    config = function()
      -- vim.cmd.colorscheme "tundra"
    end,
  },
  {
    "catppuccin/nvim",
    -- event = "VeryLazy",
    priority = 1000,
    config = function()
      require("catppuccin").setup({
        dim_inactive = {
          enabled = true,
        },
        styles = {
          comments = { "italic" },
        },
        integrations = {
          headlines = true,
          indent_blankline = {
            enabled = true,
            scope_color = "lavender", -- catppuccin color (eg. `lavender`) Default: text
            colored_indent_levels = true,
          },
          leap = true,
          symbols_outline = true,
          lsp_trouble = true,
          illuminate = {
            enabled = true,
            lsp = false,
          },
          which_key = true,
        },
      })

      -- catppuccin
      -- catppuccin-latte
      -- catppuccin-frappe
      -- catppuccin-macchiato
      -- catppuccin-mocha
      vim.cmd.colorscheme("catppuccin-mocha")
    end,
  },
  {
    "EdenEast/nightfox.nvim",
    event = "VeryLazy",
    -- priority = 1000,
    config = function()
      -- nightfox
      -- dayfox
      -- dawnfox
      -- duskfox
      -- nordfox
      -- terafox
      -- carbonfox
      -- vim.cmd.colorscheme("nightfox")
    end,
  },
  -- {
  --   -- https://github.com/folke/styler.nvim
  --   "folke/styler.nvim",
  --   config = function()
  --     require("styler").setup({
  --       themes = {
  --         markdown = { colorscheme = "tokyonight-moon" },
  --         rst = { colorscheme = "tokyonight-moon" },
  --         help = { colorscheme = "material-oceanic" },
  --       },
  --     })
  --   end,
  -- },
}

return M
