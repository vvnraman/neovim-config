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
    ["o"] = {
      function()
        oil.toggle_float()
      end,
      "Oil: Toggle float",
    },
    ["<leader>o"] = {
      function()
        oil.open()
      end,
      "Oil: Open",
    },
  }, { prefix = "<leader>" })
end

local M = {
  {
    "stevearc/oil.nvim",
    event = "VeryLazy",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
      -- spec elsewhere
      "folke/which-key.nvim",
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
  {
    -- https://github.com/nvim-neo-tree/neo-tree.nvim
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    event = "VeryLazy",
    cmd = "Neotree",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
      "folke/which-key.nvim",
    },
    init = function()
      if vim.fn.argc(-1) == 1 then
        local stat = vim.loop.fs_stat(vim.fn.argv(0))
        if stat and stat.type == "directory" then
          require("neo-tree")
        end
      end
    end,
    config = function()
      local neotree = require("neo-tree")
      neotree.setup({
        close_if_last_window = true,
        sources = {
          "filesystem",
          "buffers",
          "git_status",
          "document_symbols",
        },
        open_files_do_not_replace_types = {
          "terminal",
          "Trouble",
          "trouble",
          "qf",
          "Outline",
        },
        filesystem = {
          bind_to_cwd = false,
          follow_current_file = { enabled = true },
          use_libuv_file_watcher = true,
        },
        hijack_netrw_behavior = "disabled",
      })
      -- init.lua
      local neotree_command = require("neo-tree.command")
      require("which-key").register({
        ["\\\\"] = {
          function()
            neotree_command.execute({ toggle = true })
          end,
          "Neotree Explore",
        },
        ["\\b"] = {
          function()
            neotree_command.execute({ toggle = true, source = "buffers" })
          end,
          "Neotree Buffers",
        },
        ["\\g"] = {
          function()
            neotree_command.execute({ toggle = true, source = "git_status" })
          end,
          "Neotree Git Status",
        },
      }, {})
    end,
  },
}

return M
