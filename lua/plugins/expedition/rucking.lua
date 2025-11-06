local oil_lazy_config = function()
  local oil = require("oil")
  oil.setup({
    default_file_explorer = false,
    -- some of these keymaps are the default, listing them here as documentation.
    keymaps = {
      ["<C-v>"] = { "actions.select", opts = { vertical = true } },
      ["<C-h>"] = { "actions.select", opts = { horizontal = true } },
      ["<C-t>"] = { "actions.select", opts = { tab = true } },
      ["<C-p>"] = { "actions.preview", mode = "n" },
      ["<Esc>"] = { "actions.close", mode = "n" },
      ["<C-l>"] = { "actions.refresh" },
      ["g."] = { "actions.toggle_hidden", mode = "n" },
    },
    view_options = {
      show_hidden = true,
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

  vim.keymap.set("n", "<leader>o", function()
    oil.toggle_float()
  end, { desc = "Oil: Toggle float" })
  vim.keymap.set("n", "<leader><leader>o", function()
    oil.open()
  end, { desc = "Oil: Open" })
end

local M = {
  {
    "stevearc/oil.nvim",
    event = "VeryLazy",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
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
