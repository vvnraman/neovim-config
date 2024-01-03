local oil_lazy_config = function()
  local oil = require("oil")
  oil.setup({
    default_file_explorer = false,
    keymaps = {
      ["<C-v>"] = "actions.select_vsplit",
      ["<C-h>"] = "actions.select_split",
      ["<C-t>"] = "actions.select_tab",
      ["<Esc>"] = "actions.close",
    },
    float = {
      max_width = 88,
      max_height = 50,
      win_options = {
        winblend = 20,
      },
    },
    preview = {
      win_options = {
        winblend = 20,
      },
    },
  })

  require("which-key").register({
    o = {
      ["o"] = {
        function()
          oil.toggle_float()
        end,
        "Oil: Toggle float",
      },
      ["l"] = {
        function()
          oil.open()
        end,
        "Oil: Open",
      },
    },
  }, { prefix = "<leader>" })
end

local M = {
  {
    "stevearc/oil.nvim",
    event = "VeryLazy",
    dependencies = {
      {
        "nvim-tree/nvim-web-devicons",
      },
      {
        -- spec elsewhere
        "folke/which-key.nvim",
      },
    },
    config = oil_lazy_config,
  },
  {
    -- https://github.com/prichrd/netrw.nvim
    "prichrd/netrw.nvim",
    config = function()
      local netrw = require("netrw")
      netrw.setup({
        mappings = {
          ["p"] = function(payload)
            -- Payload is an object describing the node under the cursor, the object
            -- has the following keys:
            -- - dir: the current netrw directory (vim.b.netrw_curdir)
            -- - node: the name of the file or directory under the cursor
            -- - link: the referenced file if the node under the cursor is a symlink
            -- - extension: the file extension if the node under the cursor is a file
            -- - type: the type of node under the cursor (0 = dir, 1 = file, 2 = symlink)
            print(vim.inspect(payload))
          end,
        },
      })
    end,
  },
}

return M
