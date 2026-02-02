local auto_session_config = function()
  -- Only create session automatically for git repos and my tool config dirs
  local auto_create = function()
    local cmd = "git rev-parse --is-inside-work-tree"
    if vim.fn.system(cmd) == "true\n" then
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
    post_restore_cmds = {
      function(session_name)
        Snacks.notifier.notify(
          "Restored session '" .. session_name .. "'",
          "info",
          { title = "Session Restored" }
        )
      end,
    },
    no_restore_cmds = {
      function()
        Snacks.notifier.notify(
          "No session restored. Run ':AutoSession save' to enable Autosave if not in a git dir or config dir.",
          "info",
          { title = "Session Restored" }
        )
      end,
    },
  }

  local autos = require("auto-session")
  autos.setup(opts)
  vim.keymap.set(
    "n",
    "\\sa",
    "<Cmd>AutoSession toggle<Cr>",
    { desc = "Toggle session autosave" }
  )
  vim.keymap.set("n", "\\ss", "<Cmd>AutoSession search<Cr>", { desc = "Search sessions" })
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
