local auto_session_config = function()
  local vvn_util = require("vvn.util")

  ---@param message string
  ---@param level? string
  local notify = function(message, level)
    Snacks.notifier.notify(message, level or "info", { title = "AutoSession" })
  end

  -- Only create session automatically for git repos and my tool config dirs
  local auto_create = function()
    if vvn_util.is_inside_git_worktree() then
      return true
    end
    local tool_config_dirs = {
      "~/.config/nvim",
      "~/.config/fish",
      "~/.config/ghostty",
      "~/.config/alacritty",
      "~/.config/kitty",
      "~/.config/wezterm",
      "~/.config/mako",
      "~/.config/waybar",
      "~/.config/hypr",
      "~/.config/hypr_0.53",
    }
    local cwd = vim.fn.getcwd()
    for _, path in ipairs(tool_config_dirs) do
      if vim.fn.expand(path) == cwd then
        return true
      end
    end
    return false
  end

  ---@module "auto-session"
  ---@type AutoSession.Config
  local opts = {
    enabled = true,
    auto_save = true,
    auto_restore = true,
    auto_create = auto_create,
    bypass_save_filetypes = { "netrw" },
    git_use_branch_name = true,
    custom_session_tag = function(session_name)
      return "autos_" .. session_name
    end,
    purge_after_minutes = 10080, -- 7 days x 24 hours x 60 minutes
    root_dir = vim.fn.stdpath("data") .. "/saved_auto_sessions/",
    show_auto_restore_notif = false,
    session_lens = {
      load_on_setup = false,
    },
    post_restore_cmds = {
      function()
        local session_name = require("auto-session.lib").current_session_name(true) or "unknown"
        notify("Restored session '" .. session_name .. "'")
      end,
    },
    no_restore_cmds = {
      function()
        if vvn_util.is_inside_git_worktree() then
          notify("No session available, one will be created automatically.")
        else
          notify("No session restored. Press '\\ss' to create one and enable autosave.")
        end
      end,
    },
  }

  local autos = require("auto-session")
  autos.setup(opts)
  vim.keymap.set(
    "n",
    "\\st",
    -- "<Cmd>Autosession toggle<Cr>", -- future
    "<Cmd>SessionToggleAutoSave<Cr>",
    { desc = "Toggle session autosave" }
  )
  vim.keymap.set("n", "\\ss", "<Cmd>SessionSave<Cr>", { desc = "Save current session." })
  vim.keymap.set("n", "\\sh", "<Cmd>AutoSession search<Cr>", { desc = "Search sessions" })
end

local M = {
  {
    -- https://github.com/rmagatti/auto-session
    "rmagatti/auto-session",
    lazy = false,
    dependencies = {
      {
        -- https://github.com/folke/snacks.nvim
        "folke/snacks.nvim",
      },
    },
    config = auto_session_config,
  },
}

return M
