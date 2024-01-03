-- config extracted here to reduce indentation
local telescope_tabs_lazy_config = function()
  local telescope_tabs = require("telescope-tabs")
  -- copied from https://github.com/LukasPietzschmann/telescope-tabs/wiki/Configs#configs
  telescope_tabs.setup({
    entry_formatter = function(
      tab_id,
      _, --[[ buffer_ids ]]
      _, --[[ file_names ]]
      _, --[[ file_paths ]]
      is_current
    )
      local tab_name = require("tabby.feature.tab_name").get(tab_id)
      return string.format(
        "%d: %s%s",
        tab_id,
        tab_name,
        is_current and " <" or ""
      )
    end,
    entry_ordinal = function(
      tab_id,
      _, --[[ buffer_ids ]]
      _, --[[ file_names ]]
      _, --[[ file_paths ]]
      _ --[[ is_current ]]
    )
      return require("tabby.feature.tab_name").get(tab_id)
    end,
  })

  require("which-key").register({
    ["tt"] = {
      function()
        telescope_tabs.list_tabs()
      end,
      "[t]ab: [t]abs",
    },
    ["<leader>t"] = {
      function()
        telescope_tabs.go_to_previous()
      end,
      "tab: [t]oggle previous",
    },
  }, { prefix = "<leader>" })
end

local M = {
  {
    "nanozuki/tabby.nvim",
    event = "VeryLazy",
    config = function()
      -- active_wins_at_tail
      -- active_wins_at_end
      -- tab_with_top_win
      -- active_tab_with_wins
      -- tab_only
      require("tabby.tabline").use_preset("active_wins_at_tail", {})
    end,
  },
  {
    "LukasPietzschmann/telescope-tabs",
    event = "VeryLazy",
    dependencies = {
      {
        -- spec is elsewhere
        "nvim-telescope/telescope.nvim",
      },
      {
        -- spec is elsewhere
        "folke/which-key.nvim",
      },
      {
        -- spec above
        "nanozuki/tabby.nvim",
      },
    },
    config = telescope_tabs_lazy_config,
  },
}

return M
