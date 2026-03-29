function _G.get_oil_winbar()
  local bufnr = vim.api.nvim_win_get_buf(vim.g.statusline_winid)
  local dir = require("oil").get_current_dir(bufnr)
  if dir then
    return vim.fn.fnamemodify(dir, ":~")
  else
    -- If there is no current directory(eg. over ssh)
    return vim.api.nvim_buf_get_name(0)
  end
end

local oil_lazy_config = function()
  local oil = require("oil")
  local oil_actions = require("oil.actions")
  local oil_config = require("oil.config")
  local oil_layout = require("oil.layout")
  local oil_util = require("oil.util")
  local detail = false

  local BASE_FLOAT_WIDTH = 0.50
  local BASE_FLOAT_HEIGHT = 0.60
  local PREVIEW_FLOAT_WIDTH = 0.90

  ---@param width number
  ---@param height number
  local resize_oil_float = function(width, height)
    local current_win = vim.api.nvim_get_current_win()
    local prev_width = oil_config.float.max_width
    local prev_height = oil_config.float.max_height

    oil_config.float.max_width = width
    oil_config.float.max_height = height
    local win_opts = oil_layout.get_fullscreen_win_opts()
    oil_config.float.max_width = prev_width
    oil_config.float.max_height = prev_height

    if vim.api.nvim_win_is_valid(current_win) then
      vim.api.nvim_win_set_config(current_win, win_opts)
    end
  end

  local toggle_preview_with_resize = function()
    if oil_util.is_floating_win() and not oil_util.get_preview_win() then
      resize_oil_float(PREVIEW_FLOAT_WIDTH, BASE_FLOAT_HEIGHT)
    end

    oil_actions.preview.callback()
  end

  oil.setup({
    default_file_explorer = false,
    -- some of these keymaps are the default, listing them here as documentation.
    keymaps = {
      ["<C-v>"] = { "actions.select", opts = { vertical = true } },
      ["<C-h>"] = { "actions.select", opts = { horizontal = true } },
      ["<C-t>"] = { "actions.select", opts = { tab = true } },
      ["<C-p>"] = { callback = toggle_preview_with_resize, mode = "n" },
      ["<Esc>"] = { "actions.close", mode = "n" },
      ["<C-l>"] = { "actions.refresh" },
      ["g."] = { "actions.toggle_hidden", mode = "n" },
      ["gd"] = {
        desc = "Toggle file detail view",
        callback = function()
          detail = not detail
          if detail then
            require("oil").set_columns({ "icon", "permission", "size", "mtime" })
          else
            require("oil").set_columns({ "icon" })
          end
        end,
      },
    },
    win_options = {
      winbar = "%!v:lua.get_oil_winbar()",
    },
    view_options = {
      show_hidden = true,
    },
    float = {
      max_width = BASE_FLOAT_WIDTH,
      max_height = BASE_FLOAT_HEIGHT,
      preview_split = "right",
      win_options = {
        winblend = 20,
      },
    },
    preview_win = {
      win_options = {
        winblend = 10,
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
