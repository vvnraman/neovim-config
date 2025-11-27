local M = {
  {
    -- https://github.com/j-hui/fidget.nvim
    "j-hui/fidget.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = true,
  },
  {
    -- https://github.com/aznhe21/actions-preview.nvim
    "aznhe21/actions-preview.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      {
        -- spec elsewhere
        "nvim-telescope/telescope.nvim",
      },
    },
    config = function()
      require("actions-preview").setup({
        telescope = require("telescope.themes").get_dropdown({
          winblend = 20,
        }),
      })
    end,
  },
  {
    -- https://github.com/dgagn/diagflow.nvim
    "dgagn/diagflow.nvim",
    event = "LspAttach",
    opts = {
      scope = "line",
      toggle_event = { "InsertEnter" },
      update_event = { "DiagnosticChanged", "BufReadPost" },
      show_borders = true,
    },
  },
}

return M
